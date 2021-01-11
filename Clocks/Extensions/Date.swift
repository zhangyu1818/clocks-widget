//
//  Date.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import Foundation

extension Date {
    var endDayOfMonth: Int {
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        return range.count
    }
}
