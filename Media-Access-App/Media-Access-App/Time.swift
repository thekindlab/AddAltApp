//
//  Time.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 11/21/22.
//

import Foundation
import SwiftUI
import AVKit
import UIKit

class Time: ObservableObject {
    
     @State private var startCaptionTime = 0.0
     @State private var FinishCaptionTime = 0.0
    
     func setStartCaptionTime(newStartTime: Double = 0.0)
    {
        self.startCaptionTime = newStartTime
        
    }
    
    func setFinishCaptionTime(newFinishTime: Double = 0.0)
    {
        FinishCaptionTime = newFinishTime
        
    }
    
    func getFinishCaptionTime() -> Double
    {
        return FinishCaptionTime
        
    }
    
    func getStartCaptionTime() ->Double
    {
        return startCaptionTime
        
    }
    
}
