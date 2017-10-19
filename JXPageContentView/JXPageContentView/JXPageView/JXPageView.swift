
//
//  JXPageView.swift
//  JXPageContentView
//
//  Created by 晓梦影 on 2017/3/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

import UIKit

class JXPageView: UIView {

    var titles: [String]
    var style: JXPageStyle
    var childVcs: [UIViewController]
    weak var parentVc: UIViewController?
    
    init(frame: CGRect, titles:[String], style:JXPageStyle, childVcs:[UIViewController], parentVc:UIViewController) {
        
        // 在super之前初始化属性
        self.titles = titles
        self.style = style;
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("pageView --- deinit")
    }

}

//  MARK: - UI
extension JXPageView{
    
    fileprivate func setupUI(){
        
        // 1.创建titleView
        let titleFrame = CGRect(x: 0, y: 0, width:bounds.width, height: style.titleHeight)
        let titlesView = JXTitleView(frame: titleFrame, titles: titles, style: style)
        titlesView.backgroundColor = UIColor(hexString: "##FF6528")
        addSubview(titlesView)
        
        // 2.创建contentView
        let contentViewFram = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - titleFrame.maxY)
        assert(parentVc != nil, "parentVc must not nil")
        guard let parentVc = parentVc else {
            return
        }
        let contentView = JXContentView(frame: contentViewFram, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        
        // 3.让titleView跟contentView沟通
        titlesView.delegate = contentView
        contentView.delegate = titlesView
        
    }
}

