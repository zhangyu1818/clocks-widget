//
//  SimpleText.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI

struct SimpleClockView: View {
    @Environment(\.previewsFamily) private var previewsFamily
    @Environment(\.colorScheme) var colorScheme

    let config: WidgetClockConfig

    private let currentTime: String
    private let period: String

    private var preferredBackgroundImage: UIImage? {
        (colorScheme == .light ? config.lightMaskImg : config.darkMaskImg) ?? config.backgroundImg
    }

    init(date: Date, config widgetConfig: WidgetClockConfig = WidgetClockConfig.createEmpty(name: "简单时钟")) {
        config = widgetConfig

        let hourFormat = config.is12Hour ? "h" : "H"

        let times = DateFormatter.timeFormatter("\(hourFormat):mm/a")
            .string(from: date)
            .components(separatedBy: "/")

        currentTime = times[0]
        period = times[1]
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
                if let img = preferredBackgroundImage {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                Group {
                    switch previewsFamily {
                    case .systemSmall:
                        VStack(alignment: .leading) {
                            Text(currentTime)
                            Text(period)
                        }
                    default:
                        HStack {
                            Text(currentTime)
                            Text(period)
                        }
                    }
                }
                .foregroundColor(config.textColor)
                .font(Font.system(size: getFontSize(geo)).weight(.heavy))
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .background(config.backgroundColor)
        }
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
