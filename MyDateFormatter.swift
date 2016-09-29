//
//  DateFormatter.swift
//  Cast
//
//  Created by Keith Piong on 29/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation

class MyDateFormatter {

    
    static func displayDateTime(datetime: Double) -> String {
        
        let currentDate = Date()
        
        _ = DateFormatter()
        let tweetDate = Date(timeIntervalSince1970: datetime)
        _ = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let duration = currentDate.timeIntervalSince1970 - tweetDate.timeIntervalSince1970
        //print("diff \(duration/60)..\(currentDate.timeIntervalSince1970)..\(tweetDate.timeIntervalSince1970)")
        
        //        let today = x!.isDateInToday(tweetDate)
        //
        //        if today {
        //            dateFormatter.dateFormat = "HH:MM"
        //        } else {
        //            dateFormatter.dateFormat = "MMM dd, yyyy HH:MM"
        //        }
        
        //        return dateFormatter.stringFromDate(tweetDate)
        
        //var d : Int
        let d = Int(round(duration/60))
        
        
        if d < 2 {
            return "\(d) minute ahead"
        } else {
            if (d>=2) && (d<60) {
                return "\(d) minutes ahead"
            } else {
                if (d>=60) && (d<120) {
                    return "\(d/60) hour ahead"
                } else {
                    if (d<1440) {
                        return "\(d/60) hours ahead"
                    } else {
                        if (d >= 1440) && (d<2880) {
                            return "\(d/(60*24)) day ahead"
                        } else {
                            return "\(d/(60*24)) days ahead"
                        }
                    }
                }
            }
        }
    }
}
