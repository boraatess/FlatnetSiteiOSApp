//
//  Constants.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation

// https://www.flatnetsite.com/api/v1/login


class Constants {
    
    static let shared = Constants()

    let baseUrl = "https://www.flatnetsite.com/api/v1"
    
    lazy var craftsmenEndpoint = baseUrl + "/craftsmen/"
    
    // https://www.flatnetsite.com/api/v1/financials/monthly_summar
    
    lazy var financialsEnpoint = baseUrl + "/financials/monthly_summary"
    
    lazy var pollsEnpoint = baseUrl + "/polls"

    lazy var pushNotificationEndpoint = baseUrl + "/devices/register"
    
    lazy var apartmentsEndpoint = baseUrl + "/apartments"
    
    lazy var checkVersion = baseUrl + "/version-check"
    
    lazy var requestEndpoint = baseUrl + "/requests"
    
    lazy var docsEndpoint = baseUrl + "/documents"
    
    lazy var deleteProfileEndpoint = baseUrl + "/profile/delete"

    lazy var termsOfUseUrl = "https://www.flatnetsite.com/kullanim-sartlari"
    
    lazy var kvkkUrl = "https://www.flatnetsite.com/kvkk-aydinlatma-metni"

    lazy var privacyUrl = "https://www.flatnetsite.com/gizlilik-politikasi"
    
    
    
}
