//
//  SimpleText.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI

struct SimpleClockView: ClockWidget, View {
    @Environment(\.previewsFamily) private var previewsFamily
    @Environment(\.colorScheme) private var colorScheme

    let config: WidgetClockConfig

    private let currentTime: String
    private let period: String
    private let dateInfo: String

    private var preferredBackgroundImage: UIImage? {
        (colorScheme == .light ? config.lightMaskImg : config.darkMaskImg) ?? config.backgroundImg
    }

    init(date: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty()) {
        config = widgetConfig

        let hourFormat = config.is12Hour ? "h" : "H"

        let formatter = DateFormatter.timeFormatter("\(hourFormat):mm/a/M月D日 E")
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
                Group {
                    switch previewsFamily {
                    case .systemSmall:
                        VStack(alignment: .leading) {
                            Text(currentTime)
                            Text(period)
                            if config.showDateInfo {
                                Text(dateInfo)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .padding(.top)
                            }
                        }
                    default:
                        VStack {
                            Text("\(currentTime) \(period)")
                            if config.showDateInfo {
                                Text(dateInfo)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                        }
                    }
                }
                .foregroundColor(config.textColor)
                .font(Font.system(size: getFontSize(geo)).weight(.heavy))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(config.backgroundColor)
        }
//        .clipShape(ContainerRelativeShape())
    }
}

struct SimpleText_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPreviews {
            WidgetFamilyProvider {
                SimpleClockView(date: Date())
            }
        }
    }
}
