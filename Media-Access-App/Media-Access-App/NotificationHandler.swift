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
        print("ASK PERMISSION")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
            success, error in
            
            if success{
                
                print("User granted access for sending notifications")
                self.FirstUseNotificationProcedure()
                
            }
            else if let error = error
            {
                print(error.localizedDescription)
                
            }
            
        }
        
        
    }
    func basicNotification()
    {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is an example notification."
        content.sound = UNNotificationSound.default
        // Triggering notification after a certain time
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //Scheduling notification for a certain time every day
        var dateComponents = DateComponents()
        //dateComponents.calendar = Calendar.current
        dateComponents.hour = 17
        dateComponents.minute = 36
        
        //Weekly Notifications
        //dateComponents.year = 2024
        //dateComponents.day = 11
        //dateComponents.weekday = 5
        //dateComponents.weekdayOrdinal = 2
        
        //dateComponents.timeZone = .current
        //let calendar = Calendar(identifier: .gregorian)
        //let calendar = Calendar.current
        //let date = calendar.date(from: dateComponents)!
        //let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
                   guard error == nil else { return }
            print("Scheduling notification with id: \(request.identifier)")
               }
        printAllScheduledNotifications()
    }
    
    func scheduleDailyNotification(text:String, hour:Int){
        let content = UNMutableNotificationContent()
        content.title = "Accessible Media App"
        content.body = text
        content.sound = UNNotificationSound.default
        
        //Scheduling notification for a certain time every day
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 50
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //Schedule request
        UNUserNotificationCenter.current().add(request) { error in
                   guard error == nil else { return }
            print("Scheduling notification with id: \(request.identifier)")
               }
        printAllScheduledNotifications()
        
    }
    
    
    //Basic Notification Scheduling tools
//    func sendNotification(date: Date, type: String, timeInterval:Double, title:String, body: String)
//    {
//        
//        let title = "Welcome To [App Title]!"
//        let body = "Help make the internet more accessible by adding alt-text to your images."
//        let time = (60.0) *  (30)
//        sendNotification(date: Date(), type: "time" , timeInterval: time, title: title, body: body)
//        
//        var trigger: UNNotificationTrigger? //type of trigger we will use for local notifications.
//        
//        //type of trigger
//        if type == "date"
//        {
//            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
//            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        }
//        else if type == "time" {
//            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//        }
//        
//        //content of the notification
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = UNNotificationSound.default
//        
//        //create the request
//        //so this is a local request for a notification
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double, title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        
        // Create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = type
        content.sound = UNNotificationSound.default

        // Create the trigger for the notification
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true) // repeats: true will make it daily
        
        // Create the request for the notification
        let identifier = UUID().uuidString // unique identifier for the request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add the notification request to the notification center
        center.add(request) { (error) in
            if let error = error {
                print("Error adding notification with identifier: \(identifier)")
                print(error.localizedDescription)
            }
        }
    }
    
    // Add this new method to your NotificationHandler class by Binh Ngo
    func sendNotificationDaily(triggerDate: DateComponents, title:String, body: String, shouldRepeat: Bool = true)
    {
        var trigger: UNNotificationTrigger?
        
        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: shouldRepeat)
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        printAllScheduledNotifications()
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
        printAllScheduledNotifications()
    }
    
    /*
     *
     *Scheduling Procedures
     *
     */
    
    // Scheduling Daily Notification Procedure by Binh Ngo
    func scheduleDailyAppNotifications(title:String, body:String, min: Int, hour: Int)
    {
        
        print("Scheduling Weekly Notifications")
        
        //EX) Schedule notifications every Monday, at 3:30PM,  day = 2, min = 30, hour = 15
        var date = DateComponents()
        date.calendar = Calendar.current
        
        date.hour = hour
        date.minute = min
        
        sendNotificationDaily(triggerDate: date, title: title , body: body, shouldRepeat: true)
        
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
    
    func scheduleWelcomeNotification()
    {
        let title = "Welcome To Accessibility App!"
        let body = "Help make the internet more accessible by adding alt-text to your images."
        //let time = (60.0) *  (30)
        let time = (60.0) * 10
        sendNotification(date: Date(), type: "time" , timeInterval: time, title: title, body: body)
        print("Scheduled welcome notification.")
        printAllScheduledNotifications()
        //schedule a Welcome Notification for 30 minutes after first use.
    
    }
    
    func FirstUseNotificationProcedure()
    {
        self.removeAppNotifications()
        //self.basicNotification()
        //print("scheduled basic notification")
       // self.scheduleWeeklyAppNotifications(title: "Caption Me!", body: "Have any new photos? Make them accessible-friendly with a click of a button.", day: 2, min: 30, hour: 15)
        //self.scheduleDailyAppNotifications(title: "Caption Me Daily!", body: "Have any new photos? Make them accessible-friendly with a click of a button.", min: 35, hour: 13)
        //self.scheduleWelcomeNotification()
        //printAllScheduledNotifications()
        //print("Testng daily notification")
        scheduleDailyNotification(text: "“Don’t forget to caption your images in the Media Accessibility App!", hour: 11)
        //print("END of FirstUseNotificationProcedure")
    }
    
    
    /*
    func schedulingFrequencyNotificationAlgorithm()s
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
        print("PRINTING SCHEDULED NOTIFICATIONS:")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notficiations in
            
            if notficiations.isEmpty{
                print("EMPTY Notification Scheduler")
            }

                    for localNotification in notficiations {
                        print("Scheduled Local Notification")
                        print(localNotification)

                    }
                })
         
        /*UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
             for notificationRequest:UNNotificationRequest in notificationRequests {
                print(notificationRequest.identifier)
            }
            if notificationRequests.isEmpty{
                print("EMPTY Notification Scheduler")
            }
        }
         */
        //print("Ended Print Func")
    }
    
    
    
    func removeAppNotifications()
    {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }

    
    
    
    
}
