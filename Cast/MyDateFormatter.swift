//
//  DateFormatter.swift
//  Cast
//
//  Created by Keith Piong on 29/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation

class MyDateFormatter {
    
    let MediumDateFormatter = DateFormatter()
    
    static func displayTimestamp(datetime: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.date(from: datetime)
        
        return date!
    }
    
    static func isAValidFutureDate(dateString: String) -> Bool {
        guard let dt = dateString as String? else { return false }
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let futureDate = dateFormatter.date(from: dateString)
        
        guard let futureTime = futureDate?.timeIntervalSince1970 else {return false}
        
        let currentTime = currentDate.timeIntervalSince1970
        if futureTime > currentTime  {
            return true
        }
        
        return false
        
    }
    
    static func displayDateTime(datetime: Double) -> String {
        
        let currentDate = Date()
        
        _ = DateFormatter()
        
        let tweetDate = Date(timeIntervalSince1970: datetime)
        //_ = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var duration = 0.0
        if tweetDate.timeIntervalSince1970 > currentDate.timeIntervalSince1970 {
            duration = tweetDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
        }
        else {
            duration = currentDate.timeIntervalSince1970 - tweetDate.timeIntervalSince1970
        }
        
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
        let w = Int(round(duration/60/60/24/7)) //number of weeks
        let m = Int(round(duration/60/60/24/30)) //number of months
        
        //print(d)
        
        if d < 1 {
            return "\(d) hour(s) from now"
        } else if d <= 7 {
            return "\(d) day(s) from now"
        } else if d <= 30 {
            return "\(w) week(s) from now"
        } else {
            return "\(m) month(s) from now"
        }
        
        //        if d < 2 {
        //            return "\(d) minute ahead"
        //        } else {
        //            if (d>=2) && (d<60) {
        //                return "\(d) minutes ahead"
        //            } else {
        //                if (d>=60) && (d<120) {
        //                    return "\(d/60) hour ahead"
        //                } else {
        //                    if (d<1440) {
        //                        return "\(d/60) hours ahead"
        //                    } else {
        //                        if (d >= 1440) && (d<2880) {
        //                            return "\(d/(60*24)) day ahead"
        //                        } else {
        //                            return "\(d/(60*24)) days ahead"
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
}
