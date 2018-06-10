//
//  Extensions.swift
//  Cartotheque
//
//  Created by Tim on 10.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

extension UILabel {
    static func standard(font: UIFont?) -> UILabel {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = font != nil ? font : l.font
        return l
    }
}

extension UIColor {
    static func wetAsphalt() -> UIColor {
        return UIColor(hex: 0x34495e)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
