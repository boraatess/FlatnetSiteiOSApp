//
//  PopupViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 30.09.2025.
//

import Foundation

protocol PopupViewModelInputDelegate: AnyObject {
    func sendReceiptRequest(with docType: String, and fileUrl: URL)
}

protocol PopupViewModelOutputDelegate: AnyObject {
    func showErrorAlert(with title: String, and message: String)
    func showAlert(with title: String, and message: String)
    func showProgressAlert(with fileTotalSize: Float)
}

class PopupViewModel: PopupViewModelInputDelegate {
    
    weak var outputDelegate: PopupViewModelOutputDelegate?
    
    var totalSize: Float = 0.0

    
    func sendReceiptRequest(with docType: String, and fileUrl: URL) {
                
        let url = Constants.shared.docsEndpoint
     
        // 🔹 Security scoped resource erişimini başlat
        let accessGranted = fileUrl.startAccessingSecurityScopedResource()
        defer {
            if accessGranted {
                fileUrl.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let fileData = try Data(contentsOf: fileUrl)
            let mimeType = fileUrl.pathExtension.lowercased() == "pdf" ? "application/pdf" : "image/jpeg"
            
            // 🔹 Dosya boyutu
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
            if let fileSize = fileAttributes[.size] as? NSNumber {
                print("📄 Dosya boyutu: \(fileSize.intValue) bayt")
                
                totalSize = fileSize.floatValue
                
            }
            
            print("✅ Dosya başarıyla okundu, boyut: \(fileData.count) byte, mimeType: \(mimeType)")
            
            // buradan itibaren upload'a devam edebilirsin
            
            let params = ["doc_type": docType]

            NetworkManager.shared.upload(url: url, parameters: params, files: [(fileData, "file", fileUrl.lastPathComponent, mimeType )], responseType: UploadDocumentResponse.self) { result in
                
                switch result {
                    
                case .success(let (response, statusCode)):
                    print(response)
                    print(statusCode)
                    print("✅ Yüklendi: \(response.data?.document?.filename ?? "")")
                
                    self.outputDelegate?.showProgressAlert(with: self.totalSize)
                     
                   //  self.outputDelegate?.showAlert(with: "Başarılı", and: "Dosyanız başarıyla yüklenmiştir.")
                    
                    // Utils.shared.dismissProgress()
                    
                case .failure(let error):
                    print(error)
                    print("❌ Hata: \(error.localizedDescription)")
                    // self.outputDelegate?.showErrorAlert(with: "Hata!", and: error.localizedDescription)
                    
                    self.outputDelegate?.showAlert(with: "Hata!", and: error.localizedDescription)
                    
                    
                }
                
            }
            
        }
        catch {
            print("❌ Dosya okunamadı:", error.localizedDescription)
            
        }
        
    }
    
    
}

/*
 if let fileData = try? Data(contentsOf: fileUrl) {
     let mimeType = fileUrl.pathExtension.lowercased() == "pdf" ? "application/pdf" : "image/jpeg"
     
     // 1️⃣ Dosya boyutunu al
     guard let fileSize = try? FileManager.default.attributesOfItem(atPath: fileUrl.path)[.size] as? NSNumber
     else {
         print("Dosya boyutu alınamadı")
         return
     }
     
     // byte cinsinden
     let totalSize = fileSize.floatValue
         
    
     
 }
 
 */
