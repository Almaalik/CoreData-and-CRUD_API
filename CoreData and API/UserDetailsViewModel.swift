//
//  UserDetailsViewModel.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 12/05/24.
//

import UIKit

class UserDetailsViewModel: NSObject {
    
    
    func postDataToAPI(data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: K.endPoints.urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func putDataToAPI(id: String, data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: K.endPoints.urlString+"/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
}
