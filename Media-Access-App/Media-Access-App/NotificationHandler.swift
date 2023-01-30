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
    
    //get permission for notifications from user. NOTE this will only show up the first time a user uses an app.
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
    
    //Basic Notification Scheduling tools
    func sendNotification(date: Date, type: String, timeInterval:Double, title:String, body: String)
    {
        
        
        var trigger: UNNotificationTrigger? //type of trigger we will use for local notifications.
        
        
        //type of trigger
        
        if type == "date"
        {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
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
    
    //Scheduling Procedures
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
    
    func scheduleWelcomeNotification()
    {
        let title = "Welcome To [App Title]!"
        let body = "Help make the internet more accessible by adding alt-text to your images."
        let time = (60.0) *  (30)
        sendNotification(date: Date(), type: "time" , timeInterval: time, title: title, body: body)
        //schedule a Welcome Notification for 30 minutes after first use.
    
    }
    
    func FirstUseNotificationProcedure()
    {
        self.removeAppNotifications()
        self.scheduleWeeklyAppNotifications(title: "Caption Me!", body: "Have any new photos? Make them accessible-friendly with a click of a button.", day: 2, min: 30, hour: 15)
        self.scheduleWelcomeNotification()
        printAllScheduledNotifications()
    }
    
    
    /*
    func schedulingFrequencyNotificationAlgorithm()
    {//algorithm that is ran each time captions happen to determine whether more notifications should be sent to the user.
        print("running scheduling freq algo")
        let startup_Info = CoreDataManager.shared.loadStartUp()
        var app_usage_stat = 0.0
        let usage_minimum = 0.4
        if(startup_Info == nil)
        {
            print("error loading startup info")
        }
        else
        {
            if(startup_Info!.count < 1)
            {
                print("no startup information exists")
            }
            else
            {
                let current_startup_Info = startup_Info![0]
                
                let daysOfUse = current_startup_Info.daysOfUse
                let numberOfCaptions = current_startup_Info.numberOfCaptions
                
                if(numberOfCaptions != 0 && daysOfUse != 0)
                {
                    app_usage_stat = Double(numberOfCaptions)/Double(daysOfUse)
                    
                    if(app_usage_stat < usage_minimum)
                    {
                        
                        //schedule for some day in near future.
                        print("applying scheduling algo")
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    */
    
    func printAllScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notficiations) in

                    for localNotification in notficiations {
                        print("Scheduled Local Notification")
                        print(localNotification)

                    }
                })
    }
    
    
    
    func removeAppNotifications()
    {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    
    
    
}