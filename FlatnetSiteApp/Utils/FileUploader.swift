//
//  FileUploader.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 4.10.2025.
//

import Foundation
import UIKit
import SVProgressHUD

protocol FileUploaderDelegate: AnyObject {
    func checkUploadResult(success: Bool)
    
}

class FileUploader {

    weak var delegate: FileUploaderDelegate?
    
    /// Dosya yükleme simülasyonu
    func uploadFile(fileSize: Float) {
        // 1️⃣ Dosya boyutunu al
        /*guard let fileSize = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? NSNumber else {
            print("Dosya boyutu alınamadı")
            return
        }
         */
        
        // 2️⃣ Progress başlat
        SVProgressHUD.showProgress(0, status: "Yükleniyor...")

        // 3️⃣ Simülasyon: 10 parça halinde yükleme
        let chunks = 10
        
        for i in 1...chunks {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                // Yüklenen miktar
                let uploaded = fileSize * Float(i) / Float(chunks)
                let progress = uploaded / fileSize

                // Progress HUD güncelle
                SVProgressHUD.showProgress(progress, status: "Yükleniyor \(Int(progress*100))%")

                // Yükleme tamamlandığında
                if i == chunks {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "Yükleme tamamlandı!")
                    self.delegate?.checkUploadResult(success: true)
                    
                }
                
            }
            
        }
        
    }
    
}
