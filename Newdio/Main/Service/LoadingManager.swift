//
//  LoadingManager.swift
//  Newdio
//
//  Created by najin on 2021/11/07.
//

import Foundation
import UIKit
import Gifu

class LoadingManager {
    
    // MARK: - Properties
    
    private static let sharedInstance = LoadingManager()
    
    private var backgroundView: UIView?
    private var loadingView: UIView?
    private var loadingImageView: UIImageView?
    
    // MARK: - Helpers
    
    class func show() {
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        let loadingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        loadingView.backgroundColor = .darkGray.withAlphaComponent(0.5)
        loadingView.layer.cornerRadius = 25
        
        let loadingImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        loadingImageView.animationImages = LoadingManager.getAnimationImageArray()
        loadingImageView.animationDuration = 0.8
        loadingImageView.animationRepeatCount = 0
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundView)
            window.addSubview(loadingView)
            window.addSubview(loadingImageView)
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            loadingView.center = window.center
            
            loadingImageView.center = window.center
            loadingImageView.startAnimating()
            
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.loadingView?.removeFromSuperview()
            sharedInstance.loadingImageView?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.loadingImageView = loadingImageView
            sharedInstance.loadingView = loadingView
        }
    }
    
    class func hide() {
        if let backgroundView = sharedInstance.backgroundView,
           let loadingView = sharedInstance.loadingView,
           let loadingImageView = sharedInstance.loadingImageView {
            loadingImageView.stopAnimating()
            backgroundView.removeFromSuperview()
            loadingView.removeFromSuperview()
            loadingImageView.removeFromSuperview()
        }
    }

    private class func getAnimationImageArray() -> [UIImage] {
        var animationArray: [UIImage] = []
        animationArray.append(UIImage(named: "loading1")!)
        animationArray.append(UIImage(named: "loading2")!)
        animationArray.append(UIImage(named: "loading3")!)
        animationArray.append(UIImage(named: "loading4")!)
        return animationArray
    }
}
