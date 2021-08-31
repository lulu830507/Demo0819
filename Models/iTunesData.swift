//
//  iTunesData.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/22.
//

import Foundation
import UIKit

class DataController {
    static let dataUpdatedNotification = Notification.Name("DataController.orderUpdated")
    static let shared = DataController()
    
    let baseURL = URL(string: "https://itunes.apple.com/search?term=TheFastandtheFurious&media=")!
    
    func fetchMusic(completion: @escaping (Result<[SongType], Error>) -> Void) {
        let musicURL = baseURL.appendingPathComponent("music")
        let task = URLSession.shared.dataTask(with: musicURL) {
            data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let musicResponse = try jsonDecoder.decode(SongResults.self, from: data)
                    completion(.success(musicResponse.results))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func fetchMovie(completion: @escaping (Result<[MovieType], Error>) -> Void) {
        let movieURL = baseURL.appendingPathComponent("movie")
        let task = URLSession.shared.dataTask(with: movieURL) {
            data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let movieResponse = try jsonDecoder.decode(MovieResults.self, from: data)
                    completion(.success(movieResponse.results))
                } catch {
                    completion(.failure(error))
                }
            }  else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchImage(urlStr: String, completion: @escaping (UIImage?) -> ()) {
        
        let urlStr1000 = urlStr.replacingOccurrences(of: "100x100", with: "1000x1000")
        if let url = URL(string: urlStr1000) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
//    internal struct ITuneController {
//        internal static let shared = ITuneController()
//
//        // MARK: - Download Data
//        func fetchITuneData(completion: @escaping ([SongType]?) -> ()) {
//
//            let urlStr = "https://itunes.apple.com/search?term=TheFastandtheFurious&media=music"
//            if let url = URL(string: urlStr) {
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data = data, let iTuneData = try? JSONDecoder().decode(SongResults.self, from: data) {
//                        completion(iTuneData.results)
//                    } else {
//                        completion(nil)
//                    }
//                }.resume()
//            }
//        }
//        func fetchImage(urlStr: String, completion: @escaping (UIImage?) -> ()) {
//
//            let urlStr1000 = urlStr.replacingOccurrences(of: "100x100", with: "1000x1000")
//            if let url = URL(string: urlStr1000) {
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data = data, let image = UIImage(data: data) {
//                        completion(image)
//                    } else {
//                        completion(nil)
//                    }
//                }.resume()
//            }
//        }
//
//    }
}
