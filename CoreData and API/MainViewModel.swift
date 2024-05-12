//
//  MainViewModel.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//aa642d62a1344b179433ebe125baf575

import UIKit

class MainViewModel: NSObject {
    
    func registerTableView(tableView: UITableView, completion: @escaping (() -> Void)) {
        tableView.register(UINib(nibName: K.XIBCell.userDetailsInfoCell, bundle: nil), forCellReuseIdentifier: K.XIBCell.userDetailsInfoCell)
        
        completion()
    }
    
    
    func getDataFromAPI(completion: @escaping (Result<[UserInfoModel], Error>) -> Void) {
        guard let url = URL(string: K.endPoints.urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let jsonData = data else {
                print("Error: No data received")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode([UserInfoModel].self, from: jsonData)
                completion(.success(decodedData))
                debugPrint("Userdata \(decodedData)")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func deleteDataInAPI(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: K.endPoints.urlString+"/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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


