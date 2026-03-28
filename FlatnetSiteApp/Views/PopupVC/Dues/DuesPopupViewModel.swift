//
//  DuesPopupViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation

protocol DuesPopupViewModelInputDelegate: AnyObject {
    func sendReceiptRequest(with id: Int, and fileUrl: URL)
}

protocol DuesPopupViewModelOutputDelegate: AnyObject {
    func showAlert(with title: String, and message: String)
    func showProgressAlert(with fileTotalSize: Float)
}


class DuesPopupViewModel: DuesPopupViewModelInputDelegate {
    
    @Published var selectedFileUrl: URL?
    
    weak var outputdelegate: DuesPopupViewModelOutputDelegate?
    
    var totalSize: Float = 0.0
    
    func sendReceiptRequest(with id: Int, and fileUrl: URL) {
        
        let url = Constants.shared.baseUrl + "/dues/\(id)/receipt"
        
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
            
            // byte cinsinden
            
            NetworkManager.shared.upload(url: url, parameters: [:], files: [(fileData, "file", fileUrl.lastPathComponent, mimeType )], responseType: ReceiptResponse.self) { result in
                
                switch result {
                    
                case .success(let (response, statusCode)):
                    print(response)
                    print(statusCode)
                    self.outputdelegate?.showProgressAlert(with: self.totalSize)
                    print("✅ Yüklendi: \(response.data.receipt_url)")
                    
                    // self.outputdelegate?.showAlert(with: "Başarılı", and: "Dosyanız başarıyla yüklenmiştir. Yöneticinizin onayını bekliyoruz.")
                    
                case .failure(let error):
                    print(error)
                    print("❌ Hata: \(error.localizedDescription)")
                    self.outputdelegate?.showAlert(with: "Hata!", and: error.localizedDescription)
                    
                }
                
            }
            
        } catch {
            print("❌ Dosya okunamadı:", error.localizedDescription)
        }
        
        
    }
        
}
