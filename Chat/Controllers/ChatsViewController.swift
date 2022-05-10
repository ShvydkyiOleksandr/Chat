//
//  ChatsViewController.swift
//  Chat
//
//  Created by Олександр Швидкий on 06.05.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}

class ChatsViewController: MessagesViewController {
    
    private var messages: [MMessage] = []
    private var messageListener: ListenerRegistration?
    
    private let user: MUser
    private let chat: MChat
    
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = .mainWhite()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
            switch result {
            case .success(var message):
                if let url = message.downloadURL {
                    StorageService.shared.downloadImage(url: url) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(with: "Error!", and: error.localizedDescription)
                        }
                    }
                } else {
                        self.insertNewMessage(message: message)
                }
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
    }
    
    @objc private func cameraButtonPressed() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    private func sendImage(image: UIImage) {
        StorageService.shared.uplodImageMessage(photo: image, to: chat) { result in
            switch result {
            case .success(let url):
                var message = MMessage(user: self.user, image: image)
                message.downloadURL = url
                FirestoreService.shared.sendMessage(chat: self.chat, message: message) { result in
                    switch result {
                    case .success():
                        self.messagesCollectionView.scrollToLastItem()
                    case .failure(_):
                        self.showAlert(with: "Error!", and: "Message not delivered")
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
    }
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainWhite()
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 32, bottom: 6, right: 0)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -24
    }
    
    func configureCameraIcon() {
        let cameraIcon = InputBarButtonItem(type: .system)
        cameraIcon.tintColor = #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1)
        let cameraImage = UIImage(systemName: "camera")!
        cameraIcon.image = cameraImage
        
        cameraIcon.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        cameraIcon.setSize(CGSize(width: 48, height: 48), animated: false)
        
        messageInputBar.leftStackView.alignment = .bottom
        messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
        messageInputBar.setStackViewItems([cameraIcon], forStack: .left, animated: false)
    }
}

// MARK: - MessagesDataSource
extension ChatsViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatsViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatsViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return  isFromCurrentSender(message: message)  ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: user, content: text)
        FirestoreService.shared.sendMessage(chat: chat, message: message) { result in
            switch result {
            case .success():
                self.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item)  % 3 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - MessageCellDelegate
extension ChatsViewController: MessageCellDelegate {
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        sendImage(image: image)
    }
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
}
