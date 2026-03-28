//
//  StringExtensions.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation


extension String {
    var decodedUnicode: String {
        let data = self.data(using: .utf8)
        if let data = data,
           let decoded = String(data: data, encoding: .nonLossyASCII) {
            return decoded
        }
        return self
    }
}

extension String {
    func formattedDate() -> String {
        return Utils.shared.parseAndFormatDate(self)
    }
}
