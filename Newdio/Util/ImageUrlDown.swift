//
//  ImageUrlDown.swift
//  Newdio
//
//  Created by sg on 2021/11/09.
//

import Foundation
import UIKit

func imgUrlDown(url: String) -> UIImage {
    var sendImg = UIImage()
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
                            sendImg = UIImage()
                        }
                    }
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            // 다운로드된 이미지를 캐시에 저장
                            ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                           sendImg = image
                        }
                    }
                }.resume()
            }
        }
    }

    return sendImg
}
