//
//  ApartmentsResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 21.09.2025.
//

import Foundation

/* {
 "data": [
   {
     "id": 1,
     "name": "Blue Life-1"
   }
 ],
 "success": true
}
 */

struct ApartmentsResponse: Codable {
    
    let data: [Apartment]
    let success: Bool
    
}

struct BlocksResponse: Codable {
    
    let data: [Apartment]
    let success: Bool
    
}
