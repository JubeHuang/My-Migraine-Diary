//
//  RecordStatusTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

protocol RecordStatusTableViewControllerDelegate: AnyObject {
    func recordStatusTableViewControllerDelegate(_ controller: RecordStatusTableViewController, record : Record)
}

class RecordStatusTableViewController: UITableViewController {
    
    @IBOutlet weak var stillGoingBtn: UIButton!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet var scorBtns: [UIButton]!
    @IBOutlet weak var quantitySegment: UISegmentedControl!
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBOutlet weak var medCell: StatusBtnTableViewCell!
    @IBOutlet weak var placeCell: StatusBtnTableViewCell!
    @IBOutlet weak var causeCell: StatusBtnTableViewCell!
    @IBOutlet weak var signCell: StatusBtnTableViewCell!
    @IBOutlet weak var symptomCell: StatusBtnTableViewCell!
    @IBOutlet weak var effectCell: StatusBtnTableViewCell!
    
    var score = 0
//    var records = [Record]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var delegate: RecordStatusTableViewControllerDelegate?
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let record {
            showUnfinUI(record: record)
        } else {
            updateUI()
        }
    }
    
    @IBAction func tapStillGoing(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        endTime.isEnabled = !sender.isSelected
        stillGoingBtn.isSelected = sender.isSelected
//        delegate?.recordStatusTableViewControllerDelegate(self, record: record)
        if sender.isSelected {
            sender.configuration?.background.backgroundColor = UIColor(named: "bluishGrey")
            sender.configuration?.baseForegroundColor = .white
            endTime.alpha = 0.2
        } else {
            sender.configuration?.background.backgroundColor = .clear
            sender.configuration?.baseForegroundColor = UIColor(named: "bluishGrey")
            endTime.alpha = 1
        }
    }
    
    @IBAction func tapScore(_ sender: UIButton) {
        if let index = scorBtns.firstIndex(of: sender) {
            score = index + 1
        }
        for scorBtn in scorBtns {
            scorBtn.configuration?.background.backgroundColor = UIColor(named: "bluishGrey")
        }
        sender.configuration?.background.backgroundColor = UIColor(named: "darkBlu")
    }
    
    @IBAction func saveStatus(_ sender: Any) {
        
        let start = startTime.date
        let end = stillGoingBtn.isSelected ? startTime.date : endTime.date
        let location = RecordStatusWording.noSelect.rawValue
        let place = placeCell.selectStrs.first
        let med = medCell.selectStrs.first
        let effect = effectCell.selectStrs.first
        let note = note.text
        let quantity = Double(quantityTextfield.text!)
        
        if (endTime.date <= startTime.date && !stillGoingBtn.isSelected) {
            alert(title: "時間錯誤", message: "結束時間需比開始時間晚噢！", action: "OK")
        } else if endTime.date > Date.now {
            alert(title: "時間錯誤", message: "結束時間不能設於未來噢！", action: "OK")
        } else {
            // update record
            if let record {
                record.startTime = start
                record.endTime = end
                record.location = location
                record.score = Int16(score)
                record.symptom = symptomCell.selectStrs as NSArray
                record.sign = signCell.selectStrs as NSArray
                record.cause = causeCell.selectStrs as NSArray
                record.place = place
                record.med = med
                record.medEffect = effect
                record.medQuantity = quantity ?? 0.0
                record.note = note
                record.stillGoing = stillGoingBtn.isSelected
                appDelegate.persistentContainer.saveContext()
                delegate?.recordStatusTableViewControllerDelegate(self, record: record)
            } else {
                // save new record
                save(start: start, end: end, location: location, score: score, symptom: symptomCell.selectStrs, sign: signCell.selectStrs, cause: causeCell.selectStrs, place: place, med: med, medEffect: effect, medQuantity: quantity, note: note)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func save(start: Date, end: Date?, location: String?, score: Int, symptom: [String], sign: [String], cause: [String], place: String?, med: String?, medEffect: String?, medQuantity: Double?, note: String?) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let statusRecord = Record(context: context)
        statusRecord.startTime = start
        statusRecord.endTime = end
        statusRecord.location = location ?? RecordStatusWording.noSelect.rawValue
        statusRecord.score = Int16(score)
        statusRecord.symptom = symptom as NSArray
        statusRecord.cause = cause as NSArray
        statusRecord.sign = sign as NSArray
        statusRecord.place = place
        statusRecord.med = med
        statusRecord.medEffect = medEffect
        statusRecord.medQuantity = medQuantity ?? 0.0
        statusRecord.note = note
        statusRecord.stillGoing = stillGoingBtn.isSelected
        
        delegate?.recordStatusTableViewControllerDelegate(self, record: statusRecord)
        
        appDelegate.persistentContainer.saveContext()
    }
    
    func updateUI(){
        symptomCell.configBtns(num: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
        signCell.configBtns(num: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
        causeCell.configBtns(num: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
        placeCell.configBtns(num: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
        medCell.configBtns(num: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
        effectCell.configBtns(num: MedEffect.allCases.count, view: effectCell.contentView, title: MedEffect.allCases.map{"\($0.rawValue)"}, selectStrs: nil)
    }
    
    func showUnfinUI(record: Record){
        // 持續btn
        stillGoingBtn.isSelected = true
//        delegate?.recordStatusTableViewControllerDelegate(self, didSelect: true)
        stillGoingBtn.configuration?.background.backgroundColor = UIColor(named: "bluishGrey")
        stillGoingBtn.configuration?.baseForegroundColor = .white
        endTime.isEnabled = false
        endTime.alpha = 0.2
        
        // 其餘按鈕顯示
        startTime.date = record.startTime!
        symptomCell.configBtns(num: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map{"\($0.rawValue)"}, selectStrs: record.symptom?.toStringArray(record.symptom))
        signCell.configBtns(num: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map{"\($0.rawValue)"}, selectStrs: record.sign?.toStringArray(record.sign))
        causeCell.configBtns(num: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map{"\($0.rawValue)"}, selectStrs: record.cause?.toStringArray(record.cause))
        placeCell.configBtns(num: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map{"\($0.rawValue)"}, selectStrs: [record.place ?? RecordStatusWording.noSelect.rawValue])
        medCell.configBtns(num: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map{"\($0.rawValue)"}, selectStrs: [record.med ?? RecordStatusWording.noSelect.rawValue])
        effectCell.configBtns(num: MedEffect.allCases.count, view: effectCell.contentView, title: MedEffect.allCases.map{"\($0.rawValue)"}, selectStrs: [record.medEffect ?? RecordStatusWording.noSelect.rawValue])
        
        // score btn 顯示
        let index = Int(record.score) - 1
        if index >= 0 {
            score = index
            scorBtns[index].configuration?.background.backgroundColor = UIColor(named: "darkBlu")
        }
        
        // 選取的字串 新+舊
        if let symptomStrs = record.symptom?.toStringArray(record.symptom) {
            symptomCell.selectStrs.append(contentsOf: (symptomStrs))
        }
        if let signStrs = record.sign?.toStringArray(record.sign) {
            signCell.selectStrs.append(contentsOf: (signStrs))
        }
        if let causeStrs = record.cause?.toStringArray(record.cause) {
            causeCell.selectStrs.append(contentsOf: (causeStrs))
        }
    }
    
    func alert(title: String, message: String?, action: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
