//
//  JXTitleView.swift
//  JXPageContentView
//
//  Created by 晓梦影 on 2017/3/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

import UIKit

protocol JXTitleViewDelegate : class{
    
    func titleView(_ titleView : JXTitleView, targetIndex : Int)
}


class JXTitleView: UIView {
    
    //  MARK: - 属性
    weak var delegate : JXTitleViewDelegate?

    fileprivate var titles: [String]
    fileprivate var style: JXPageStyle
    fileprivate lazy var nomalRGB : (CGFloat, CGFloat, CGFloat) = self.style.normalColor.getNomalRGB()
    fileprivate lazy var selectRGB : (CGFloat, CGFloat, CGFloat) = self.style.selectColor.getNomalRGB()
    fileprivate lazy var deltaRGB : (CGFloat, CGFloat, CGFloat) = {
        
        let delatR = self.selectRGB.0 - self.nomalRGB.0
        let delatG = self.selectRGB.1 - self.nomalRGB.1
        let delatB = self.selectRGB.2 - self.nomalRGB.2
        
        return(delatR, delatG, delatB)
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
        
    }()
    
    
    fileprivate lazy var bottomLine : UIView = {
       
        let bottomLine = UIView()
        bottomLine.backgroundColor  = self.style.bottomLineColor
        return bottomLine
    }()
    
    fileprivate var  currentIndex : Int = 0 // 默认0
    
    // 标题Label数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    
    init(frame: CGRect,titles: [String],style: JXPageStyle) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//  MARK: - UI
extension JXTitleView {
    
    fileprivate func setupUI() {
        
        // 1.添加ScrollView
        addSubview(self.scrollView)
        
        // 2.添加Lable
        setupTitleLabels()
        
        // 3.初始化底部line
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
    }
    
    private func setupBottomLine(){
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
        
    }
    
    
    private func setupTitleLabels(){
        
        for(i, title) in titles.enumerated(){
            
            // 1.创建label
            let label = UILabel()
            label.isUserInteractionEnabled = true
            label.tag = i
            label.text = title
            label.textAlignment = .center
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.font = style.titleFont
            
            // tap
            // tagGes外部参数，如果不希望有外部参数，在外部参数前加上_
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            
            label.addGestureRecognizer(tap)
            //添加
            scrollView.addSubview(label)
            
            // 添加到数组
            titleLabels.append(label)
        }
        
        // 2.设置Label的frame
        let labelH : CGFloat = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = bounds.width / CGFloat(titles.count)
        var labelX : CGFloat = 0
        
        for (i , titleLabel) in titleLabels.enumerated(){
            if style.isScrollEnable { // 可以滚动
                
                let size = CGSize(width: CGFloat(MAXFLOAT), height: 0)
                labelW = (titleLabel.text! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                
                labelX = i == 0 ? style.titleMargin * 0.5: (titleLabels[i - 1].frame.maxX + style.titleMargin)
                
            }else{ // 不能滚动
                
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        
        // 4.设置contentSize
        
        if style.isScrollEnable {
        
            self.scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
        // 5.设置缩放
        if style.isNeedScale {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScaleRang, y: style.maxScaleRang)
        }
        
        
    }
}


//  MARK: - 点击事件
extension JXTitleView{
    func titleLabelClick(_ tagGes : UITapGestureRecognizer){
        
        guard let  targetLabel = tagGes.view as? UILabel else {
            return
        }
        
        //0.判断是不是之前点击的label
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        print(targetLabel.tag)
        // 1.让之前的label不选中，现在的选中
        let sourceLabel = titleLabels[currentIndex]
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        currentIndex = targetLabel.tag
        
        if self.style.isScrollEnable {
            // 2.调整点击label的位置
            adjustLabelPosition()
        }
        
        
        // 3.通知代理
        delegate?.titleView(self, targetIndex: currentIndex)
        
        // 4.调整bottomLine的位置
        if style.isShowBottomLine {
           UIView.animate(withDuration: 0.25, animations: { 
            self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
            self.bottomLine.frame.size.width = targetLabel.frame.size.width
            
           })
            
        }
        
        // 5.调整文字缩放
        if style.isNeedScale {
            UIView.animate(withDuration: 0.25, animations: {
                
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScaleRang, y: self.style.maxScaleRang)
            })
        }
       
    }
    
    
    /// 调整label的位置函数
    fileprivate func adjustLabelPosition(){
        
        let targetLabel = titleLabels[currentIndex]
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        scrollView.setContentOffset(CGPoint(x : offsetX, y : 0), animated: true)
    }
}


//  MARK: - JXContentViewDelegate
extension JXTitleView : JXContentViewDelegate {
    func contentView(_ contentView: JXContentView, didEndScroll inIndex: Int) {
        currentIndex = inIndex
        
        if self.style.isScrollEnable {
            ///调整点击label的位置
            adjustLabelPosition()
        }
    }
    
    func contentView(_ contentView: JXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        // 1
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.颜色渐变
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: nomalRGB.0 + deltaRGB.0 * progress, g: nomalRGB.1 + deltaRGB.1 * progress, b: nomalRGB.2 + deltaRGB.2 * progress)
        
        print(progress)
        
        // 3.调整底部滑动条(width和x)
        if style.isShowBottomLine {
            let detaWidth = targetLabel.frame.width - sourceLabel.frame.width
            let detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            bottomLine.frame.size.width = sourceLabel.frame.width + detaWidth * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + detaX * progress
            
        }
        
        // 4.缩放变化
        if style.isNeedScale {
            let detaScale = style.maxScaleRang - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScaleRang - detaScale * progress, y: style.maxScaleRang - detaScale * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1 + detaScale * progress, y: 1 + detaScale * progress)
            
        }
        
        
    }
}



