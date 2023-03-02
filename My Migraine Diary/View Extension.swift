//
//  View Extension.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import Foundation
import UIKit

extension UIView {
    func bgGradient(frame: CGRect) -> UIView {
        let gradientLayer = CAGradientLayer()
        let gradientView = UIView()
        gradientLayer.type = .axial
        gradientLayer.colors = [CGColor(red: 41/255, green: 53/255, blue: 60/255, alpha: 100), CGColor(red: 56/255, green: 78/255, blue: 91/255, alpha: 100)]
        gradientLayer.frame = frame
        gradientView.frame = gradientLayer.frame
        gradientView.layer.addSublayer(gradientLayer)
        return gradientView
    }
}

extension DateFormatter {
    func shortStyleTimeStr(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: time)
    }
}

extension Calendar {
    func getTimeDurationStr(start: Date, end: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        let timeDifference = String(format: "歷時 %d小時%d分", hours, minutes)
        
        return timeDifference
    }
}

