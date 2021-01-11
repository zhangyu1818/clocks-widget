//
//  WidgetPreviews.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

/**
 根据WidgetFamily显示不同大小的widget
 */
struct WidgetPreviews<Widget: View>: View {
    let widget: Widget
    let widgetFamily: [WidgetFamily]

    private let widgetSizeSmall = DeviceWidgetSize.small
    private let widgetSizeMeduim = DeviceWidgetSize.meduim

    init(widgetFamily: [WidgetFamily] = [.systemSmall, .systemMedium], @ViewBuilder _ widget: @escaping () -> Widget) {
        self.widget = widget()
        self.widgetFamily = widgetFamily
    }

    var body: some View {
        HStack(spacing: 24) {
            Group {
                if widgetFamily.contains(.systemSmall) {
                    widget
                        .frame(width: widgetSizeSmall.width, height: widgetSizeSmall.height)
                        .environment(\.previewsFamily, .systemSmall)
                }
                if widgetFamily.contains(.systemMedium) {
                    widget
                        .frame(width: widgetSizeMeduim.width, height: widgetSizeMeduim.height)
                        .environment(\.previewsFamily, .systemMedium)
                }
            }
            .cornerRadius(24)
        }
    }
}

struct WidgetPreviews_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPreviews {
            Text("preview")
        }
    }
}
