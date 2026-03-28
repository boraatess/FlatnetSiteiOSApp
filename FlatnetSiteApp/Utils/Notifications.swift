//
//  Notifications.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 1.10.2025.
//

import Foundation

public class APNS {
    public init(deviceToken data: Data) {
        self.data = data
        self.string = data.map { data in String(format: "%02.2hhx", data) }.joined()
    }

    public let data: Data
    public let string: String
}

extension Data {
    
    var hexString: String {
        let hexStr = map { String(format: "%02.2hhx", $0) }.joined()
        return hexStr
    }
    
}
