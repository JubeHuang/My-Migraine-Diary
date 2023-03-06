//
//  DiscoverViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class DiscoverViewController: UIViewController {

   
    @IBOutlet var articleTitles: [UILabel]!
    @IBOutlet var articleImages: [UIImageView]!
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
    var stillGoing: Bool?
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
        } else {
            unfinRecordUI(show: false)
        }
    }
    
    @IBSegueAction func showEmptyRecord(_ coder: NSCoder) -> RecordStatusTableViewController? {
        let controller = RecordStatusTableViewController(coder: coder)
        controller?.delegate = self
        controller?.title = "新增紀錄"
        return controller
    }
    @IBSegueAction func showUnfinRecord(_ coder: NSCoder) -> RecordStatusTableViewController? {
        let controller = RecordStatusTableViewController(coder: coder)
        controller?.delegate = self
        controller?.record = records.first
        controller?.title = "更新紀錄"
        return controller
    }
    
    func updateBgUI(){
        // add bgGradient
        let bg = UIView()
        view.insertSubview(bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)), at: 0)
        
        // fetch article
        ArticleController.shared.fetchArticle(language: "zh") { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(error)
            }
        }
        if articles.count < 2 {
            ArticleController.shared.fetchArticle(language: "en") { result in
                switch result {
                case .success(let articles):
                    self.articles.append(contentsOf: articles)
                    self.updateApiUI(articles: self.articles)
                case .failure(let error):
                    print(error)
                }
            }
        }
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
                        self.articleImages[i].image = image
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DiscoverViewController: RecordStatusTableViewControllerDelegate {
    func recordStatusTableViewControllerDelegate(_ controller: RecordStatusTableViewController, record: Record) {
        print(record.stillGoing, "stillGoing")
        unfinRecordUI(show: record.stillGoing)
        updateLastRecordUI(record: record)
    }
}
