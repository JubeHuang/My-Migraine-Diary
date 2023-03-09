//
//  Greeting.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/23.
//

import Foundation

enum Greeting: String, CaseIterable {
    case welcomeBack = "歡迎回來"
    case welcomeNewFriend = "歡迎新朋友"
}

enum MigraineGreeting: String, CaseIterable {
    case notMigraine = "今天紀錄頭痛了嗎？"
    case didMigraine = "辛苦了，正在經歷偏頭痛..."
}
