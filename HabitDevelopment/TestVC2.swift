//
//  TestVC2.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/12.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit

class TestVC2: SpotlightViewController {

    var stepIndex = 0
    var txt: UILabel!
    var view1: Array<Any>!
    var view2: Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txt = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        txt.numberOfLines = 0
        txt.alpha = 0
        txt.font = UIFont.systemFont(ofSize: 20)
        txt.textColor = .white
        txt.textAlignment = .center
        spotlightView.addSubview(txt)
        delegate = self
    }
    
    func next() {
            
            let screenSize = UIScreen.main.bounds.size
            switch stepIndex {
            case 0:
                UIView.animate(withDuration: 0.5) {
                    self.txt.alpha = 1
                }
                txt.center = CGPoint(x: view.frame.width/2, y: (view1[0] as! CGPoint).y-(view1[1] as! CGSize).height/2-80)
                txt.text = "選擇提醒日期"
                spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width/2, y: (view1[0] as! CGPoint).y), size: CGSize(width: (view1[1] as! CGSize).width, height: (view1[1] as! CGSize).height), cornerRadius: 5))
            case 1:

                UIView.animate(withDuration: 0.5, animations: {
                    self.txt.alpha = 0
                }, completion: { (bool) in
                    self.txt.center = CGPoint(x: self.view.frame.width/2, y: (self.view2[0] as! CGPoint).y+60)
                    self.txt.text = "填寫提醒項目"
                    UIView.animate(withDuration: 0.5) {
                        self.txt.alpha = 1
                    }
                })

                spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width/2, y: (view2[0] as! CGPoint).y), size: CGSize(width: (view1[1] as! CGSize).width, height: (view2[1] as! CGSize).height+10), cornerRadius: 5), moveType: .disappear)
            case 2:
                dismiss(animated: true, completion: nil)
            default:
                break
            }
            
            stepIndex += 1
        }
}

extension TestVC2: SpotlightViewControllerDelegate {
    
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next()
    }

    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next()
    }

    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
