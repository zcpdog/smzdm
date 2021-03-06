//
//  ZZSwiftCommon.swift
//  什么值得买
//
//  Created by Wang_ruzhou on 16/10/8.
//  Copyright © 2016年 Wang_ruzhou. All rights reserved.
//

import Foundation
import YYKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth  = YYScreenSize().width
let kScreenHeight = YYScreenSize().height
let kScreenScale  = YYScreenScale()

let kGlobalGrayColor      = UIColor.init(hexString: "#666666")
let kGlobalRedColor       = UIColor.init(hexString: "#F04848")
let kGlobalBlueColor      = UIColor.init(hexString: "#1F2F6C")
let kGlobalLightGrayColor = UIColor.init(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)

let kLineSpacing: CGFloat = 5
let kZDMPadding: CGFloat = 10


@objc protocol ZZActionDelegate: NSObjectProtocol{
    @objc func itemDidClick(redirectData: ZZRedirectData)
}

extension String {
    static func zz_string(floatValue: Float) -> String? {
        let number = NSNumber.init(value: floatValue)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: number)
    }
}

extension NSAttributedString {
    static func commonAttributedText(title: String) -> NSAttributedString {
        let text = NSMutableAttributedString.init(string: title)
        text.lineSpacing = 10
        text.lineBreakMode = .byTruncatingTail
        text.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        return text
    }
}
