//
//  ClockWidgetBundleView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import SwiftUI

struct ClockWidgetBundleView: ClockWidget, View {
    static let clockName: String = ""

    let date: Date
    let config: WidgetClockConfig

    let clockName: String

    init(date: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty(clockName: Self.clockName)) {
        self.date = date
        config = widgetConfig

        clockName = config.clockName
    }

    var body: some View {
        switch clockName {
        case SimpleClockView.clockName:
            SimpleClockView(date: date, config: config)
        case SimpleClock1View.clockName:
            SimpleClock1View(date: date, config: config)
        default:
            GeometryReader { geo in
                Text("请选择要显示的时钟")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}
