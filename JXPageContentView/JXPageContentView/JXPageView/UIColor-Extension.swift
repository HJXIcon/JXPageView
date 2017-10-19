
//
//  UIColor-Extension.swift
//  JXPageContentView
//
//  Created by 晓梦影 on 2017/3/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor{
        
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
    }
    
    /*!
     
     convenience 扩展构造函数
     1> 必须convenience
     2> 必须调用self.init()原来的某一个构造函数
     
     */
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0 ) {
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    
    
    // 构造函数不能够返回nil，加上一个？号就可以了
    convenience init?(hexString:String) {
        
        // 1.判断字符串长度是否大于6
        guard hexString.characters.count > 6 else {
            return nil
        }
        
        
        // 2.将字符转成大写
        var  hexTempString = hexString.uppercased()
        
        // 3.判断字符是否是X0/##FF0053
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##") {
           hexTempString = (hexTempString as NSString).substring(from: 2)
            
        }
        
        // 4。判断字符是否是以#开头
        if hexTempString.hasPrefix("#") {
            hexTempString = (hexTempString as NSString).substring(from: 1)
            
        }
        
        // 5.获取RGB分别对应的16进制
        // r:FF g:00 b:22
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with:range)
        
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with:range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with:range)
        
        //6.将十六进制转成数值
        var r : UInt32 = 0
        var g : UInt32 = 0
        var b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
        
    }
    
}


//  MARK: - 从颜色重获取RGB
extension UIColor {
    // r g b
    func getNomalRGB() -> ( CGFloat, CGFloat, CGFloat){
        
        guard let cmps = cgColor.components else {
            
            //throws
            fatalError("请确定带颜色是通过RGB创建的")
            
        }
        
        return (cmps[0] * 255,cmps[1] * 255,cmps[2] * 255)
    }
}





