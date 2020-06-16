//
//  MoreVC.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/15.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit


protocol MoreVCDelegate {
    
    func changeStyle(_ style: Style)
}

enum Style: Int {
    case blue
    case yellow
    case pink
}

class MoreVC: UITableViewController {

    var delegate: MoreVCDelegate?
    let styleNames = ["天空☁️", "布丁🍮", "櫻花🌸"]
    var lastSelect = 0
    @IBOutlet weak var styleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastSelect = appStyle
        
        styleName.text = styleNames[appStyle]
        tableView.tableFooterView = UIView()
    }
    
    func changeStyle() {
        
        let customPickerView = CustomPickerView(styleNames) { (countryNumber) in
            
            self.styleName.text = self.styleNames[countryNumber]
            self.lastSelect = countryNumber
            self.delegate?.changeStyle(Style(rawValue: countryNumber)!)
        }
        
        customPickerView.lastSelect = lastSelect
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let _ = IAPManager.shared.startPurchase()
        case 1:
            let _ = IAPManager.shared.restorePurchase()
        case 2:
            changeStyle()
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
