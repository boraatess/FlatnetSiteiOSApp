//
//  PushNotifyResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import Foundation


// MARK: - PushNotification
struct PushNotifyResponse: Codable {
    let data: NotificationDataClass
    let error: JSONNull?
    let errorMessage, msg: String
    let success: Bool
}

// MARK: - DataClass
struct NotificationDataClass: Codable {
    let msg: String
}

