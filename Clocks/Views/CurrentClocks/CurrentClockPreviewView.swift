//
//  CurrentClockPreviewView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/10.
//

import SwiftUI
import WidgetKit

/**
  展示已保存的Clock
 */
struct CurrentClockPreview: View {
    @StateObject private var config: ClockConfigViewModel

    @State private var showAlert = false

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
                .contextMenu(ContextMenu(menuItems: {
                    Button("删除") {
                        showAlert = true
                    }
                }))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("确定要删除吗？"),
                        primaryButton: .destructive(Text("删除")) {
                            ClockConfigManager.shared.deleteConfig(config: config)

                            WidgetCenter.shared.reloadAllTimelines()
                        },
                        secondaryButton: .cancel(Text("取消"))
                    )
                }
            }
        )
    }
}
