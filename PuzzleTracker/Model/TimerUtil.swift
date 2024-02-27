//
//  TimerUtil.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/12/23.
//

import Foundation

struct TimerUtil {
    func secondsTominutes(seconds: Int) -> String {
        let minutes = seconds / 60
        if minutes == 0 {
            return "0"
        }
        return String(minutes)
    }
    
    func secondsToseconds(seconds: Int) -> String {
        let seconds = seconds % 60
        if seconds == 0 {
            return "00"
        }
        if seconds < 10 {
            return "0\(seconds)"
        }
        return String(seconds)
    }
}
