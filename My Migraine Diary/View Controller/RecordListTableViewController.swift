//
//  RecordListTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData

class RecordListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var container: NSPersistentContainer!
    var records = [Record]()
    var filterRecords = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIView()
        tableView.backgroundView = bg.bgGradient(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: tableView.bounds.height))

        // statusBar
        navigationController!.navigationBar.scrollEdgeAppearance = customNavBarAppearance(appearance: "scrollEdgeAppearance")
        navigationController!.navigationBar.standardAppearance = customNavBarAppearance(appearance: "standardAppearance")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        records = container.getRecordsTimeAsc()
        filterRecords = records
        // 新增後列表跟著新增
        tableView.reloadData()
    }
    
    @IBSegueAction func showRecord(_ coder: NSCoder) -> RecordStatusTableViewController? {
        let controller = RecordStatusTableViewController(coder: coder)
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.record = records[row]
        }
        controller?.title = "紀錄"
        return controller
    }
    
    func search(_ searchTerm: String){
        if searchTerm.isEmpty {
            filterRecords = records
        } else {
            filterRecords = records.filter { record in
                let placeMatch = record.place?.contains(searchTerm) ?? false
                let medMatch = record.med?.contains(searchTerm) ?? false
                let effectMatch = record.medEffect?.contains(searchTerm) ?? false
                let noteMatch = record.note?.contains(searchTerm) ?? false
                let signMatch = (record.sign as? [String])?.contains(searchTerm) ?? false
                let causeMatch = (record.cause as? [String])?.contains(searchTerm) ?? false
                let symptomMatch = (record.symptom as? [String])?.contains(searchTerm) ?? false
                return placeMatch || medMatch || effectMatch || noteMatch || signMatch || causeMatch || symptomMatch
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterRecords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecordTableViewCell.self)", for: indexPath) as? RecordTableViewCell {
            // Configure the cell...
            let row = indexPath.row
            
            cell.updateUI(record: filterRecords[row])
            
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
            let record = filterRecords[indexPath.row]
            if let index = records.firstIndex(of: record) {
                // 總列表刪除
                records.remove(at: index)
            }
            // 篩選過列表刪除
            filterRecords.remove(at: indexPath.row)
            context.delete(record)
            container.saveContext()
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

extension RecordListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        search(searchTerm)
        // 收鍵盤
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            filterRecords = records
            tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}
