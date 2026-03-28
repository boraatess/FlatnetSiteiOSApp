//
//  API.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation


enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ErrorTypes: Error {
    case invalidUrl
    case invalidData
    case generalError
    case serverError(Int)
    
}

