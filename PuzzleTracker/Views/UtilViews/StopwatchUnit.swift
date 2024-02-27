//
//  StopwatchUnit.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/12/23.
//

import SwiftUI

/// Util view to render a stopwatch digit that has a consistent frame (prevents wobbling timer)
struct StopwatchUnit: View {
    var timeUnit: Int
    /// a prefix of "0" is not included for a minute digit
    var unitType: String
    /// allow for different sizes
    var size: String
    
    /// Time unit expressed as String.
    /// - Includes "0" as prefix if this is less than 10.
    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        if unitType != "minute" {
            return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
        }
        return timeUnitStr
    }
    
    var body: some View {
        VStack {
            ZStack {
                if size == "x-small" {
                    HStack(spacing: 1) {
                        Text(timeUnitStr.substring(index: 0))
                            .font(.system(size: 17))
                            .frame(width: 11)
                        if (timeUnitStr.count > 1) {
                            Text(timeUnitStr.substring(index: 1))
                                .font(.system(size: 17))
                                .frame(width: 11)
                        }
                    }
                }
                if size == "small" {
                    HStack(spacing: 1) {
                        Text(timeUnitStr.substring(index: 0))
                            .font(.system(size: 20))
                            .frame(width: 13)
                        if (timeUnitStr.count > 1) {
                            Text(timeUnitStr.substring(index: 1))
                                .font(.system(size: 20))
                                .frame(width: 13)
                        }
                    }
                }
                if size == "medium" {
                    HStack(spacing: 2) {
                        Text(timeUnitStr.substring(index: 0))
                            .font(.system(size: 35))
                            .frame(width: 20)
                        if (timeUnitStr.count > 1) {
                            Text(timeUnitStr.substring(index: 1))
                                .font(.system(size: 35))
                                .frame(width: 20)
                        }
                    }
                }
                if size == "large" {
                    HStack(spacing: 2) {
                        Text(timeUnitStr.substring(index: 0))
                            .font(.system(size: 50))
                            .frame(width: 30)
                        if (timeUnitStr.count > 1) {
                            Text(timeUnitStr.substring(index: 1))
                                .font(.system(size: 50))
                                .frame(width: 30)
                        }
                    }
                }
            }
        }
        .foregroundColor(Color.primary)
    }
}
