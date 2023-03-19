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
    
    static func convertCombinesChart(dataEntryX forX:[String],dataEntryY 線條圖: [Double], dataEntryZ 直條圖: [Double], combineView: CombinedChartView) {
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
        lineChartSet.mode = .horizontalBezier
        // 次數格式
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: formatter)
        lineChartSet.valueFormatter = valuesNumberFormatter
        lineChartSet.valueTextColor = UIColor.appColor(.pink)!
        lineChartSet.valueFont = .systemFont(ofSize: 9)
        
        // line color & width
        lineChartSet.setColor(UIColor.appColor(.pink)!)
        lineChartSet.lineWidth = 2
        
        // make gradient
        lineChartSet.drawFilledEnabled = true
        lineChartSet.fillColor = UIColor.appColor(.pink)!
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
        
        // data textColor
        combineView.legend.textColor = .white
        
        // hidden grid
        combineView.xAxis.drawGridLinesEnabled = false
        combineView.leftAxis.drawGridLinesEnabled = false
        combineView.rightAxis.drawGridLinesEnabled = false

        // 隱藏左邊欄位的資料
        combineView.leftAxis.enabled = false
        // animation
        combineView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInQuad)
        
        // 關閉 x 軸縮放
        combineView.scaleXEnabled = false
        // 關閉 y 軸縮放
        combineView.scaleYEnabled = false
        // 關閉雙擊縮放
        combineView.doubleTapToZoomEnabled = false
    }
    
    static func convertBarChart(dataEntryX forX:[String], dataEntryY 直條圖: [Double], barView: BarChartView) {
        var dataEntries: [BarChartDataEntry] = []
        
        for (i, v) in 直條圖.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
            dataEntries.append(dataEntry)
        }
        
        let barChartSet = BarChartDataSet(entries: dataEntries, label: "誘因次數")
        let barChartData = BarChartData(dataSets: [barChartSet])
        
        // 次數格式
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: formatter)
        
        barChartSet.valueFormatter = valuesNumberFormatter
        barChartSet.valueTextColor = UIColor.appColor(.pink)!
        barChartSet.valueFont = .systemFont(ofSize: 9)
        barChartSet.setColor(lightGrey)
        
        barView.data = barChartData
        barView.notifyDataSetChanged()
        
        barView.xAxis.valueFormatter = IndexAxisValueFormatter(values: forX)
        // x label custom
        barView.xAxis.labelCount = forX.count
        barView.xAxis.labelRotationAngle = -30
        barView.xAxis.axisMinimum = 0
        barView.xAxis.axisMaximum = Double(forX.count - 1)
        barView.xAxis.granularity = 1
        barView.xAxis.forceLabelsEnabled = true
        barView.xAxis.granularityEnabled = true
        
        barView.leftAxis.granularity = 1
        
        // data textColor
        barView.legend.textColor = .white
        
        // hidden grid
        barView.xAxis.drawGridLinesEnabled = false
        barView.leftAxis.drawGridLinesEnabled = false
        barView.rightAxis.drawGridLinesEnabled = false
        
        // 隱藏左右邊欄位的資料
        barView.leftAxis.enabled = false
        barView.rightAxis.enabled = false
        // animation
        barView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInQuad)
        
        // 關閉 x 軸縮放
        barView.scaleXEnabled = false
        // 關閉 y 軸縮放
        barView.scaleYEnabled = false
        // 關閉雙擊縮放
        barView.doubleTapToZoomEnabled = false
        barChartSet.highlightEnabled = false
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
    
    static func calculateCauseEachTimes(records: [Record]) -> [Double] {
        
        let titles = Cause.allCases.map(\.rawValue)
        var causeEachTimes = Array(repeating: 0.0, count: titles.count)
        
        for record in records {
            
            if let causeStrs = record.cause?.toStringArray(record.cause) {
                
                for i in 0..<causeStrs.count{
                    
                    if let index = titles.firstIndex(of: causeStrs[i]) {
                        
                        causeEachTimes[index] += 1
                    }
                }
            }
        }
        return causeEachTimes
    }
    
}

class ChartValueFormatter: NSObject, ValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}
