//
//  SimplePicture.swift
//  Clocks
//
//  Created by ZhangYu on 2021/2/5.
//

import SwiftUI

struct SimplePicture: ClockWidget, View {
    static let clockName = "简单图片"
    static let nonConfigurableFields: [String] = [
        WidgetDetailConfigFields.textColor,
        WidgetDetailConfigFields.is12Hour,
        WidgetDetailConfigFields.showDateInfo,
    ]

    @Environment(\.colorScheme) private var colorScheme

    let config: WidgetClockConfig

    private var preferredBackgroundImage: UIImage? {
        config.preferredBackgroundImage(colorScheme: colorScheme)
    }

    init(date _: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty(clockName: Self.clockName)) {
        config = widgetConfig
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                WidgetBackground(uiImage: preferredBackgroundImage, blur: config.blur)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .background(preferredBackgroundImage != nil ? Color.clear : config.backgroundColor)
    }
}

struct SimplePicture_Previews: PreviewProvider {
    static var previews: some View {
        SimplePicture(date: Date())
    }
}
