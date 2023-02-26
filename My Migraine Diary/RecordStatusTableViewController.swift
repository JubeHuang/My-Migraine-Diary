//
//  RecordStatusTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class RecordStatusTableViewController: UITableViewController {
    
    @IBOutlet weak var medCell: StatusBtnTableViewCell!
    @IBOutlet weak var placeCell: StatusBtnTableViewCell!
    @IBOutlet weak var causeCell: StatusBtnTableViewCell!
    @IBOutlet weak var signCell: StatusBtnTableViewCell!
    @IBOutlet weak var symptomCell: StatusBtnTableViewCell!
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        symptomCell.configBtns(num: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map{"\($0.rawValue)"})
        signCell.configBtns(num: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map{"\($0.rawValue)"})
        causeCell.configBtns(num: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map{"\($0.rawValue)"})
        placeCell.configBtns(num: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map{"\($0.rawValue)"})
        medCell.configBtns(num: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map{"\($0.rawValue)"})
    }
    
    func save(start: Date, end: Date?, location: String?, score: Int, symptom: String?, sign: String?, cause: String?, place: String?, med: String?, medEffect: String?, medQuantity: Double?, note: String?) {
        
        let context = container.viewContext
        
        let record = Record(context: context)
        record.startTime = start
        record.endTime = end
        record.location = location
        record.score = Int16(score)
        record.symptom = symptom
        record.cause = cause
        record.place = place
        record.med = med
        record.medEffect = medEffect
        record.medQuantity = medQuantity ?? 0.0
        record.note = note
        
        container.saveContext()
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
