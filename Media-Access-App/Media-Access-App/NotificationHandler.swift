//
//  NotificationHandler.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 1/15/23.
//

import Foundation
import UserNotifications

//https://github.com/indently/SimpleNotifications/blob/main/SimpleNotifications/Handlers/Notifications.swift
//template for setting up easy to use notifications.


class NotificationHandler

{
    init(){
        
        askPermission()
        
    }
    
    func askPermission()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
            success, error in
            
            if success{
                
                print("User granted access for sending notifications")
                
            }
            else if let error = error
            {
                print(error.localizedDescription)
                
            }
            
        }
        
        
    }
    
    
    func sendNotification(dateComponents: DateComponents, type: String, timeInterval:Double, title:String, body: String)
    {
        
        
        var trigger: UNNotificationTrigger? //type of trigger we will use for local notifications.
        
        
        //type of trigger
        
        if type == "date"
        {
            
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
        }
        else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
        }
        
        //content of the notification
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        
        //create the request
        //so this is a local request for a notification
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        
        
    }
    
    func sendNotificationWeekly(triggerDate: DateComponents, title:String, body: String, shouldRepeat: Bool = true)
    {
        var trigger: UNNotificationTrigger?
        
        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: shouldRepeat)
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyAppNotifications(title:String, body:String, day:Int, min: Int, hour: Int)
    {
        
        print("Scheduling Weekly Notifications")
        
        //EX) Schedule notifications every Monday, at 3:30PM,  day = 2, min = 30, hour = 15
        var date = DateComponents()
        date.calendar = Calendar.current
        
        date.weekday = day
        date.hour = hour
        date.minute = min
        
        sendNotificationWeekly(triggerDate: date, title: title , body: body, shouldRepeat: true)
        
    }
    
    func schedulingNotificationAlgorithm()
    {//algorithm that is ran each time captions happen to determine whether more notifications should be sent to the user.
        
        
    }
    
    func printAllScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notficiations) in

                    for localNotification in notficiations {

                        print(localNotification)

                    }
                })
    }
    
    func removeAppNotifications()
    {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    
    
    
}
