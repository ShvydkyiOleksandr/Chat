//
//  WaitingChatsNavigation.swift
//  Chat
//
//  Created by Олександр Швидкий on 05.05.2022.
//

import Foundation

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
