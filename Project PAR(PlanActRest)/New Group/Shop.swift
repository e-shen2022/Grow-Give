//
//  Shop.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/31/22.
//

import UIKit
import AVFoundation
import UserNotifications
class Shop: UIViewController {
    var coinCount = 600
    @IBOutlet var coinLabel: UILabel!
    var timer = Timer()
    var player: AVAudioPlayer!
    var breakPeriod = 5
    var counter = 0
    var endTime:Date?
    let userDefaults = UserDefaults.standard
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    @IBOutlet var breakTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        coinLabel.text = String(coinCount)
        breakPeriod = userDefaults.integer(forKey: "BREAK_TIME")
        // Do any additional setup after loading the view.
        endTime = userDefaults.object(forKey: endKey) as? Date

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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(Shop.updateCounter)), userInfo: nil, repeats: true)
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
            playSound()
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
        breakTimer.text = "\(min):\(extraZero)\(sec)"
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "xp_ring", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
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