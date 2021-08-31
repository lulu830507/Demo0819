//
//  ApiService.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/30.
//

import Foundation

let baseURL = "https://www.instagram.com/fastandfuriousde/?__a=1"
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol ApiService {
    
}
extension ApiService {
    
    static func sendRequest<T>(body:Data? = nil, method:HTTPMethod, reponse: T.Type ,completion: @escaping (Result<T,Error>)->Void) where T:Decodable {
        
        let url = URL(string: "\(baseURL)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = String(data: data, encoding: .utf8)
                
                print("[API] response:\(json)")
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(reponse, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
}

