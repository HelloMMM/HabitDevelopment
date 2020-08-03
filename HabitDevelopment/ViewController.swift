//
//  ViewController.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/8.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import Hero
import GoogleMobileAds

class ViewController: UIViewController {
    
    var dataAry: Array<Dictionary<String, Any>>! = []
    @IBOutlet weak var tableView: UITableView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "dataAry") != nil {
            dataAry = UserDefaults.standard.object(forKey: "dataAry") as? Array<Dictionary<String, Any>>
        }
        
        interstitial = createAndLoadInterstitial()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        
        if UserDefaults.standard.object(forKey: "firstStart") == nil {
            
            let testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestVC") as! TestVC
            testVC.alpha = 0.7
            testVC.testVCDelegate = self
            
            present(testVC, animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "firstStart")
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        
        #if DEBUG
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        #else
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-1223027370530841/1810875858")
        #endif
        interstitial.delegate = self
        interstitial.load(GADRequest())
        
        return interstitial
    }

    func addClick() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let day = UIAlertAction(title: "每天", style: .default) { (alert) in
            
            let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedVC") as! DetailedVC
            detailedVC.delegate = self
            detailedVC.isUpdata = false
            if !self.dataAry.isEmpty {
                detailedVC.row = self.dataAry.count
            }
            
            DispatchQueue.main.async {
                self.present(detailedVC, animated: false, completion: nil)
            }
        }
        let designated = UIAlertAction(title: "指定時間", style: .default) { (alert) in
            
            let designatedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DesignatedVC") as! DesignatedVC
            designatedVC.delegate = self
            designatedVC.isUpdata = false
            if !self.dataAry.isEmpty {
                designatedVC.row = self.dataAry.count
            }
            
            DispatchQueue.main.async {
                self.present(designatedVC, animated: false, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(day)
        alert.addAction(designated)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    func setNotification(data: Dictionary<String, Any>) {
        
        let aims = data["aims"] as! String
        let date = data["time"] as! Date
        let identifier = data["identifier"] as! String
        let isDay = data["isDay"] as! Bool
        
        let content = UNMutableNotificationContent()
        content.title = "提醒您該做計畫的事情囉"
        content.subtitle = aims
        content.sound = UNNotificationSound.default
        content.badge = 1
        
//        content.body = "剩餘天數：法蘭克的 "
//        content.categoryIdentifier = "D"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        
        var components = DateComponents()
        components.hour = Int(hourFormatter.string(from: date))
        components.minute = Int(minuteFormatter.string(from: date))
        
        var trigger: UNCalendarNotificationTrigger!
        if !isDay {
            components.year = Int(yearFormatter.string(from: date))
            components.month = Int(monthFormatter.string(from: date))
            components.day = Int(dayFormatter.string(from: date))
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        } else {
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        }
        
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            
            print("成功建立通知: \(request.identifier)")
        })
    }
}

extension ViewController: DetailedVCDelegate {
    
    func saveData(data: Dictionary<String, Any>) {
        
        setNotification(data: data)
        dataAry.append(data)
        setData()
    }
    
    func updata(data: Dictionary<String, Any>, row: Int) {
        
        setNotification(data: data)
        dataAry[row] = data
        setData()
    }
    
    func setData() {
        tableView.reloadData()
        UserDefaults.standard.set(dataAry, forKey: "dataAry")
        
        if !isNotification {
            let alert = UIAlertController(title: "注意", message: "請開啟您的通知權限,\n否則無法向您提醒代辦事項!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (alert) in
                
                self.showAD()
            }
            let set = UIAlertAction(title: "設定", style: .default) { (alert) in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }

            alert.addAction(cancel)
            alert.addAction(set)
            present(alert, animated: true, completion: nil)
        } else {
            
            showAD()
        }
    }
    
    func showAD() {
        
        if !isRemoveAD {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                interstitial = createAndLoadInterstitial()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewControllerCell", for: indexPath) as! ViewControllerCell
        cell.delegate = self
        cell.hero.id = "hero_id_\(indexPath.row)"
        cell.aimsLab.text = dataAry[indexPath.row]["aims"] as? String
        cell.row = indexPath.row
        
        let isDay = dataAry[indexPath.row]["isDay"] as! Bool
        let endDay = dataAry[indexPath.row]["endDate"] as! Date
        let gapDay = Calendar.current.dateComponents([.day], from: Date(), to: endDay).day!
        if gapDay < 0 {
            cell.dayLab.text = "0 天"
        } else {
            cell.dayLab.text = "\(gapDay) 天"
        }
        
        
        if endDay < Date() {
            cell.mySwitch.setOn(false, animated: false)
            switchChange(isOn: false, row: indexPath.row)
        }
        
        if isDay {
    
            cell.timeTitle.text = "每天"
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let time = formatter.string(from: dataAry[indexPath.row]["time"] as! Date)
            cell.time.text = time
        } else {
            
            cell.timeTitle.text = "指定時間"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.string(from: dataAry[indexPath.row]["time"] as! Date)
            cell.time.text = time
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let isDay = dataAry[indexPath.row]["isDay"] as! Bool
        
        if isDay {
            
            let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedVC") as! DetailedVC
            detailedVC.delegate = self
            detailedVC.hero_id = "hero_id_\(indexPath.row)"
            detailedVC.data = dataAry[indexPath.row]
            detailedVC.row = indexPath.row
            detailedVC.isUpdata = true
            
            DispatchQueue.main.async {
                self.present(detailedVC, animated: true, completion: nil)
            }
        } else {
            
            let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DesignatedVC") as! DesignatedVC
            detailedVC.delegate = self
            detailedVC.hero_id = "hero_id_\(indexPath.row)"
            detailedVC.data = dataAry[indexPath.row]
            detailedVC.row = indexPath.row
            detailedVC.isUpdata = true
            
            DispatchQueue.main.async {
                self.present(detailedVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                    
            let identifier = dataAry[indexPath.row]["identifier"] as! String
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
            dataAry.remove(at: indexPath.row)
            UserDefaults.standard.set(dataAry, forKey: "dataAry")
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: TestVCDelegate {
    
    func enterMain() {
        
        addClick()
    }
}

extension ViewController: ViewControllerCellDelegate {
    
    func switchChange(isOn: Bool, row: Int) {
        
        let identifier = dataAry[row]["identifier"] as! String
        
        if isOn {
            
            setNotification(data: dataAry[row])
        } else {
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}

extension ViewController: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {

        interstitial = createAndLoadInterstitial()
    }
}
