//
//  WidgetFamilyProvider.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/6.
//

import SwiftUI
import WidgetKit

/**
 将widgetFamily转为自定义的previewsFamily传递
 */
struct WidgetFamilyProvider<Widget: View>: View {
    @Environment(\.widgetFamily) private var widgetFamily

    let widget: Widget

    init(@ViewBuilder _ widget: @escaping () -> Widget) {
        self.widget = widget()
    }

    var body: some View {
        widget.environment(\.previewsFamily, widgetFamily)
    }
}

struct WidgetFamilyProvider_Previews: PreviewProvider {
    static var previews: some View {
        WidgetFamilyProvider {
            Text("Provider")
        }
    }
}
