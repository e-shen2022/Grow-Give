//
//  BreakTimer.swift
//  Project PAR(PlanActRest)
//
//  Created by Emma Shen on 12/29/22.
//

import UIKit
import AVFoundation
import UserNotifications

class BreakTimer: UIViewController {
    var timer = Timer()
    var player: AVAudioPlayer!
    var breakPeriod = 5
    var counter = 0
    var endTime:Date?
    let userDefaults = UserDefaults.standard
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"

    
    @IBOutlet var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //breakPeriod (min), counter (seconds left)
        counter = breakPeriod * 60
        //exact time start timer
        let startDate = Date()
        //when start timer + seconds left = when end timer
        endTime = startDate + TimeInterval(Double(counter))
        userDefaults.set(endTime, forKey: endKey)
        userDefaults.set(startDate, forKey: startKey)
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "Your break session is over!"
        content.sound = UNNotificationSound(named:UNNotificationSoundName("xp_ring.mp3"))
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: endTime!), repeats: true)
        //print(endTime!)
        let request = UNNotificationRequest(identifier: "id_breakTimer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if err != nil {
                print("something's wrong")
            } else {
                print("notification prepared!")
            }
        }
        //print("hi")
        // Do any additional setup after loading the view.
        //updates every 1s
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(BreakTimer.updateCounter)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    @objc func updateCounter() {
        //let currTime = Date()
        let start = userDefaults.object(forKey: startKey) as! Date
        //how much time has passed since the start
        let diff = Int(Date().timeIntervalSince(start))
        counter = 60 * breakPeriod - diff
        updateLabel()
        if counter <= 0 {
            counter = 0
            updateLabel()
            timer.invalidate()
            
        }
    }
    func updateLabel() {
        let min = counter / 60
        let sec = counter % 60
        var extraZero = ""
        if sec < 10 {
            extraZero = "0"
        }
        timerLabel.text = "\(min):\(extraZero)\(sec)"
    }
    @IBAction func nextScreen(_ sender: Any) {
        timer.invalidate()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().delegate = self.transitioningDelegate as? any UNUserNotificationCenterDelegate
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //let userInfo = response.notification.request.content.userInfo
        // Handle notification

        completionHandler()
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



    

    
    