//
//  EnvironmentValues.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/6.
//
import SwiftUI
import WidgetKit

enum PreviewsFamily {
    case small
    case medium
    case large
}

struct PreviewsFamilyEnvironmentKey: EnvironmentKey {
    static let defaultValue: WidgetFamily = .systemMedium
}

extension EnvironmentValues {
    var previewsFamily: WidgetFamily {
        get {
            return self[PreviewsFamilyEnvironmentKey]
        }
        set {
            self[PreviewsFamilyEnvironmentKey] = newValue
        }
    }
}
