//
//  CurrentClockPreviewView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/10.
//

import SwiftUI

/**
  展示已保存的Clock
 */
struct CurrentClockPreview: View {
    @StateObject private var config: ClockConfigViewModel

    init(key: String) {
        let config = ClockConfigManager.shared.getConfigViewModel(key)
        _config = StateObject(wrappedValue: config)
    }

    var body: some View {
        NavigationLink(
            destination: ClocksDetailView(config: config.clone()) { detailConfig in
                ClockWidgetBundleView(date: Date(), config: detailConfig)
            },
            label: {
                WidgetPreviews(widgetFamily: [.systemMedium]) {
                    ClockWidgetBundleView(date: Date(), config: config.toWidgetConfig())
                }
            }
        )
    }
}
