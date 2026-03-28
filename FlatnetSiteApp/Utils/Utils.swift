//
//  Utils.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 10.09.2025.
//

import Foundation
import UIKit
import SVProgressHUD


class Utils {

    static let shared = Utils()
    
    
    func showAutoDismissAlert(title: String?, message: String, duration: TimeInterval,
           viewController: UIViewController, completion: (() -> Void)? = nil ) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           viewController.present(alert, animated: true)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
               alert.dismiss(animated: true, completion: completion)
           }
      
    }
    
    func getStatusBarHeight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = windowScene.statusBarManager {
            return statusBarManager.statusBarFrame.height
        }
        return 0
        
    }
    
    func parseAndFormatDate(_ dateString: String) -> String {
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",   // Z'li (UTC)
            "yyyy-MM-dd'T'HH:mm:ss"     // Z'siz
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        
        var parsedDate: Date? = nil
        
        for format in possibleFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                parsedDate = date
                break
            }
        }
        
        guard let finalDate = parsedDate else {
            return dateString // parse edilemezse orijinali dondur
        }
        
        // Output format
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.string(from: finalDate)
    }

    
    func formatDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // Türkçe ay isimleri
        
        // 1. API’den gelen string -> Date
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        // 2. Date -> istediğin format
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }

    func showProgress() {
        SVProgressHUD.show()
    }

    func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    
    func call(number: String) {
         let cleanedNumber = number.replacingOccurrences(of: " ", with: "")
         if let phoneURL = URL(string: "tel://\(cleanedNumber)") {
             if UIApplication.shared.canOpenURL(phoneURL) {
                 UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
             } else {
                 print("Arama yapılamıyor.")
             }
         }
     }
    
}
