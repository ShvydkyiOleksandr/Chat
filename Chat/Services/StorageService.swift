//
//  StorageService.swift
//  Chat
//
//  Created by Олександр Швидкий on 04.05.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth


class StorageService {
    static let shared = StorageService()
    
    let storage = Storage.storage()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
        let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
}
