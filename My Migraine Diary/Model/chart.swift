//
//  chart.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/7.
//

import UIKit
import Charts

class Chart {
    
    static let monthArray = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    
    static let lightGrey = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    static let pink = UIColor(red: 242/255, green: 169/255, blue: 124/255, alpha: 1)
    
    static func convertCombines(dataEntryX forX:[String],dataEntryY 線條圖: [Double], dataEntryZ 直條圖: [Double], combineView: CombinedChartView) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntrieszor: [ChartDataEntry] = []
        
        for (i, v) in 線條圖.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
            dataEntrieszor.append(dataEntry)
        }
        
        for (i, v) in 直條圖.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
            dataEntries.append(dataEntry)
        }
        
        let lineChartSet = LineChartDataSet(entries: dataEntrieszor, label: "平均時長(小時)")
        let lineChartData = LineChartData(dataSets: [lineChartSet])
        
        let barChartSet = BarChartDataSet(entries: dataEntries, label: "頭痛次數")
        let barChartData = BarChartData(dataSets: [barChartSet])
        
        // barchart num
        barChartSet.drawValuesEnabled = false
        
        // cancel dot
        lineChartSet.drawCirclesEnabled = false
        lineChartSet.mode = .cubicBezier
        lineChartSet.valueTextColor = pink
        lineChartSet.valueFont = .systemFont(ofSize: 9)
        // line color & width
        lineChartSet.setColor(pink)
        lineChartSet.lineWidth = 2
        
        // make gradient
        lineChartSet.drawFilledEnabled = true
        lineChartSet.fillColor = pink
        lineChartSet.fillAlpha = 1
        // 漸變顏色數組
        let gradientColors = [CGColor(red: 242/255, green: 169/255, blue: 124/255, alpha: 1), CGColor(red: 242/255, green: 169/255, blue: 124/255, alpha: 0.1)] as CFArray
        // 每組顏色所在位置（範圍0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        // 生成漸變色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //將漸變色作為填充對象
        lineChartSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        barChartSet.setColor(lightGrey)
        
        let comData = CombinedChartData(dataSets: [lineChartSet,barChartSet])
        comData.barData = barChartData
        comData.lineData = lineChartData
        
        combineView.data = comData
        combineView.notifyDataSetChanged()
        
        combineView.xAxis.valueFormatter = IndexAxisValueFormatter(values: forX)
        combineView.xAxis.granularity = 1
        
        // hidden grid
        combineView.xAxis.drawGridLinesEnabled = false
        combineView.leftAxis.drawGridLinesEnabled = false
        combineView.rightAxis.drawGridLinesEnabled = false
        // 隱藏右邊欄位的資料
//        combineView.rightAxis.enabled = false
        // 隱藏左邊欄位的資料
        combineView.leftAxis.enabled = false
        // animation
        combineView.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInQuad)
        
        // 關閉 x 軸縮放
        combineView.scaleXEnabled = false
        // 關閉 y 軸縮放
        combineView.scaleYEnabled = false
        // 關閉雙擊縮放
        combineView.doubleTapToZoomEnabled = false
        
    }
    
    static func calculateAveTime(records: [Record]) -> [Double] {
        
        var monthAveHours = Array(repeating: 0.0, count: 12)
        var monthRecordCounts = Array(repeating: 0.0, count: 12)
        
        for record in records {
            
            let durationHours = Calendar(identifier: .chinese).getTimeDuration(start: record.startTime!, end: record.endTime!)
            let calendar = Calendar.current
            let monthComponent = calendar.component(.month, from: record.startTime!)
            
            monthAveHours[monthComponent-1] += durationHours
            monthRecordCounts[monthComponent-1] += 1
        }
        
        for i in 0..<monthAveHours.count {
            if monthRecordCounts[i] > 0 {
                monthAveHours[i] /= monthRecordCounts[i]
            }
        }
        
        return monthAveHours
    }
    
    static func calculateRecordTimes(records: [Record]) -> [Double] {
        
        var monthRecordCounts = Array(repeating: 0.0, count: 12)
        
        for record in records {
            
            let calendar = Calendar.current
            let monthComponent = calendar.component(.month, from: record.startTime!)
            
            monthRecordCounts[monthComponent-1] += 1
        }
        
        return monthRecordCounts
    }
}
