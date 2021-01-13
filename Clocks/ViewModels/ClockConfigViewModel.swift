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
    @Published var textColor: Color
    @Published var backgroundColor: Color

    @Published var is12Hour: Bool
    @Published var showDateInfo: Bool
    @Published var blur: Bool

    @Published var backgroundImgPath: String?
    @Published var lightMaskBasicImgPath: String?
    @Published var darkMaskBasicImgPath: String?

    @Published var lightMaskImgPath: String?
    @Published var darkMaskImgPath: String?

    // configKey作为userdefaults的键
    fileprivate(set) var configKey: String
    fileprivate(set) var clockName: String
    fileprivate(set) var isNewConfig = false

    init(
        configKey: String,
        clockName: String,
        textColor: Color = Color.clear,
        backgroundColor: Color = Color.clear,
        is12Hour: Bool = false,
        showDateInfo: Bool = true,
        blur: Bool = false,
        backgroundImgPath: String? = nil,
        lightMaskBasicImgPath: String? = nil,
        darkMaskBasicImgPath: String? = nil,
        lightMaskImgPath: String? = nil,
        darkMaskImgPath: String? = nil
    ) {
        self.configKey = configKey

        self.clockName = clockName
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.is12Hour = is12Hour
        self.showDateInfo = showDateInfo
        self.blur = blur
        self.backgroundImgPath = backgroundImgPath
        self.lightMaskBasicImgPath = lightMaskBasicImgPath
        self.darkMaskBasicImgPath = darkMaskBasicImgPath
        self.lightMaskImgPath = lightMaskImgPath
        self.darkMaskImgPath = darkMaskImgPath

        guard let defaultStyle = defaultClockStyle[clockName] else { return }
        if self.textColor == Color.clear {
            self.textColor = defaultStyle.textColor
        }
        if self.backgroundColor == Color.clear {
            self.backgroundColor = defaultStyle.backgroundColor
        }
    }

    // 转为可储存在UserDefaults里的config类型
    func toStorableConfig() -> StorableClockConfig {
        StorableClockConfig(
            configKey: configKey,
            clockName: clockName,
            textColor: textColor.toHexString(),
            backgroundColor: backgroundColor.toHexString(),
            is12Hour: is12Hour,
            showDateInfo: showDateInfo,
            blur: blur,
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

    // clone一份在详情页面里使用
    func clone() -> ClockConfigViewModel {
        ClockConfigViewModel(
            configKey: configKey,
            clockName: clockName,
            textColor: textColor,
            backgroundColor: backgroundColor,
            is12Hour: is12Hour,
            showDateInfo: showDateInfo,
            blur: blur,
            backgroundImgPath: backgroundImgPath,
            lightMaskBasicImgPath: lightMaskBasicImgPath,
            darkMaskBasicImgPath: darkMaskBasicImgPath,
            lightMaskImgPath: lightMaskImgPath,
            darkMaskImgPath: darkMaskImgPath
        )
    }

    // 删除所有图片
    func deleteImage() {
        // 从本地删除图片
        removeImages(
            [
                backgroundImgPath,
                lightMaskBasicImgPath,
                lightMaskImgPath,
                darkMaskBasicImgPath,
                darkMaskImgPath,
            ]
        )

        backgroundImgPath = nil
        lightMaskBasicImgPath = nil
        lightMaskImgPath = nil
        darkMaskBasicImgPath = nil
        darkMaskImgPath = nil
    }
}

/**
 管理小组件的配置
 */
class ClockConfigManager {
    static let shared = ClockConfigManager()

    private var configs = [String: ClockConfigViewModel]()

    private init() {}

    // 创建一个新的ViewModel，作为新增配置时使用
    func createConfigViewModel(clockName: String) -> ClockConfigViewModel {
        let newConfigKey = UUID().uuidString
        let config = ClockConfigViewModel(configKey: newConfigKey, clockName: clockName)
        config.isNewConfig = true
        return config
    }

    // 通过configKey从现有的获取
    func getConfigViewModel(_ configKey: String) -> ClockConfigViewModel {
        guard let config = configs[configKey] else {
            let newConfig = readConfig(key: configKey)
            configs[configKey] = newConfig
            return configs[configKey]!
        }
        return config
    }

    // 更新config
    func updateConfig(newConfig: ClockConfigViewModel) {
        // 如果是新的config需要重新分配一个uuid
        if newConfig.isNewConfig {
            newConfig.isNewConfig = false
        }
        // 更新已存在的
        if let config = configs[newConfig.configKey] {
            config.textColor = newConfig.textColor
            config.backgroundColor = newConfig.backgroundColor
            config.is12Hour = newConfig.is12Hour
            config.showDateInfo = newConfig.showDateInfo
            config.blur = newConfig.blur

            config.backgroundImgPath = newConfig.backgroundImgPath
            config.lightMaskBasicImgPath = newConfig.lightMaskBasicImgPath
            config.darkMaskBasicImgPath = newConfig.darkMaskBasicImgPath
            config.lightMaskImgPath = newConfig.lightMaskImgPath
            config.darkMaskImgPath = newConfig.darkMaskImgPath
        } else {
            // 不存在添加新的配置
            let configKey = newConfig.configKey
            configs[configKey] = newConfig

            // 同步更新ConfigKeys到ConfigKeysViewModel
            ConfigKeysViewModel.shared.add(configKey: configKey)
        }

        // 保存
        saveConfig(key: newConfig.configKey, config: newConfig.toStorableConfig())
    }

    // 删除config
    func deleteConfig(config: ClockConfigViewModel) {
        let configKey = config.configKey
        // 删除字典里的config
        configs.removeValue(forKey: configKey)
        // 删除userdefaults里的config
        deleteConfigKeys(key: configKey)
        // 删除保存组件列表里的config
        ConfigKeysViewModel.shared.delete(configKey: configKey)
    }

    // 删除所有config
    func deleteAllConfig() {
        configs.values.forEach { config in deleteConfig(config: config) }
    }

    // 从userDefaults读取配置，如果没有就返回一个默认值
    private func readConfig(key: String) -> ClockConfigViewModel {
        let defaultValue = ClockConfigViewModel(configKey: "defaultKey", clockName: "defaultName")

        return getWidgetConfig(key, defaultValue: defaultValue) { config in
            ClockConfigViewModel(
                configKey: config.configKey,
                clockName: config.clockName,
                textColor: Color(hexString: config.textColor),
                backgroundColor: Color(hexString: config.backgroundColor),
                is12Hour: config.is12Hour,
                showDateInfo: config.showDateInfo,
                blur: config.blur,
                backgroundImgPath: config.backgroundImgPath,
                lightMaskBasicImgPath: config.lightMaskBasicImgPath,
                darkMaskBasicImgPath: config.darkMaskBasicImgPath,
                lightMaskImgPath: config.lightMaskImgPath,
                darkMaskImgPath: config.darkMaskImgPath
            )
        }
    }

    // 保存配置到userDefaults
    private func saveConfig(key: String, config: StorableClockConfig) {
        let data = try? JSONEncoder().encode(config)
        if let userDefaults = appUserDefaults() {
            userDefaults.setValue(data, forKey: key)
        }
    }
}
