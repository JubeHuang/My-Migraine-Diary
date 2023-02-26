//
//  StatusBtnTableViewCell.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/25.
//

import UIKit

class StatusBtnTableViewCell: UITableViewCell {
    
    var selectStrs = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configBtns(num: Int, view: UIView, title: [String]){
        // 設定每個UIButton的大小和間距
        let buttonWidth = 80
        let buttonHeight = 44
        let spacing = 0

        // 要生成的UIButton數量
        let buttonCount = num

        // 建立一個空的UIButton陣列
        var buttons = [UIButton]()
        
        // 建立樣式
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "heart")
        configuration.imagePlacement = .top
        configuration.imagePadding = 6
        
        let y = 52

        // 生成指定數量的UIButton
        for i in 0..<buttonCount {
            // 計算UIButton的x和y座標
            let x = i * (buttonWidth + spacing)
            
            // 建立文字
            var attrStr = AttributedString("\(title[i])")
            attrStr.font = .systemFont(ofSize: 12)
            attrStr.foregroundColor = UIColor(named: "lightBlu")
            
            // 建立新的UIButton
            let button = UIButton(configuration: configuration)
            button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
            button.setAttributedTitle(NSAttributedString(attrStr), for: .normal)
            
            //點擊Btn後要做的事
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            
            // 將新的UIButton加入陣列中
            buttons.append(button)
        }

        // 顯示生成的UIButton
        for button in buttons {
            view.addSubview(button)
        }
    }
    
    @objc func buttonSelected(sender: UIButton) {
        // Update appearance or perform some other action based on the selected button
        sender.isSelected = !sender.isSelected
        guard let text = sender.titleLabel?.text else { return }
        if sender.isSelected {
            selectStrs.append(text)
        } else {
            if let index = selectStrs.firstIndex(of: text) {
                selectStrs.remove(at: index)
            }
        }
        print(selectStrs)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
