
//
//  JXContentView.swift
//  JXPageContentView
//
//  Created by 晓梦影 on 2017/3/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

import UIKit


protocol JXContentViewDelegate : class{
    func contentView(_ contentView: JXContentView, didEndScroll inIndex: Int)
    
    func contentView(_ contentView: JXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class JXContentView: UIView {

    //  MARK: - 属性
    weak var delegate : JXContentViewDelegate?
    
    
    /// 开始拖拽的时候偏移量
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childVcs: [UIViewController]
    weak fileprivate var parentVc: UIViewController?
    fileprivate var isForbidDelegate : Bool = false //禁止代理，默认是禁止
    
    fileprivate lazy var collectionView : UICollectionView = {
       
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        return collectionView
        
    }()
    
    
    
    
    
    
    init(frame: CGRect,childVcs: [UIViewController], parentVc: UIViewController) {
        
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("content --- deinit")
    }
    
}


//  MARK: - UI
extension JXContentView{
    fileprivate func setupUI(){
    
        // 1.childVcs添加到parentVc
        for childVc in childVcs{
            parentVc?.addChildViewController(childVc)
        }
        
        // 2.添加collectionView
        addSubview(self.collectionView)
    
        
        
        
    }
}

//  MARK: - 数据源
extension JXContentView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        // 1.先删除之前的view
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        // 2.添加view
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        cell.contentView.addSubview(childVc.view)
        
        
        return cell
    }
}

//  MARK: - UICollectionViewDelegate
extension JXContentView : UICollectionViewDelegate{
    /// 减速过程
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    /// 没有减速过程
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 设置
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    /// 拖动的时候调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetX = scrollView.contentOffset.x
        // 0.判断有没有滑动
        guard contentOffsetX != startOffsetX  && !isForbidDelegate else {
            return
        }
        
        var sourceIndex = 0
        var targetIndex = 0
        var progress: CGFloat = 0
        
        // 1.获取参数
        let collectionWidth = collectionView.bounds.width
        if contentOffsetX > startOffsetX { // 左滑
            sourceIndex = Int(contentOffsetX / collectionWidth)
            targetIndex = sourceIndex + 1
            //越界
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            progress = (contentOffsetX - startOffsetX) / collectionWidth
            
            /// 刚好一个屏幕的时候(什么时候停止)
            if (contentOffsetX - startOffsetX) == collectionWidth {
                targetIndex = sourceIndex
            }
            
        }else{ // 右滑
            
            targetIndex = Int(contentOffsetX / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = (startOffsetX - contentOffsetX) / collectionWidth
            
        }
        
        
        
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    
    /// collectionView停止滚动
    private func scrollViewDidEndScroll(){
        
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        delegate?.contentView(self, didEndScroll: index)
    }
    
}


//  MARK: - JXTitleViewDelegate
extension JXContentView : JXTitleViewDelegate{
    
    func titleView(_ titleView: JXTitleView, targetIndex: Int) {
        
        // 0.禁止执行代理方法 (bug：点击title滚动contentView，滚动contentView又调整titleLabel的位置，重复了)
        isForbidDelegate = true
        
        // 1.创建indexPath
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        // 2.滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
    }
}



