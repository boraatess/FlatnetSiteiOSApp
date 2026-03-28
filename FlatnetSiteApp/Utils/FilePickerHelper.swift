//
//  FilePickerHelper.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import AVFoundation

enum FileSource {
    case camera
    case gallery
    case document
}

protocol FilePickerHelperdelegate: AnyObject {
    func checkPermission(with usable: Bool)
}

class FilePickerHelper: NSObject {
    
    private weak var presentingVC: UIViewController?
    private var completion: ((URL?) -> Void)?
    
    weak var delegate: FilePickerHelperdelegate?

    init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
    }

    func pickFile(from source: FileSource, completion: @escaping (URL?) -> Void) {
        self.completion = completion
        
        guard let presentingVC = presentingVC else {
            print("⚠️ presentingVC nil")
            return
        }

        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                presentingVC.present(picker, animated: true)
            } else {
                completion(nil)
            }

        case .gallery:
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            presentingVC.present(picker, animated: true)
        case .document:
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .pdf, .jpeg, .png, .text])
            picker.delegate = self
            presentingVC.present(picker, animated: true)
        }
    }
    
    func checkCameraUsability(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    
    private func openCamera(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        presentingVC?.present(picker, animated: true)
    }
    
}

extension FilePickerHelper: UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        defer {
            picker.dismiss(animated: true)
        }
        
        if let url = info[.imageURL] as? URL {
            completion?(url)
            
        } else if let image = info[.originalImage] as? UIImage {
            // Kameradan geleni kaydedip URL üretelim
            if let data = image.jpegData(compressionQuality: 0.8) {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
                try? data.write(to: tempURL)
                completion?(tempURL)
            } else {
                completion?(nil)
            }
        } else {
            completion?(nil)
            
        }
        
    }
}

extension FilePickerHelper: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completion?(urls.first)
    }
}
