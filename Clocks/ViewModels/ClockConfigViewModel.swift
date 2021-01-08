//
//  ClockConfigViewModel.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/4.
//

import SwiftUI

/**
 小组件所需要的StateObject
 */
class ClockConfigViewModel: ObservableObject {
    @Published var clockName: String
    @Published var textColor: Color
    @Published var backgroundColor: Color

    @Published var is12Hour: Bool

    @Published var backgroundImgPath: String?
    @Published var lightMaskBasicImgPath: String?
    @Published var darkMaskBasicImgPath: String?

    @Published var lightMaskImgPath: String?
    @Published var darkMaskImgPath: String?

    init(
        clockName: String,
        textColor: Color = Color.white,
        backgroundColor: Color = Color.black,
        is12Hour: Bool = false,
        backgroundImgPath: String? = nil,
        lightMaskBasicImgPath: String? = nil,
        darkMaskBasicImgPath: String? = nil,
        lightMaskImgPath: String? = nil,
        darkMaskImgPath: String? = nil
    ) {
        self.clockName = clockName
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.is12Hour = is12Hour
        self.backgroundImgPath = backgroundImgPath
        self.lightMaskBasicImgPath = lightMaskBasicImgPath
        self.darkMaskBasicImgPath = darkMaskBasicImgPath
        self.lightMaskImgPath = lightMaskImgPath
        self.darkMaskImgPath = darkMaskImgPath
    }

    // 转为可储存在UserDefaults里的config类型
    func toStorableConfig() -> StorableClockConfig {
        StorableClockConfig(
            clockName: clockName,
            textColor: textColor.toHexString(),
            backgroundColor: backgroundColor.toHexString(),
            is12Hour: is12Hour,
            backgroundImgPath: backgroundImgPath,
            lightMaskBasicImgPath: lightMaskBasicImgPath,
            darkMaskBasicImgPath: darkMaskBasicImgPath,
            lightMaskImgPath: lightMaskImgPath,
            darkMaskImgPath: darkMaskImgPath
        )
    }

    // 转为小组件所需类型的配置信息
    func toWidgetConfig() -> WidgetClockConfig {
        WidgetClockConfig(fromStorableConfig: toStorableConfig())
    }

    func clone() -> ClockConfigViewModel {
        ClockConfigViewModel(
            clockName: clockName,
            textColor: textColor,
            backgroundColor: backgroundColor,
            is12Hour: is12Hour,
            backgroundImgPath: backgroundImgPath,
            lightMaskBasicImgPath: lightMaskBasicImgPath,
            darkMaskBasicImgPath: darkMaskBasicImgPath,
            lightMaskImgPath: lightMaskImgPath,
            darkMaskImgPath: darkMaskImgPath
        )
    }
}

/**
 管理小组件的配置
 */
class ClockConfigManager {
    static let shared = ClockConfigManager()

    private var configs = [String: ClockConfigViewModel]()

    private init() {}

    func getConfigViewModel(_ name: String) -> ClockConfigViewModel {
        guard let config = configs[name] else {
            let newConfig = readConfig(name: name)
            configs[name] = newConfig
            return configs[name]!
        }
        return config
    }

    func updateConfig(name: String, newConfig: ClockConfigViewModel) {
        guard let config = configs[name] else {
            return
        }

        config.textColor = newConfig.textColor
        config.backgroundColor = newConfig.backgroundColor
        config.is12Hour = newConfig.is12Hour

        config.backgroundImgPath = newConfig.backgroundImgPath
        config.lightMaskBasicImgPath = newConfig.lightMaskBasicImgPath
        config.darkMaskBasicImgPath = newConfig.darkMaskBasicImgPath
        config.lightMaskImgPath = newConfig.lightMaskImgPath
        config.darkMaskImgPath = newConfig.darkMaskImgPath

        saveConfig(name: name, config: config.toStorableConfig())
    }

    private func readConfig(name: String) -> ClockConfigViewModel {
        let defaultValue = ClockConfigViewModel(clockName: name)

        return getWidgetConfig(name, defaultValue: defaultValue) { config in
            ClockConfigViewModel(
                clockName: config.clockName,
                textColor: Color(hexString: config.textColor),
                backgroundColor: Color(hexString: config.backgroundColor),
                is12Hour: config.is12Hour,
                backgroundImgPath: config.backgroundImgPath,
                lightMaskBasicImgPath: config.lightMaskBasicImgPath,
                darkMaskBasicImgPath: config.darkMaskBasicImgPath,
                lightMaskImgPath: config.lightMaskImgPath,
                darkMaskImgPath: config.darkMaskImgPath
            )
        }
    }

    private func saveConfig(name: String, config: StorableClockConfig) {
        let data = try? JSONEncoder().encode(config)
        if let userDefaults = UserDefaults(suiteName: "group.zhangyu1818.clocks") {
            userDefaults.setValue(data, forKey: name)
        }
    }
}
