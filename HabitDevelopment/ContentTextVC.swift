//
//  ContentTextVC.swift
//  HabitDevelopment
//
//  Created by Miles on 2021/10/8.
//  Copyright © 2021 HellöM. All rights reserved.
//

import UIKit

class ContentTextVC: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    var contentText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shadowView.alpha = 0
        
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
        
        textView.text = contentText
        if textView.contentSize.height > view.frame.height/3 {
            textViewHeight.constant = view.frame.height/3
        } else {
            textViewHeight.constant = textView.contentSize.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showView()
    }
    
    @IBAction func confirmClick(_ sender: Any) {
        hideView()
    }
    
    func showView() {
        
        UIView.animate(withDuration: 0.3) {
            self.shadowView.alpha = 1
        }
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.3) {
            self.shadowView.alpha = 0
        } completion: { bool in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first?.view == shadowView {
            hideView()
        }
    }
}
