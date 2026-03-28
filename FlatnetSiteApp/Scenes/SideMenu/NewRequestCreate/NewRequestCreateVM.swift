//
//  NewRequestCreateVM.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 12.09.2025.
//

import Foundation

protocol NewRequestCreateVMInputDelegate: ViewModelProtocol {
    func getRequestOptions()
    func sendCreateNewRequest(with fileUrl: URL?)
    
}

protocol NewRequestCreateVMOutputDelegate: ViewModelOutputProtocol {
    func configureOptions(categories: [Category], locations: [Category], priorities: [Category])
    func showError(_ error: String)
    func showAlert(with title: String, and message: String)
    func showProgressAlert(with fileTotalsize: Float)
}


class NewRequestCreateVM: NewRequestCreateVMInputDelegate {
    
    typealias T = NewRequestCreateVMOutputDelegate
    weak var outputDelegate: T?
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var descriptionTextview: String = ""
    @Published var category: Category?
    @Published var priority: Category?
    @Published var location: Category?

    var totalSize: Float = 0.0

    
    func getRequestOptions() {
        
        let url = Constants.shared.baseUrl + "/requests/options"
        
        NetworkManager.shared.getRequest(type: RequestOptionsResponse.self, method: .get, url: url) { result in
            
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                
                self.outputDelegate?.configureOptions(categories: response.data.categories, locations: response.data.locations, priorities: response.data.priorities)
                
                
            case .failure(let error):
                print(error.localizedDescription)
                self.outputDelegate?.showError(error.localizedDescription)
            }
            
        }
        
    }
    
    func sendCreateNewRequest(with fileUrl: URL?) {
        
        let url = Constants.shared.requestEndpoint

        print("title : \(title)")
        print("description : \(descriptionTextview)")
        print("category : \(category?.key ?? "")")
        print("priority : \(priority?.key ?? "")")
        print("location : \(location?.key ?? "")")
        
        print("file url : \(fileUrl)")

        var params: [String: String] = [:]
            
        if let categoryValue = category?.key, let priorityValue = priority?.key,
           let locationValue = location?.key {
            // Zorunlu alanlar
            params = [ "title": title, "description": descriptionTextview,
                "category": categoryValue, "priority": priorityValue,
                "location": locationValue ]
        }
        
        // Opsiyonel dosya
        var files: [(data: Data, name: String, fileName: String, mimeType: String)] = []

        if let fileUrl = fileUrl, let fileData = try? Data(contentsOf: fileUrl) {
            let mimeType = fileUrl.pathExtension.lowercased() == "pdf" ? "application/pdf" : "image/jpeg"
            
            files.append((
                data: fileData,
                name: "file",
                // backend’in beklediği parametre ismi
                fileName: fileUrl.lastPathComponent,
                mimeType: mimeType
                // dosya tipine göre değiştir (jpg/png/pdf)
                
            ))
            self.calculateFiletotalSize(with: fileUrl)
            self.outputDelegate?.showProgressAlert(with: self.totalSize)

        }
        
        NetworkManager.shared.upload(url: url, parameters: params, files: files, responseType: CreateRequestResponse.self) { result in
            
            print("params : \(params)")
            
            print(result)
        
            switch result {
                
            case .success(let (response, statusCode)):
                print(response)
                print(statusCode)
                self.outputDelegate?.showAlert(with: "Başarılı", and: "Talebiniz başarıyla oluşturuldu.")
                
            case .failure(let error):
                print(error)
                self.outputDelegate?.showAlert(with: "Hata!", and: error.localizedDescription)
                
            }
            
        }

        
    }
    
    private func calculateFiletotalSize(with fileUrl: URL) {
        
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
            
            
            
        }
        catch {
            print("❌ Dosya okunamadı:", error.localizedDescription)
            
        }
        
    }
    
}
