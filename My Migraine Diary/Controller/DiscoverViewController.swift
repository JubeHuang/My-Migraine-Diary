//
//  DiscoverViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData
import Charts

class DiscoverViewController: UIViewController {

   
    @IBOutlet weak var seconedChart: UIView!
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
    
    var container: NSPersistentContainer!
    var records = [Record]()
    var articles = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBgUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // last recordLabels
        records = container.getRecordsTimeAsc()
        if let record = records.first {
            updateLastRecordUI(record: record)
            unfinRecordUI(show: record.stillGoing)
            
            // chart
            let averageTime = Chart.calculateAveTime(records: records)
            let recordTimes = Chart.calculateRecordTimes(records: records)
            Chart.convertCombines(dataEntryX: Chart.monthArray, dataEntryY: averageTime, dataEntryZ: recordTimes, combineView: chartView)
        } else {
            unfinRecordUI(show: false)
            noRecordUI()
            let zeroArray = Array(repeating: 0.0, count: 12)
            Chart.convertCombines(dataEntryX: Chart.monthArray, dataEntryY: zeroArray, dataEntryZ: zeroArray, combineView: chartView)
        }
    }
    
    func updateBgUI(){
        // add bgGradient
        let bg = UIView()
        view.insertSubview(bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)), at: 0)
        
        // secondChart hide
        seconedChart.isHidden = true
        
        // fetch article
        ArticleController.shared.fetchArticle(language: "zh") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(error)
            }
        }
        if articles.count < 2 {
            ArticleController.shared.fetchArticle(language: "en") { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let articles):
                    self.articles.append(contentsOf: articles)
                    self.updateApiUI(articles: self.articles)
                case .failure(let error):
                    print(error)
                }
            }
        }
        migraineGreetingLabel.text = MigraineGreeting.notMigraine.rawValue
    }
    
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
        symptomLabel.text = record.symptom?.nsArrayToStringForLabel(record.symptom)
        causeLabel.text = record.cause?.nsArrayToStringForLabel(record.cause)
        placeLabel.text = record.place ?? RecordStatusWording.noSelect.rawValue
        let dateStr = DateFormatter().shortStyleTimeStr(time: record.startTime!)
        startTimeLabel.text = dateStr
        timeOnBtnLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: Date.now, str: "目前經歷")
        durationLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: record.endTime!, stillGoing: record.stillGoing)
        if record.stillGoing {
            migraineGreetingLabel.text = MigraineGreeting.didMigraine.rawValue
        } else {
            migraineGreetingLabel.text = MigraineGreeting.notMigraine.rawValue
        }
    }
    
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
    
    func unfinRecordUI(show: Bool) {
        timeOnBtnLabel.isHidden = !show
        endRecordBtn.isHidden = !show
        addBtn.isHidden = show
    }

    @IBAction func controlSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            chartView.isHidden = false
            seconedChart.isHidden = true
        } else {
            chartView.isHidden = true
            seconedChart.isHidden = false
        }
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
        unfinRecordUI(show: record.stillGoing)
        updateLastRecordUI(record: record)
    }
}
