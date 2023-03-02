//
//  DiscoverViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class DiscoverViewController: UIViewController {

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
    var records = [StatusR]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        // add bgGradient
        let bg = UIView()
        view.insertSubview(bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)), at: 0)
        // greetingLabel
        migraineGreetingLabel.text = MigraineGreeting.notMigraine.rawValue
        
        // last recordLabels
        records = container.getRecordsTimeAsc()
        if let record = records.first {
            scoreLabel.text = "\(record.score)"
            symptomLabel.text = record.symptom
            causeLabel.text = record.cause
            placeLabel.text = record.place
            let dateStr = DateFormatter().shortStyleTimeStr(time: record.startTime!)
            startTimeLabel.text = dateStr
            
            
        }
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
