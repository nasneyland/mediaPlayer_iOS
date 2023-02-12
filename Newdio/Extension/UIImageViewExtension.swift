//
//  UIImageViewExtension.swift
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

extension UIImageView {
    
//    /// URL 이미지 비동기, 캐싱 처리
//    func setImageUrl(url: String) {
//        let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
//        self.image = UIImage()
//        // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
//        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
//            self.image = cachedImage
//            return
//        } else {
//            DispatchQueue.global(qos: .background).async {
//                if let imageUrl = URL(string: url) {
//                    URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
//                        if let _ = err {
//                            DispatchQueue.main.async {
//                                self.image = UIImage()
//                            }
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            if let data = data, let image = UIImage(data: data) {
//                                // 다운로드된 이미지를 캐시에 저장
//                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
//                                self.image = image
//                            }
//                        }
//                    }.resume()
//                }
//            }
//        }
//    }
}
