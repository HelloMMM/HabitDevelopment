//
//  TabbarVC.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/10.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import GoogleMobileAds

var tabbarVC: ESTabBarController!
var blueColor = UIColor(red: 165.0/255.0, green: 222.0/255.0, blue: 228.0/255.0, alpha: 1.0)
var yellowColor = UIColor(red: 248.0/255.0, green: 223.0/255.0, blue: 152.0/255.0, alpha: 1.0)
var pinkColor = UIColor(red: 245.0/255.0, green: 202.0/255.0, blue: 195.0/255.0, alpha: 1.0)

class TabbarVC: ESTabBarController {

    var bannerView: GADBannerView!
    var v1: ViewController!
    var v2: UIViewController!
    var v3: MoreVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isRemoveAD {
            addBannerViewToView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeAD), name: NSNotification.Name("RemoveAD") , object: nil)
        
        delegate = self
        
//        tabBar.shadowImage = UIImage(named: "transparent")
//        tabBar.backgroundImage = UIImage(named: "background_dark")
        
//        if let tabBar = tabBar as? ESTabBar {
//            tabBar.itemCustomPositioning = .fillIncludeSeparator
//        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        moreVC.delegate = self
        
        v1 = viewController
        v2 = UIViewController()
        v3 = moreVC
        
        changeStyle(Style(rawValue: appStyle)!)

        viewControllers = [v1, v2, v3]
        
        shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return true
            }
            return false
        }
        
        didHijackHandler = {
            [weak self] tabbarController, viewController, index in
            
            self!.v1.addClick()
        }
        
        tabbarVC = self
        
    }
    
    func addBannerViewToView() {
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)

        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        bannerView.adUnitID = "ca-app-pub-1223027370530841/6069003846"
        #endif

        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        bannerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bannerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    @objc func removeAD(notification: NSNotification) {
            
        isRemoveAD = true
        
        if bannerView != nil {
            bannerView.removeFromSuperview()
        }
    }
}

extension TabbarVC: MoreVCDelegate {
    
    func changeStyle(_ style: Style) {
        
        let exampleIrregularityContentView = ExampleIrregularityContentView()
        let basicContentView1 = ExampleIrregularityBasicContentView()
        basicContentView1.backdropColor = .clear
        basicContentView1.highlightBackdropColor = .clear
        let basicContentView2 = ExampleIrregularityBasicContentView()
        basicContentView2.backdropColor = .clear
        basicContentView2.highlightBackdropColor = .clear
                
        if style == .blue {
            tabBar.backgroundColor = UIColor(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
            v1.view.backgroundColor = blueColor
            v3.view.backgroundColor = blueColor
            
            appStyle = 0
        } else if style == .yellow {
            let color = UIColor(red: 246.0/255.0, green: 189.0/255.0, blue: 96.0/255.0, alpha: 1.0)
            exampleIrregularityContentView.imageView.backgroundColor = color
            basicContentView1.highlightTextColor = color
            basicContentView1.highlightIconColor = color
            basicContentView2.highlightTextColor = color
            basicContentView2.highlightIconColor = color
            
            tabBar.backgroundColor = UIColor(red: 217.0/255.0, green: 127.0/255.0, blue: 71.0/255.0, alpha: 1.0)
            v1.view.backgroundColor = yellowColor
            v3.view.backgroundColor = yellowColor
            
            appStyle = 1
        } else {
            
            let color = UIColor(red: 227.0/255.0, green: 141.0/255.0, blue: 131.0/255.0, alpha: 1.0)
            exampleIrregularityContentView.imageView.backgroundColor = color
            basicContentView1.highlightTextColor = color
            basicContentView1.highlightIconColor = color
            basicContentView2.highlightTextColor = color
            basicContentView2.highlightIconColor = color
            
            tabBar.backgroundColor = UIColor(red: 243.0/255.0, green: 163.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            v1.view.backgroundColor = pinkColor
            v3.view.backgroundColor = pinkColor
            
            appStyle = 2
        }
        
        v1.tabBarItem = ESTabBarItem(basicContentView1, title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem(exampleIrregularityContentView, title: nil, image: UIImage(named: "add"), selectedImage: UIImage(named: "add"))
        v3.tabBarItem = ESTabBarItem(basicContentView2, title: "More", image: UIImage(named: "more"), selectedImage: UIImage(named: "more"))
        
        UserDefaults.standard.set(appStyle, forKey: "appStyle")
    }
}

extension TabbarVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

extension TabbarVC: UITabBarControllerDelegate {
    
}
