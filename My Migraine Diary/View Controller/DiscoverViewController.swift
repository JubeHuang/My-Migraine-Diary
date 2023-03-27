//
//  DiscoverViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData
import Charts
import GoogleMobileAds

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var adView: GADBannerView!
    @IBOutlet weak var causeBarChart: BarChartView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet var articleTitles: [UILabel]!
    @IBOutlet var articleBtns: [UIButton]!
    @IBOutlet weak var endRecordBtn: UIButton!
    @IBOutlet weak var timeOnBtnLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var migraineGreetingLabel: UILabel!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    var container: NSPersistentContainer!
    var records = [Record]()
    var articles = [Item]()
    var timer: Timer?
    
    let adUnitID = "ca-app-pub-3940256099942544/2934735716" //test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBgUI()
        
        // googleAdsBanner
        adView.adUnitID = adUnitID
        adView.rootViewController = self
        adView.load(GADRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // last recordLabels
        records = container.getRecordsTimeAsc()
        if let record = records.first {
            updateLastRecordUI(record: record)
            
            // chart
            let averageTime = Chart.calculateAveTime(records: records)
            let recordTimes = Chart.calculateRecordTimes(records: records)
            Chart.convertCombinesChart(dataEntryX: Chart.monthArray, dataEntryY: averageTime, dataEntryZ: recordTimes, combineView: chartView)
            
            let causeEachTime = Chart.calculateCauseEachTimes(records: records)
            Chart.convertBarChart(dataEntryX: Cause.allCases.map(\.rawValue), dataEntryY: causeEachTime, barView: causeBarChart)
        } else {
            // 無紀錄
            unfinRecordUI(show: false)
            noRecordUI()
            
            let zeroArray = Array(repeating: 0.0, count: 12)
            Chart.convertCombinesChart(dataEntryX: Chart.monthArray, dataEntryY: zeroArray, dataEntryZ: zeroArray, combineView: chartView)
            Chart.convertBarChart(dataEntryX: Cause.allCases.map(\.rawValue), dataEntryY: zeroArray, barView: causeBarChart)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenWidth = view.bounds.width
        if screenWidth == 430 {
            scrollViewHeight.constant = 1128
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let stillGoing = records.first?.stillGoing else { return }
        if stillGoing {
            timer?.invalidate()
        }
    }
    
    func updateBgUI(){
        // add bgGradient
        let bg = UIView()
        view.insertSubview(bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)), at: 0)
        
        // secondView hide
        causeBarChart.isHidden = true
        
        // fetch article
        let group = DispatchGroup()
        group.enter()
        ArticleController.shared.fetchArticle(language: "zh") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        group.wait()
        
        // 文章不滿兩則
        group.enter()
        if self.articles.count < 2 {
            ArticleController.shared.fetchArticle(language: "en") { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let articles):
                    self.articles.append(contentsOf: articles)
                    self.updateApiUI(articles: self.articles)
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        
        // segmentUI
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.appColor(.bluishGrey2)!], for: .normal)
    }
    
    // 沒有任何紀錄
    func noRecordUI(){
        scoreLabel.text = "?"
        durationLabel.text = ""
        startTimeLabel.text = "未來某年某月某日"
        causeLabel.text = "未知"
        placeLabel.text = "未知"
        symptomLabel.text = "未知"
    }
    
    func updateLastRecordUI(record: Record) {
        scoreLabel.text = "\(record.score)"
        symptomLabel.text = record.symptom?.nsArrayToStringForUILabel(record.symptom)
        causeLabel.text = record.cause?.nsArrayToStringForUILabel(record.cause)
        placeLabel.text = record.place ?? RecordStatusWording.noSelect.rawValue
        
        let dateStr = DateFormatter().shortStyleTimeStr(time: record.startTime!)
        startTimeLabel.text = dateStr
        durationLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: record.endTime!, stillGoing: record.stillGoing)
        timeOnBtnLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: Date.now)
        
        unfinRecordUI(show: record.stillGoing)
    }
    
    // 文章圖片
    func updateApiUI(articles: [Item]){
        DispatchQueue.main.async {
            for i in 0...1 {
                
                self.articleTitles[i].text = articles[i].title
                
                // fetch article image
                ArticleController.shared.fetchImage(url: articles[i].urlToImage) { image in
                    DispatchQueue.main.async {
                        self.articleBtns[i].configuration?.background.image = image
                    }
                }
            }
        }
    }
    
    // 控制未完成紀錄大按鈕區塊顯示
    func unfinRecordUI(show: Bool) {
        migraineGreetingLabel.text = show ? MigraineGreeting.didMigraine.rawValue : MigraineGreeting.notMigraine.rawValue
        timeOnBtnLabel.isHidden = !show
        endRecordBtn.isHidden = !show
        addBtn.isHidden = show
        
        if show {
            
            // 30秒刷新一次經歷時間
            timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
                
                self.timeOnBtnLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: (self.records.first?.startTime)!, end: Date.now)
                print("timer+1")
            })
        }
    }
    
    @IBAction func controlSegment(_ sender: UISegmentedControl) {
        
        chartView.isHidden = sender.selectedSegmentIndex != 0
        causeBarChart.isHidden = sender.selectedSegmentIndex == 0
        
        
    }
    
    @IBAction func addRecord(_ sender: Any) {
        performSegue(withIdentifier: "showRecord", sender: nil)
    }
    
    @IBAction func refineRecord(_ sender: Any) {
        performSegue(withIdentifier: "showRecord", sender: records.first)
    }
    
    @IBAction func tapArticle(_ sender: UIButton) {
        guard let index = articleBtns.firstIndex(of: sender) else { return }
        // 有拿到文章資料才能往下頁
        if !articles.isEmpty {
            performSegue(withIdentifier: "showArticle", sender: articles[index])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            // 前往文章webView
        case "showArticle":
            let article = sender as! Item
            let destiController = segue.destination as! WebViewController
            destiController.url = article.url
            destiController.title = article.title
            
            // 前往紀錄頁
        case "showRecord":
            let controller = segue.destination as! RecordStatusTableViewController
            controller.delegate = self
            // 新增紀錄
            if sender == nil {
                controller.title = "新增紀錄"
            } else {
                // 更新紀錄
                controller.record = sender as? Record
                controller.title = "更新紀錄"
            }
        default:
            break
        }
    }
}

extension DiscoverViewController: RecordStatusTableViewControllerDelegate {
    func recordStatusTableViewControllerDelegate(_ controller: RecordStatusTableViewController, record: Record) {
        print(record.stillGoing, "stillGoing")
        updateLastRecordUI(record: record)
    }
}
