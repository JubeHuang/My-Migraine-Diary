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
        let buttonWidth = 74
        let buttonHeight = 60
        let spacing = 4
        let viewH = 100

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
        
        // 建立scrollView
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: y, width: 375, height: viewH))
        let totalBtnsWidth = (buttonWidth + spacing) * num
        scrollView.contentSize = CGSize(width: totalBtnsWidth, height: viewH)
        scrollView.showsHorizontalScrollIndicator = false
        
        // 生成指定數量的UIButton
        for i in 0..<buttonCount {
            // 計算UIButton的x和y座標
            let x = i * buttonWidth
            
            // 建立文字
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attrStr = NSAttributedString(string: "\(title[i])", attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor(named: "lightBlu")!,
                .paragraphStyle: paragraph
            ])
            
            // 建立新的UIButton
            let button = UIButton(configuration: configuration)
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: buttonHeight)
            button.setAttributedTitle(attrStr, for: .normal)
            
            //點擊Btn後要做的事
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            
            // 將新的UIButton加入陣列中
            buttons.append(button)
        }
        
        // 建立stackView
        let stackV = UIStackView(frame: CGRect(x: 0, y: 0, width: totalBtnsWidth, height: viewH))
        stackV.axis = .horizontal
        stackV.alignment = .top
        stackV.distribution = .fillEqually
        stackV.spacing = CGFloat(spacing)
        
        for button in buttons {
            stackV.addArrangedSubview(button)
        }
        
        scrollView.addSubview(stackV)
        view.addSubview(scrollView)
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
