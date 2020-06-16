//
//  ViewControllerCell.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/9.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

protocol ViewControllerCellDelegate {
    func switchChange(isOn: Bool, row: Int)
}

class ViewControllerCell: UITableViewCell {

    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var aimsLab: UILabel!
    @IBOutlet weak var dayLab: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var lastDayTitle: UILabel!
    var delegate: ViewControllerCellDelegate?
    var row = 0
    
    @IBAction func switchController(_ sender: UISwitch) {
        
        if sender.isOn {
            
            aimsLab.textColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0)
            dayLab.textColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0)
            time.textColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0)
            dayTitle.textColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0)
            lastDayTitle.textColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1.0)
        } else {
            
            aimsLab.textColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
            dayLab.textColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
            time.textColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
            dayTitle.textColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
            lastDayTitle.textColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
        }
        
        delegate?.switchChange(isOn: sender.isOn, row: row)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
