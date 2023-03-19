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
    func getTimeDurationStr(start: Date, end: Date, stillGoing: Bool) -> String {
        
        if stillGoing {
            return "頭痛持續中..."
        } else {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
            
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            
            let timeDifference = String(format: "歷時 %d小時%d分", hours, minutes)
            
            return timeDifference
        }
    }
    
    func getTimeDurationStr(start: Date, end: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        let timeDifference = String(format: "目前經歷 %d小時%d分", hours, minutes)
        
        return timeDifference
    }
    
    func getTimeDuration(start: Date, end: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        let totalHours = Double(hours) + Double(minutes) / 60.0
        
        return Double(Int(totalHours * 100)) / 100
    }
}

extension NSObject {
    func nsArrayToStringForUILabel(_ array: NSObject?) -> String {
        guard let nsArray = array as? NSArray else { return RecordStatusWording.noSelect.rawValue }
        if nsArray.count > 1 {
            return "\(nsArray[0])+"
        } else if nsArray.count == 1{
            return "\(nsArray[0])"
        } else {
            return RecordStatusWording.noSelect.rawValue
        }
    }
    
    func toStringArray(_ array: NSObject?) -> [String]? {
        if let nsArray = array as? [String] {
            return nsArray
        } else {
            return nil
        }
    }
    
    func initSymptomValues(_ array: NSObject) -> [Symptom] {
        let nsArray = array as! [String]
        return nsArray.map({Symptom(rawValue: $0)!})
    }
}

func customNavBarAppearance(appearance: String) -> UINavigationBarAppearance {
    let customNavBarAppearance = UINavigationBarAppearance()
    
    switch appearance {
    case "scrollEdgeAppearance":
        // Apply a transparent background.
        customNavBarAppearance.configureWithTransparentBackground()
    case "standardAppearance":
        // Apply a darkBlu background.
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = UIColor(red: 41/255, green: 53/255, blue: 60/255, alpha: 0.9)
    default:
        break
    }
    
    // Apply lightBlu colored normal titles.
    customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.appColor(.lightBlu)!]

    // Apply lightBlu color to all the nav bar buttons.
    let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
    barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.appColor(.lightBlu)!]
    barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.appColor(.lightBlu)!]
    barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
    barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.appColor(.lightBlu)!]
    customNavBarAppearance.buttonAppearance = barButtonItemAppearance
    customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
    customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
    
    return customNavBarAppearance
}
