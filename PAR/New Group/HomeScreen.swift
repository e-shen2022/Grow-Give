//
//  HomeScreen.swift
//  PAR
//
//  Created by Tyler Alex on 12/19/22.
//

import UIKit

class HomeScreen: UIViewController {
    let userDefaults = UserDefaults.standard
    @IBOutlet var tutImg: UIImageView!
    var maximumContentSizeCategory: UIContentSizeCategory?
    @objc func nextTut() {
        animateOut(desiredView: welcomePop)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.maximumContentSizeCategory = .medium
        var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
        welcomePop.addGestureRecognizer(tapTut)
        self.logoView.loadGif(name: "animatedlogo")
        var temp = userDefaults.bool(forKey: "TUTORIAL")
        if temp == nil {
            temp = true
            userDefaults.set(true, forKey: "TUTORIAL")
        }
        if temp {
            animateInTut(desiredView: welcomePop, x: 170, y: 280)
        }
        
        let hex:UInt64 = 0xA0E4CB
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        view.backgroundColor = UIColor(red: CGFloat(r) / 256.0, green: CGFloat(g) / 256.0, blue: CGFloat(b) / 256.0, alpha: 1)
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]) { success, error in
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var logoView: UIImageView!
    
    @IBOutlet var tutChangeTxt: UILabel!
    @IBOutlet var tutorialChange: UIView!
    
    @IBAction func TutorialButton(_ sender: Any) {
        print("hi")
        var temp = userDefaults.bool(forKey: "TUTORIAL")
        if temp != nil {
            var text = ""
            if temp {
                userDefaults.set(false, forKey: "TUTORIAL")
                animateOut(desiredView: welcomePop)
                text = "off!"
            } else {
                userDefaults.set(true, forKey: "TUTORIAL")
                text = "on!"

            }
            animateIn(desiredView: tutorialChange)
            tutChangeTxt.text = "Tutorial \(text)"
        }

        //sender.font = "Times New Roman"
    }
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 1
            
        })
        
    }
    @IBAction func doneB(_ sender: Any) {
        animateOut(desiredView: tutorialChange)
    }
    @IBOutlet var welcomePop: UIView!
    
    
    @IBAction func pressStartB(_ sender: Any) {
        animateOut(desiredView: welcomePop)
    }
    
    func animateInTut(desiredView: UIView, x: Int, y: Int) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = CGPoint(x: x, y:y)
        //desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 1
            
        })
        
    }
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
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

