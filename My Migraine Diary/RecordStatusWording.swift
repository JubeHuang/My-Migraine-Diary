//
//  RecordStatusWording.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import Foundation

enum RecordStatusWording: String, CaseIterable {
    case noSelect = "無"
    case notKnow = "不清楚"
}

enum Symptom: String, CaseIterable {
    case nausea = "噁心"
    case vomit = "想吐"
    case light = "怕光"
    case noise = "怕吵"
    case dizzy = "頭暈"
    case tension = "緊縮性頭痛"
    case pulsating = "搏動性疼痛"
    case migraine = "單側頭痛"
    case pounding = "陣陣抽痛"
    case other = "其他"
    case notKnow = "不清楚"
    case noSelect = "無"
}

//視覺預兆：眼冒金星、光點閃爍、盲點擴大，或只是模糊不清。感覺異常：以手臂與臉為主。針刺感，甚至半邊癱軟無力。語言障礙：口齒不清，或是失語症狀。聽幻覺
enum Sign: String, CaseIterable {
    case tired = "疲倦哈欠"
    case 腸胃不適
    case 胃口改變
    case 鬱悶焦躁
    case 頸部僵硬
    case 視覺預兆
    case 感覺異常
    case 語言障礙
    case 聽幻覺
    case other = "其他"
    case notKnow = "不清楚"
    case noSelect = "無"
}

enum Cause: String, CaseIterable {
    case period = "生理期"
    case temp = "溫度變化"
    case weather = "天氣"
    case pressure = "壓力"
    case hunger = "飢餓"
    case light = "光刺激"
    case food = "食物"
    case alcho = "酒精"
    case noise = "聲音"
    case sleep = "睡眠不足"
    case med = "藥物"
    case other = "其他"
    case notKnow = "不清楚"
    case noSelect = "無"
}

enum Place: String, CaseIterable {
    case home = "家"
    case work = "公司"
    case school = "學校"
    case transit = "交通中"
    case bed = "床上"
    case out = "戶外"
    case other = "其他"
    case notKnow = "不清楚"
}

enum MedEffect: String, CaseIterable {
    case no = "無效果"
    case little = "有點效果"
    case good = "非常有效"
    case noSelect = "無服用"
}

enum Med: String, CaseIterable {
    case 止痛藥
    case 非類固醇消炎止痛藥
    case 麥角胺
    case 翠普登
    case noSelect = "無服用"
}
