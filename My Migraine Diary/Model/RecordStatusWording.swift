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
    case light = "怕光"
    case noise = "怕吵"
    case dizzy = "頭暈"
    case tension = "緊縮性頭痛"
    case pulsating = "搏動性疼痛"
    case migraine = "單側頭痛"
    case pounding = "陣陣抽痛"
    case otherSymptom = "其他"
    case notKnowSymptom = "不清楚"
    case noSelectSymptom = "無"
}

enum Sign: String, CaseIterable {
    case tired = "疲倦哈欠"
    case stomach = "腸胃不適"
    case appetite = "胃口改變"
    case depressed = "鬱悶焦躁"
    case neck = "頸部僵硬"
    case vision = "視覺預兆"
    case strange = "感覺異常"
    case language = "語言障礙"
    case hallucination = "聽幻覺"
    case otherSign = "其他"
    case notKnowSign = "不清楚"
    case noSelectSign = "無"
}

enum Cause: String, CaseIterable {
    case period = "生理期"
    case temp = "溫度變化"
    case weather = "天氣"
    case pressure = "壓力"
    case hunger = "飢餓"
    case photostimulation = "光刺激"
    case food = "食物"
    case alcho = "酒精"
    case sound = "聲音"
    case sleep = "睡眠不足"
    case med = "藥物"
    case otherCause = "其他"
    case notKnowCause = "不清楚"
    case noSelectCause = "無"
}

enum Place: String, CaseIterable {
    case home = "家"
    case work = "公司"
    case school = "學校"
    case transit = "交通中"
    case bed = "床上"
    case out = "戶外"
    case otherPlace = "其他"
    case notKnowPlace = "不清楚"
}

enum MedEffect: String, CaseIterable {
    case no = "無效果"
    case little = "有點效果"
    case good = "非常有效"
    case noSelectMedEffect = "無服用"
}

enum Med: String, CaseIterable {
    case painkiller = "止痛藥"
    case NSAIDs = "非類固醇消炎止痛藥"
    case ergotamine = "麥角胺"
    case tripton = "翠普登"
    case noSelectMed = "無服用"
}
