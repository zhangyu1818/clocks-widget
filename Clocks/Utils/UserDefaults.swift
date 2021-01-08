//
//  UserDefaults.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/7.
//

import Foundation

func getWidgetConfig<T>(_ key: String, defaultValue: T, parseConfig: (StorableClockConfig) -> T) -> T {
    guard let userDefaults = UserDefaults(suiteName: "group.zhangyu1818.clocks") else {
        return defaultValue
    }

    guard let data = userDefaults.object(forKey: key) as? Data else {
        return defaultValue
    }

    guard let config = try? JSONDecoder().decode(StorableClockConfig.self, from: data) else {
        return defaultValue
    }

    return parseConfig(config)
}
