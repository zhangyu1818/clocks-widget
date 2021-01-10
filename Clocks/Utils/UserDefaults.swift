//
//  UserDefaults.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/7.
//

import Foundation

func appUserDefaults() -> UserDefaults? {
    UserDefaults(suiteName: "group.zhangyu1818.clocks")
}

func getWidgetConfig<T>(_ key: String, defaultValue: T, parseConfig: (StorableClockConfig) -> T) -> T {
    guard let userDefaults = appUserDefaults() else {
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

let CONFIG_KEY_NAME = "savedWidgetConfig"

func getSavedConfigKeys() -> [String] {
    guard let userDefaults = appUserDefaults() else {
        return []
    }

    guard let data = userDefaults.array(forKey: CONFIG_KEY_NAME) as? [String] else {
        return []
    }
    return data
}

func saveConfigKeys(configKeys: [String]) {
    guard let userDefaults = appUserDefaults() else {
        return
    }

    userDefaults.setValue(configKeys, forKey: CONFIG_KEY_NAME)
}

func addConfigKeys(key: String) {
    var configKeys = getSavedConfigKeys()
    configKeys.append(key)
    saveConfigKeys(configKeys: configKeys)
}

func deleteConfigKeys(key: String) {
    guard let userDefaults = appUserDefaults() else { return }
    userDefaults.removeObject(forKey: key)
}
