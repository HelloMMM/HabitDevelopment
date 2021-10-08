//
//  DesignatedVC.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/10.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

class DesignatedVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var project: TextField!
    @IBOutlet weak var baseView: UIView!
    var hero_id = ""
    var time = Date()
    var data: Dictionary<String, Any>?
    var row = 0
    var isUpdata = false
    var delegate: DetailedVCDelegate?
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch appStyle {
        case 0:
            topView.backgroundColor = blueColor
        case 1:
            topView.backgroundColor = yellowColor
        case 2:
            topView.backgroundColor = pinkColor
        default:
            break
        }
        
        if data != nil {
            datePicker.date = data!["time"] as! Date
            project.text = data!["aims"] as? String
        }
        
        datePicker.setValue(UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0), forKey: "textColor")
        datePicker.minimumDate = Date()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        if UserDefaults.standard.object(forKey: "firstDesignated") == nil {
            
            let testVC2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestVC2") as! TestVC2
            testVC2.alpha = 0.7
            testVC2.view1 = [datePicker.superview!.convert(datePicker.center, to: nil), datePicker.frame.size]
            testVC2.view2 = [project.superview!.convert(project.center, to: nil), project.frame.size]
            
            present(testVC2, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "firstDesignated")
        }
    }
    
    @objc func onTap() {
        
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: Any) {
        
        if project.text == "" {
            
            project.shake()
            showToast("請輸入項目")
            return
        }
        
        let day = Calendar.current.dateComponents([.day], from: Date(), to: time).day!
        
        let identifier = "Notification_\(row)"
        let dic: Dictionary<String, Any> = ["time": time,
                                            "aims": project.text!,
                                            "day": "\(day)",
                                            "row": row,
                                            "endDate": time,
                                            "identifier": identifier,
                                            "isDay": false]
        
        dismiss(animated: true) {
            
            if self.isUpdata {
                self.delegate?.updata(data: dic, row: self.row)
            } else {
                self.delegate?.saveData(data: dic)
            }
        }
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        
        time = sender.date
    }
}

extension DesignatedVC: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        let numberOfChars = newText.count
//        
//        if numberOfChars > 10 {
//            showToast("最多10個字")
//            textField.shake()
//        }
//        
//        return numberOfChars <= 10
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
    }
}
