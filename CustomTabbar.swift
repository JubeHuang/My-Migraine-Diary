//
//  CustomTabbar.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import Foundation
import UIKit

class CustomTabbar: UITabBarController {
    override func viewDidLoad() {
        //setting select & unselect tabBtn color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "lightBlu")!]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "bluishGrey")!]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "bluishGrey")!
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "lightBlu")!
        tabBarAppearance.backgroundColor = UIColor(named: "darkBlu")
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
