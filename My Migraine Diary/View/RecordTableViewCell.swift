//
//  RecordTableViewCell.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/1.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var symptomLabel: UILabel!
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
    
    func updateUI(record: Record){
        let dateStr = DateFormatter().shortStyleTimeStr(time: record.startTime!)
        timeLabel.text = dateStr
        placeLabel.text = record.place ?? RecordStatusWording.noSelect.rawValue
        cause.text = record.cause?.nsArrayToStringForUILabel(record.cause)
        symptomLabel.text = record.symptom?.nsArrayToStringForUILabel(record.symptom)
        scoreLabel.text = "\(record.score)"
        durationLabel.text = Calendar(identifier: .chinese).getTimeDurationStr(start: record.startTime!, end: record.endTime!, stillGoing: record.stillGoing)
    }
}
