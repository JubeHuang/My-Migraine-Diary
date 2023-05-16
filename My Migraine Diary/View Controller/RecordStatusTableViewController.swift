//
//  RecordStatusTableViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/24.
//

import UIKit
import CoreData
import GoogleMobileAds

protocol RecordStatusTableViewControllerDelegate: AnyObject {
    func recordStatusTableViewControllerDelegate(_ controller: RecordStatusTableViewController, record : Record)
}

class RecordStatusTableViewController: UITableViewController {
    
    @IBOutlet weak var adPlaceHolder: UIView!
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
    @IBOutlet weak var scoreScrollView: UIScrollView!
    @IBOutlet weak var effectCell: StatusBtnTableViewCell!
    
    var score = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var delegate: RecordStatusTableViewControllerDelegate?
    var record: Record?
    var screenWidth = 0
    var adLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView!
    let adUnitID = "ca-app-pub-3940256099942544/3986624511" //test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // statusBar
        navigationController!.navigationBar.scrollEdgeAppearance = customNavBarAppearance(appearance: "scrollEdgeAppearance")
        navigationController!.navigationBar.standardAppearance = customNavBarAppearance(appearance: "standardAppearance")
        
        // change datePicker text color
        startTime.overrideUserInterfaceStyle = .dark
        endTime.overrideUserInterfaceStyle = .dark
        
        // textView done鍵 為取消鍵盤
        note.delegate = self
        
        // segment
        quantitySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        quantitySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.appColor(.bluishGrey2)!], for: .normal)
        
        if let record {
            showWrittenUI(record: record)
        } else {
            updateUI()
        }
        
        // googleAds
        guard let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
              let adView = nibObjects.first as? GADNativeAdView
        else {
          assert(false, "Could not load nib file for adView")
        }
        nativeAdView = adView
        adPlaceHolder.addSubview(nativeAdView)
        adLoader = GADAdLoader(
          adUnitID: adUnitID, rootViewController: self,
          adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenWidth = Int(view.bounds.width)
        scoreScrollView.frame = CGRect(x: 0, y: 58, width: screenWidth, height: 44)
    }
    
    @IBAction func tapStillGoing(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        endTime.isEnabled = !sender.isSelected
        stillGoingBtn.isSelected = sender.isSelected
        
        stillBtn(sender, on: sender.isSelected)
        endTime.alpha = sender.isSelected ? 0.2 : 1.0
    }
    
    @IBAction func tapScore(_ sender: UIButton) {
        if let index = scorBtns.firstIndex(of: sender) {
            score = index + 1
        }
        scorBtns.forEach{ $0.configuration?.background.backgroundColor = UIColor.appColor(.bluishGrey1) }
        sender.configuration?.background.backgroundColor = UIColor.appColor(.darkBlu)
    }
    
    @IBAction func saveStatus(_ sender: Any) {
        
        let start = startTime.date
        let end = stillGoingBtn.isSelected ? startTime.date : endTime.date
        let location = RecordStatusWording.noSelect.rawValue
        let place = placeCell.selectStr ?? Place.notKnowPlace.rawValue
        print(place, "save")
        let med = medCell.selectStr ?? Med.noSelectMed.rawValue
        let effect = effectCell.selectStr ?? MedEffect.noSelectMedEffect.rawValue
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
                
                if let placeCellSelectStr = placeCell.selectStr {
                    record.place = placeCellSelectStr
                }
                
                if let medCellSelectStr = medCell.selectStr {
                    record.med = medCellSelectStr
                }
                
                if let effectCelSelectStr = effectCell.selectStr {
                    record.medEffect = effectCelSelectStr
                }
                
                record.medQuantity = quantity ?? 0.0
                record.note = note
                record.stillGoing = stillGoingBtn.isSelected
                record.medUnit = Int16(quantitySegment.selectedSegmentIndex)
                if let quantity {
                    record.medQuantity = quantity
                }
                
                appDelegate.persistentContainer.saveContext()
                delegate?.recordStatusTableViewControllerDelegate(self, record: record)
            } else {
                // save new record
                save(start: start, end: end, location: location, score: score, symptom: symptomCell.selectStrs, sign: signCell.selectStrs, cause: causeCell.selectStrs, place: place, med: med, medEffect: effect, medQuantity: quantity, note: note, quantitySegment: quantitySegment.selectedSegmentIndex)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
        if let record {
            let alertController = UIAlertController(title: "確定要刪除嗎？", message: "刪除的紀錄將無法復原", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default) { [weak self] action in
                guard let self else { return }
                let context = self.appDelegate.persistentContainer.viewContext
                context.delete(record)
                self.appDelegate.persistentContainer.saveContext()
                self.navigationController?.popViewController(animated: true)
            }
            let actionCancel = UIAlertAction(title: "取消", style: .cancel)
            alertController.addAction(action)
            alertController.addAction(actionCancel)
            present(alertController, animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneToCloseKeyboard(_ sender: Any) {
    }
    
    @IBAction func closeKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func save(start: Date, end: Date?, location: String?, score: Int, symptom: [String], sign: [String], cause: [String], place: String?, med: String?, medEffect: String?, medQuantity: Double?, note: String?, quantitySegment: Int) {
        
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
        statusRecord.medUnit = Int16(quantitySegment)
        
        delegate?.recordStatusTableViewControllerDelegate(self, record: statusRecord)
        
        appDelegate.persistentContainer.saveContext()
    }
    
    func updateUI(){
        symptomCell.configBtnsForMultiSelect(buttonCount: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map(\.rawValue), selectStrs: nil, imageNames: Symptom.allCases.map{"\($0)"})
        signCell.configBtnsForMultiSelect(buttonCount: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map(\.rawValue), selectStrs: nil, imageNames: Sign.allCases.map{"\($0)"})
        causeCell.configBtnsForMultiSelect(buttonCount: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map(\.rawValue), selectStrs: nil, imageNames: Cause.allCases.map{"\($0)"})
        placeCell.configBtnsForSingleSelect(buttonCount: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map(\.rawValue), selectStr: nil, imageNames: Place.allCases.map{"\($0)"})
        medCell.configBtnsForSingleSelect(buttonCount: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map(\.rawValue), selectStr: nil, imageNames: Med.allCases.map{"\($0)"})
        effectCell.configBtnsForSingleSelect(buttonCount: MedEffect.allCases.count, view: effectCell.contentView, title: MedEffect.allCases.map(\.rawValue), selectStr: nil, imageNames: MedEffect.allCases.map{"\($0)"})
    }
    
    func showWrittenUI(record: Record){
        // 持續btn
        stillGoingBtn.isSelected = record.stillGoing
        endTime.isEnabled = !record.stillGoing
        if endTime.isEnabled {
            endTime.date = record.endTime!
        }
        stillBtn(stillGoingBtn, on: record.stillGoing)
        endTime.alpha = record.stillGoing ? 0.2 : 1.0
        
        // 其餘按鈕顯示
        startTime.date = record.startTime!
        quantityTextfield.text = "\(record.medQuantity)"
        quantitySegment.selectedSegmentIndex = Int(record.medUnit)
        symptomCell.configBtnsForMultiSelect(buttonCount: Symptom.allCases.count, view: symptomCell.contentView, title: Symptom.allCases.map(\.rawValue), selectStrs: record.symptom?.toStringArray(record.symptom), imageNames: Symptom.allCases.map{"\($0)"})
        signCell.configBtnsForMultiSelect(buttonCount: Sign.allCases.count, view: signCell.contentView, title: Sign.allCases.map(\.rawValue), selectStrs: record.sign?.toStringArray(record.sign), imageNames: Sign.allCases.map{"\($0)"})
        causeCell.configBtnsForMultiSelect(buttonCount: Cause.allCases.count, view: causeCell.contentView, title: Cause.allCases.map(\.rawValue), selectStrs: record.cause?.toStringArray(record.cause), imageNames: Cause.allCases.map{"\($0)"})
        placeCell.configBtnsForSingleSelect(buttonCount: Place.allCases.count, view: placeCell.contentView, title: Place.allCases.map(\.rawValue), selectStr: record.place, imageNames: Place.allCases.map{"\($0)"})
        medCell.configBtnsForSingleSelect(buttonCount: Med.allCases.count, view: medCell.contentView, title: Med.allCases.map(\.rawValue), selectStr: record.med, imageNames: Med.allCases.map{"\($0)"})
        effectCell.configBtnsForSingleSelect(buttonCount: MedEffect.allCases.count, view: effectCell.contentView, title: MedEffect.allCases.map(\.rawValue), selectStr: record.medEffect, imageNames: MedEffect.allCases.map{"\($0)"})
        
        // score btn 顯示
        score = Int(record.score)
        let index = score - 1
        if index >= 0 {
            scorBtns[index].configuration?.background.backgroundColor = UIColor.appColor(.darkBlu)
        }
        
        // 選取的字串 新+舊
        if let symptomStrs = record.symptom?.toStringArray(record.symptom) {
            symptomCell.selectStrs.append(contentsOf: symptomStrs)
        }
        if let signStrs = record.sign?.toStringArray(record.sign) {
            signCell.selectStrs.append(contentsOf: signStrs)
        }
        if let causeStrs = record.cause?.toStringArray(record.cause) {
            causeCell.selectStrs.append(contentsOf: causeStrs)
        }
    }
    
    func alert(title: String, message: String?, action: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func stillBtn(_ btn: UIButton, on: Bool){
        btn.configuration?.background.backgroundColor = on ? .appColor(.pink) : .clear
        btn.configuration?.baseForegroundColor = on ? .appColor(.darkBlu) : .appColor(.bluishGrey1)
        btn.configuration?.background.strokeColor = on ? .appColor(.pink) : .appColor(.bluishGrey1)
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

// textview的done鍵取消換行
extension RecordStatusTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension RecordStatusTableViewController: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        // config of ad
        print("configAd")
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        nativeAdView.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
    
    
}
