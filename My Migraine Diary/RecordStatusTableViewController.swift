//
//  RecordStatusTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class RecordStatusTableViewController: UITableViewController {
    
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
    
    var container: NSPersistentContainer!
    var score = 0
    var records = [StatusR]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateUI()
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
        let end = endTime.date
        let location = RecordStatusWording.noSelect.rawValue
        let place = RecordStatusWording.noSelect.rawValue
        let med = medCell.selectStrs.first ?? RecordStatusWording.noSelect.rawValue
        let effect = effectCell.selectStrs.first ?? RecordStatusWording.noSelect.rawValue
        let note = note.text
        if let text = quantityTextfield.text, text != "" {
            //let quantity = Double(text)
            save(start: start, end: end, location: location, score: score, symptom: symptomCell.selectStrs, sign: signCell.selectStrs, cause: causeCell.selectStrs, place: place, med: med, medEffect: effect, medQuantity: 1.0, note: note)
        } else {
            save(start: start, end: end, location: location, score: score, symptom: symptomCell.selectStrs, sign: signCell.selectStrs, cause: causeCell.selectStrs, place: place, med: med, medEffect: effect, medQuantity: 0.0, note: note)
        }
        getRecords()
        print( records )
        navigationController?.pushViewController(self, animated: true)
    }
    
    
    func save(start: Date, end: Date?, location: String?, score: Int, symptom: [String], sign: [String], cause: [String], place: String?, med: String?, medEffect: String?, medQuantity: Double?, note: String?) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let record = StatusR(context: context)
        record.startTime = start
        record.endTime = end
        record.location = location ?? ""
        record.score = Int16(score)
        record.symptom = symptom.first ?? RecordStatusWording.noSelect.rawValue
        record.cause = cause.first ?? RecordStatusWording.noSelect.rawValue
        record.sign = sign.first ?? RecordStatusWording.noSelect.rawValue
        record.place = place ?? ""
        record.med = med ?? ""
        record.medEffect = medEffect ?? ""
        record.medQuantity = medQuantity ?? 0.0
        record.note = note ?? ""
        
        appDelegate.persistentContainer.saveContext()
    }
    
    func getRecords(){
        let context = container.viewContext
        do {
            records = try context.fetch(StatusR.fetchRequest())
        } catch {
            print("fetch faild")
        }
        
    }
    
    func updateUI(){
        symptomCell.configBtns(num: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map{"\($0.rawValue)"})
        signCell.configBtns(num: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map{"\($0.rawValue)"})
        causeCell.configBtns(num: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map{"\($0.rawValue)"})
        placeCell.configBtns(num: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map{"\($0.rawValue)"})
        medCell.configBtns(num: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map{"\($0.rawValue)"})
        effectCell.configBtns(num: MedEffect.allCases.count, view: effectCell.contentView, title: MedEffect.allCases.map{"\($0.rawValue)"})
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
