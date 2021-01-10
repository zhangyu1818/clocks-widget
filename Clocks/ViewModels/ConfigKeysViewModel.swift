//
//  UserWidgetViewModel.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/9.
//
import SwiftUI

/**
 对已保存的小组件的configKey做管理
 */
class ConfigKeysViewModel: ObservableObject {
    static let shared = ConfigKeysViewModel()

    @Published private(set) var configKeys: [String] {
        didSet {
            saveConfigKeys(configKeys: configKeys)
        }
    }

    private init() {
        configKeys = getSavedConfigKeys()
    }

    // 新增configKey
    func add(configKey: String) {
        configKeys.append(configKey)
    }

    // 删除configKey
    func delete(configKey: String) {
        configKeys = configKeys.filter { $0 != configKey }
    }
}
