//
//  NetworkManager.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation
import UIKit
import Alamofire

// MARK: - Optional EmptyBody
struct EmptyBody: Encodable {}

struct TalepResponse: Decodable {
    let success: Bool
    let message: String
    // backend’inin döndürdüğü alanlara göre ekle
}

// MARK: - NetworkManager
class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - GET request (body yok)
    func getRequest<T: Decodable>(type: T.Type,method: HTTPMethods, url: String,
        completion: @escaping (Result<T, ErrorTypes>) -> Void) {
        
        Utils.shared.showProgress()
        
        // Headers
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Authorization header
        if let token = AuthManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        // URL check
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        // Data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Network error
            if let error = error {
                print("❌ Network error:", error.localizedDescription)
                completion(.failure(.generalError))
                Utils.shared.dismissProgress()

                return
            }
            
            // Status code check
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.generalError))
                Utils.shared.dismissProgress()

                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Server error:", httpResponse.statusCode)
                completion(.failure(.serverError(httpResponse.statusCode)))
                Utils.shared.dismissProgress()

                return
            }
            
            // Data check
            guard let data = data else {
                completion(.failure(.invalidData))
                Utils.shared.dismissProgress()

                return
            }
            
            // Debug raw response
            if let raw = String(data: data, encoding: .utf8) {
                print("📥 Response:", raw)
                Utils.shared.dismissProgress()

            }
            
            // Decode JSON
            self.handleResponse(data: data, completion: completion)
            
        }.resume()
        
    }

    /// Generic request function
    /// // MARK: - POST/PUT/DELETE request

    func request<T: Decodable, U: Encodable>(type: T.Type, url: String, parameters: [String: Any]? = nil, method: HTTPMethods, body: U? = nil, completion: @escaping (Result<T, ErrorTypes>) -> Void ) {
        
        Utils.shared.showProgress()
        
        // Headers
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Authorization header
        if let token = AuthManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        // URL check
        guard let urlObject = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: urlObject)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

                
        // URL query ekleme:
        if let parameters = parameters, method == .get {
            var components = URLComponents(string: url)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            guard let newUrl = components?.url else {
                completion(.failure(.invalidUrl))
                return
            }
            request.url = newUrl
        }

        // JSON body ekleme:
        
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase // <-- burayı ekle
                encoder.outputFormatting = .withoutEscapingSlashes
                let data = try encoder.encode(body)
                request.httpBody = data
                
                if let json = String(data: data, encoding: .utf8) {
                    print("📦 Giden body JSON: \(json)")
                }
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }
        
        print("Headers: \(headers)")
        
        // Data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Network error
            if let error = error {
                print("❌ Network error:", error.localizedDescription)
                completion(.failure(.generalError))
                Utils.shared.dismissProgress()

                return
            }
            
            // Status code check
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.generalError))
                Utils.shared.dismissProgress()

                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Server error:", httpResponse.statusCode)
                completion(.failure(.serverError(httpResponse.statusCode)))
                Utils.shared.dismissProgress()

                return
            }
            
            // Data check
            guard let data = data else {
                completion(.failure(.invalidData))
                Utils.shared.dismissProgress()

                return
            }
            
            // Debug raw response
            if let raw = String(data: data, encoding: .utf8) {
                print("📥 Response:", raw)
            }
            
            // Decode JSON
            self.handleResponse(data: data, completion: completion)
            
        }.resume()
    }
    
    // MARK: - Response Handler
    fileprivate func handleResponse<T: Decodable>( data: Data, completion: @escaping (Result<T, ErrorTypes>) -> Void ) {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decoded))
        } catch {
            print("❌ Decode error:", error)
            completion(.failure(.invalidData))
        }
        Utils.shared.dismissProgress()

    }
    
    func upload<T: Decodable>( url: String, method: HTTPMethod = .post,
            parameters: [String: String] = [:],
            files: [(data: Data, name: String, fileName: String, mimeType: String)] = [],
                                      responseType: T.Type,
                               completion: @escaping (Result<(T, Int), Error>) -> Void ) {
        
        Utils.shared.showProgress()
        
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        if let token = AuthManager.shared.accessToken {
            headers.add(.authorization(bearerToken: token))
        }
        
        AF.upload(multipartFormData: { formData in
            // Parametreler
            for (key, value) in parameters {
                formData.append(Data(value.utf8), withName: key)
            }
            
            // Dosyalar
            for file in files {
                formData.append(file.data,
                                withName: file.name,
                                fileName: file.fileName,
                                mimeType: file.mimeType)
            }
        }, to: url, method: method, headers: headers)
        .responseDecodable(of: responseType) { response in
            
            var succesCode: Int = 0
            // Status code yakalama
             if let statusCode = response.response?.statusCode {
                 print("Status Code: \(statusCode)")
                 succesCode = statusCode
             }
             
            debugPrint(response)
            
            print("Raw Response String:", response.value ?? "")

            switch response.result {
            case .success(let decoded):
                print("Raw JSON:", decoded)
                
                completion(.success((decoded, succesCode)))
                Utils.shared.dismissProgress()
                
            case .failure(let error):
                completion(.failure(error))
                Utils.shared.dismissProgress()

            }
        }
        
        Utils.shared.dismissProgress()

        
    }

    
}
