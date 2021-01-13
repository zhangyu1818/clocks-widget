//
//  ClockWidget.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import SwiftUI
import WidgetKit

protocol ClockWidget {
    static var clockName: String { get }

    var config: WidgetClockConfig { get }

    init(date: Date, config widgetConfig: WidgetClockConfig)
}
