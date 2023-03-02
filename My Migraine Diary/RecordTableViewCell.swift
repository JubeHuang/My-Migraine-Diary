//
//  RecordTableViewCell.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/1.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var symptumLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var cause: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(record: StatusR){
        let dateStr = DateFormatter().shortStyleTimeStr(time: record.startTime!)
        timeLabel.text = dateStr
        placeLabel.text = record.place
        cause.text = record.cause
        symptumLabel.text = record.symptom
        scoreLabel.text = "\(record.score)"
        durationLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: record.endTime!)
    }
    
    func getTimeDurationStr(start: Date, end: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        let timeDifference = String(format: "歷時 %d小時%d分", hours, minutes)
        
        return timeDifference
    }
    
}
