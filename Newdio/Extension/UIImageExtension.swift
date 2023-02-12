//
//  UIImageExtension.swift
//  Newdio
//
//  Created by najin on 2021/10/03.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init (){}
}

extension UIImage {
    
    /// URL 이미지 비동기, 캐싱 처리 (저장)
    func setUrlImage(url: String) {
        
        let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
        
        if let _ = ImageCacheManager.shared.object(forKey: cacheKey) {
            return
        } else {
            // 해당 Key 에 캐시이미지가 저장되어 있지 않으면 이미지 로드
            DispatchQueue.global(qos: .background).async {
                if let imageUrl = URL(string: url) {
                    URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                        if let _ = err {
                            return
                        }
                        DispatchQueue.main.async {
                            if let data = data, let image = UIImage(data: data) {
                                // 다운로드된 이미지를 캐시에 저장
                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    // URL 이미지 비동기, 캐싱 처리 (불러오기)
    func getUrlImage(url: String) -> UIImage {
        
        let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
        
        // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            return cachedImage
        } else {
            DispatchQueue.global(qos: .background).async {
                if let imageUrl = URL(string: url) {
                    URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                        if let _ = err {
                            DispatchQueue.main.async {
                                return
                            }
                            return UIImage
                        }
                        DispatchQueue.main.async {
                            if let data = data, let image = UIImage(data: data) {
                                // 다운로드된 이미지를 캐시에 저장
                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                return image
                            }
                        }
                    }.resume()
                }
            }
        }
    }
}
