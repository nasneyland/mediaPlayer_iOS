//
//  TopNewsPageViewController.swift
//  Newdio
//
//  Created by najin on 2021/10/02.
//

import UIKit
import Pageboy

class TopNewsPageViewController: PageboyViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers.append(vc1)
        self.viewControllers.append(vc2)
        self.viewControllers.append(vc3)
        self.viewControllers.append(vc4)
        
        
    }
}

//MARK:- Extension


