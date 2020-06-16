//
//  DetailedVC.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/9.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

protocol DetailedVCDelegate {
    
    func saveData(data: Dictionary<String, Any>)
    func updata(data: Dictionary<String, Any>, row: Int)
}

class DetailedVC: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var hero_id = ""
    var delegate: DetailedVCDelegate?
    var time = Date()
    @IBOutlet weak var aimsTextField: TextField!
    @IBOutlet weak var dayTextField: TextField!
    var data: Dictionary<String, Any>?
    var row = 0
    var isUpdata = false
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
            aimsTextField.text = data!["aims"] as? String
            dayTextField.text = data!["day"] as? String
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        datePicker.setValue(UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0), forKey: "textColor")
        baseView.hero.id = hero_id
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "firstDay") == nil {
        
            let testVC1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestVC1") as! TestVC1
            testVC1.alpha = 0.7
            testVC1.view1 = [datePicker.superview!.convert(datePicker.center, to: nil), datePicker.frame.size]
            testVC1.view2 = [aimsTextField.superview!.convert(aimsTextField.center, to: nil), aimsTextField.frame.size]
            testVC1.view3 = [dayTextField.superview!.convert(dayTextField.center, to: nil), dayTextField.frame.size]
            
            present(testVC1, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "firstDay")
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        
        if aimsTextField.text == "" {
            aimsTextField.shake()
            showToast("請輸入項目")
            return
        } else if dayTextField.text == "" {
            dayTextField.shake()
            showToast("請輸入天數")
            return
        }
        
        let endDate = NSCalendar.current.date(byAdding: .day, value: Int(dayTextField.text!)!, to: Date())!
        let identifier = "Notification_\(row)"
        let dic: Dictionary<String, Any> = ["time": time,
                                            "aims": aimsTextField.text!,
                                            "day": dayTextField.text!,
                                            "row": row,
                                            "endDate": endDate,
                                            "identifier": identifier,
                                            "isDay": true]
        
        
        
        dismiss(animated: true) {
            
            if self.isUpdata {
                self.delegate?.updata(data: dic, row: self.row)
            } else {
                self.delegate?.saveData(data: dic)
            }
        }
    }
    
    @objc func onTap() {
        
        view.endEditing(true)
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "HH:mm"
        //        formatter.string(from: sender.date)
        time = sender.date
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailedVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        
        if numberOfChars > 10 {
            showToast("最多10個字")
            textField.shake()
        }
        
        return numberOfChars <= 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


