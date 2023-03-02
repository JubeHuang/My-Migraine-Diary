//
//  RecordListTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class RecordListTableViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    var records = [StatusR]()
//        didSet{
//            self.container.saveContext()
//        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIView()
        tableView.backgroundView = bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: tableView.bounds.height))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        records = container.getRecordsTimeAsc()
        // 新增後列表跟著新增
        tableView.reloadData()
    }
    
//    func getRecords(){
//        let context = container.viewContext
//        do {
//            records = try context.fetch(StatusR.fetchRequest())
//        } catch {
//            print("fetch faild")
//        }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecordTableViewCell.self)", for: indexPath) as? RecordTableViewCell {
            // Configure the cell...
            let row = indexPath.row
            
            cell.updateUI(record: records[row])
            
            return cell
        }
        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = container.viewContext
            let record = records[indexPath.row]
            records.remove(at: indexPath.row)
            context.delete(record)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }  
    }
    

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
