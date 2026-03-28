//
//  RegisterResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation

/* {
 "data": {
   "user": {}
 },
 "success": true
}
 */

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    var data: RegisterData?
    var error: JSONNull?
    var errorMessage, msg: String?
    var success: Bool?
}

// MARK: - DataClass
struct RegisterData: Codable {
    var apartment: Apartment?
    var block: Apartment?
    var daireNo, email: String?
    var id: Int?
    var isWaitingForApprove: Bool?
    var name, phoneNumber, registrationDateString, role: String?

    enum CodingKeys: String, CodingKey {
        case apartment, block
        case daireNo = "daire_no"
        case email, id
        case isWaitingForApprove = "is_waiting_for_approve"
        case name
        case phoneNumber = "phone_number"
        case registrationDateString = "registration_date_string"
        case role
    }
}
