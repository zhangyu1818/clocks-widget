//
//  WidgetPreviews.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

struct WidgetPreviews<Widget: View>: View {
    let widget: Widget
    let widgetFamily: [WidgetFamily]

    init(@ViewBuilder _ widget: @escaping () -> Widget, widgetFamily: [WidgetFamily] = [.systemSmall, .systemMedium]) {
        self.widget = widget()
        self.widgetFamily = widgetFamily
    }

    var body: some View {
        HStack(spacing: 24) {
            Group {
                if widgetFamily.contains(.systemSmall) {
                    widget
                        .frame(width: 169, height: 169)
                        .environment(\.previewsFamily, .systemSmall)
                }
                if widgetFamily.contains(.systemMedium) {
                    widget
                        .frame(width: 360, height: 169)
                        .environment(\.previewsFamily, .systemMedium)
                }
                if widgetFamily.contains(.systemLarge) {
                    widget
                        .frame(width: 360, height: 376)
                        .environment(\.previewsFamily, .systemLarge)
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
