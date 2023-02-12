//
//  ImageExtension.swift
//  Newdio
//
//  Created by najin on 2022/01/09.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 이미지 자르기
    func crop(rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
