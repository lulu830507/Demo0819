//
//  photoManager.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/30.
//

import Foundation
import UIKit

class PhotoManager {
    
    static let shsared = PhotoManager()
    private var imageCache = NSCache<NSURL, NSData>()
    
    func downloadImage(url:URL, completion: @escaping (UIImage?)-> Void) {
        
        guard let imageData = imageCache.object(forKey: url as NSURL)
              else {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.imageCache.setObject(data as NSData, forKey: url as NSURL)
                completion(image)
            }.resume()
            
            return
            
        }
        
        completion(UIImage(data: imageData as Data))
    }

}
