//
//  Color Enum.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/9.
//

import UIKit.UIColor

enum ColorSet: String {
    case bluishGrey1
    case bluishGrey2
    case pink
    case darkBlu
    case lightBlu
    case lightGrey
}

extension UIColor {
    static func appColor(_ name: ColorSet) -> UIColor? {
             return UIColor(named: name.rawValue)
    }
}
