//
//  DateFormatter+TimeFormatter.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import Foundation

extension DateFormatter {
    static func timeFormatter(_ dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
}
