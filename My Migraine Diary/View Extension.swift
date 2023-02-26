//
//  View Extension.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import Foundation
import UIKit

extension UIView {
    func bgGradient(view: UIView){
        let gradientLayer = CAGradientLayer()
        let gradientView = UIView()
        gradientLayer.type = .axial
        gradientLayer.colors = [CGColor(red: 41/255, green: 53/255, blue: 60/255, alpha: 100), CGColor(red: 56/255, green: 78/255, blue: 91/255, alpha: 100)]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        gradientView.frame = gradientLayer.frame
        gradientView.layer.addSublayer(gradientLayer)
        view.insertSubview(gradientView, at: 0)
    }
}
