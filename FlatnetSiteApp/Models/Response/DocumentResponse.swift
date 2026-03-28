//
//  DocumentResponse.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 29.09.2025.
//

import Foundation

// MARK: - DocumentsResponse
struct DocumentsResponse: Codable {
    var data: [Documents]?
    var success: Bool?
}

// MARK: - Datum
struct Documents: Codable {
    var docType, downloadURL, filename: String?
    var id: Int?
    var uploadDate: String?

    enum CodingKeys: String, CodingKey {
        case docType = "doc_type"
        case downloadURL = "download_url"
        case filename, id
        case uploadDate = "upload_date"
    }
}

struct displayedSections {
    let imageName: String
    let sectionName: String
    let documents: [Documents]
    var isExpanded: Bool

}

struct displayedDocuments {
    let docType, downloadURL, filename: String
    let id: Int
    let uploadDate: String
    var isExpanded: Bool
    
}

// MARK: - UploadDocumentResponse
struct UploadDocumentResponse: Codable {
    var data: UploadDocumentData?
    var success: Bool?
}

// MARK: - DataClass
struct UploadDocumentData: Codable {
    var document: Document?
}

// MARK: - Document
struct Document: Codable {
    var docType, filename: String?
    var id: Int?
    var uploadDate: String?

    enum CodingKeys: String, CodingKey {
        case docType = "doc_type"
        case filename, id
        case uploadDate = "upload_date"
    }
}
