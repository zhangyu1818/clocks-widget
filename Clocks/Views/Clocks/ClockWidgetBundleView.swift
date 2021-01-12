//
//  ClockWidgetBundleView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import SwiftUI

struct ClockWidgetBundleView: ClockWidget, View {
    let date: Date
    let config: WidgetClockConfig

    let clockName: String

    init(date: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty()) {
        self.date = date
        config = widgetConfig

        clockName = config.clockName
    }

    var body: some View {
        switch clockName {
        case "简单时钟":
            SimpleClockView(date: date, config: config)
        case "简单时钟1":
            SimpleClock2View(date: date, config: config)
        default:
            Text("请选择要显示的时钟")
                .font(.subheadline)
        }
    }
}
