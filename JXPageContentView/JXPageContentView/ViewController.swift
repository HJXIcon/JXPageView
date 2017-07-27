//
//  ViewController.swift
//  JXPageContentView
//
//  Created by 晓梦影 on 2017/3/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "pageView"
        
        automaticallyAdjustsScrollViewInsets = false
        
        let title = ["适合","十二班","的华","推荐爱推荐爱","人丹33","适合","十二班","的华"]
        var style = JXPageStyle()
        style.isScrollEnable = true
        
        var childVcs = [UIViewController]()
        
        for _ in 0..<title.count{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
            
            childVcs.append(vc)
        }
        
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let pageView = JXPageView(frame: pageViewFrame, titles: title, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

