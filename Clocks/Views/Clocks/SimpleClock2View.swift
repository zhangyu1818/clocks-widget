//
//  SimpleClock2View.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/12.
//

import SwiftUI

struct SimpleClock2View: ClockWidget, View {
    @Environment(\.previewsFamily) private var previewsFamily
    @Environment(\.colorScheme) private var colorScheme

    let config: WidgetClockConfig

    private let currentTime: String
    private let period: String
    private let dateInfo: String

    private var preferredBackgroundImage: UIImage? {
        (colorScheme == .light ? config.lightMaskImg : config.darkMaskImg) ?? config.backgroundImg
    }

    private var dateInfoSize: Font { previewsFamily == .systemSmall ? .headline : .title3 }
    private var periodOffset: CGFloat { previewsFamily == .systemSmall ? 10 : 22 }

    private func getPeriodSize(_ geo: GeometryProxy) -> Font {
        previewsFamily == .systemSmall ? Font.system(size: geo.size.width / 1.8).weight(.medium) : Font.system(size: geo.size.width / 2).weight(.medium)
    }

    init(date: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty()) {
        config = widgetConfig

        let hourFormat = config.is12Hour ? "h" : "H"

        let formatter = DateFormatter.timeFormatter("\(hourFormat):mm/a/M月D日，E")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let times = formatter
            .string(from: date)
            .components(separatedBy: "/")

        currentTime = times[0]
        period = times[1]
        dateInfo = times[2]
    }

    private func getFontSize(_ geo: GeometryProxy) -> CGFloat {
        switch previewsFamily {
        case .systemSmall:
            return geo.size.width / 4
        case .systemMedium:
            return geo.size.width / 6
        default:
            return 72
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                WidgetBackground(uiImage: preferredBackgroundImage, blur: config.blur)
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    if previewsFamily == .systemSmall {
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(period)
                            .font(getPeriodSize(geo))
                            .foregroundColor(Color.white.opacity(0.2))
                    }
                }
                .offset(x: periodOffset)
                .frame(height: geo.size.height)
                HStack {
                    VStack(alignment: .leading) {
                        if config.showDateInfo {
                            Text("\(dateInfo)")
                                .font(dateInfoSize)
                                .fontWeight(.medium)
                        }
                        Spacer()
                        Text(currentTime)
                            .font(Font.system(size: geo.size.width / 4.5).weight(.bold))
                            .offset(y: geo.size.width / 15)
                    }
                    Spacer()
                }
                .foregroundColor(config.textColor)
                .padding()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(config.backgroundColor)
        }
//        .clipShape(ContainerRelativeShape())
    }
}

struct SimpleClock2View_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPreviews {
            WidgetFamilyProvider {
                SimpleClock2View(date: Date())
            }
        }
    }
}
