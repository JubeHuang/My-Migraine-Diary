//
//  CustomTabbar.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import UIKit

class CustomTabbar: UITabBarController {
    override func viewDidLoad() {
        //setting select & unselect tabBtn color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.appColor(.lightBlu)!]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.appColor(.bluishGrey1)!]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.appColor(.bluishGrey1)
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.appColor(.lightBlu)
        tabBarAppearance.backgroundColor = UIColor.appColor(.darkBlu)
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
