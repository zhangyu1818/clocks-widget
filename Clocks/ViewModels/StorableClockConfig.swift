//
//  ClockConfig.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/6.
//
import SwiftUI

/**
 储存在UserDefaults里的原始数据
 */
struct StorableClockConfig: Codable {
    var configKey: String
    var clockName: String
    var textColor: String = "#ffffff"
    var backgroundColor: String = "#000000"

    var is12Hour: Bool = false
    var showDateInfo: Bool = true

    var blur: Bool = false

    var lightBasicImgPath: String?
    var darkBasicImgPath: String?

    var lightMaskImgPath: String?
    var darkMaskImgPath: String?
}

/**
 组件读取的config信息
 */
struct WidgetClockConfig {
    var clockName: String
    var textColor: Color
    var backgroundColor: Color

    var is12Hour: Bool = false
    var showDateInfo: Bool = true

    var lightBasicImg: UIImage?
    var darkBasicImg: UIImage?

    var lightMaskImg: UIImage?
    var darkMaskImg: UIImage?

    var blur: Bool = false

    init(
        clockName: String,
        textColor: Color,
        backgroundColor: Color,
        is12Hour: Bool,
        showDateInfo: Bool,
        blur: Bool,
        lightBasicImg: UIImage?,
        darkBasicImg: UIImage?,
        lightMaskImg: UIImage?,
        darkMaskImg: UIImage?
    ) {
        self.clockName = clockName
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.is12Hour = is12Hour
        self.showDateInfo = showDateInfo
        self.blur = blur
        self.lightBasicImg = lightBasicImg
        self.darkBasicImg = darkBasicImg
        self.lightMaskImg = lightMaskImg
        self.darkMaskImg = darkMaskImg
    }

    // 通过StorableClockConfig来初始化
    init(fromStorableConfig config: StorableClockConfig) {
        var lightBasicImg: UIImage?
        var darkBasicImg: UIImage?

        if let imgPath = config.lightBasicImgPath {
            lightBasicImg = UIImage(contentsOfFile: imgPath)
        }
        if let imgPath = config.darkBasicImgPath {
            darkBasicImg = UIImage(contentsOfFile: imgPath)
        }

        var lightMaskImg: UIImage?
        var darkMaskImg: UIImage?

        if let imgPath = config.lightMaskImgPath {
            lightMaskImg = UIImage(contentsOfFile: imgPath)
        }
        if let imgPath = config.darkMaskImgPath {
            darkMaskImg = UIImage(contentsOfFile: imgPath)
        }

        self.init(
            clockName: config.clockName,
            textColor: Color(hexString: config.textColor),
            backgroundColor: Color(hexString: config.backgroundColor),
            is12Hour: config.is12Hour,
            showDateInfo: config.showDateInfo,
            blur: config.blur,
            lightBasicImg: lightBasicImg,
            darkBasicImg: darkBasicImg,
            lightMaskImg: lightMaskImg,
            darkMaskImg: darkMaskImg
        )
    }

    func preferredBackgroundImage(colorScheme: ColorScheme) -> UIImage? {
        if colorScheme == .light {
            return lightMaskImg ?? lightBasicImg ?? darkMaskImg ?? darkBasicImg
        } else if colorScheme == .dark {
            return darkMaskImg ?? darkBasicImg ?? lightMaskImg ?? lightBasicImg
        }
        return nil
    }

    static func createEmpty(clockName: String) -> WidgetClockConfig {
        let defaultStyle = defaultClockStyle[clockName]
        if let style = defaultStyle {
            return Self(fromStorableConfig: StorableClockConfig(configKey: "defaultKey", clockName: clockName, textColor: style.textColor.toHexString(), backgroundColor: style.backgroundColor.toHexString()))
        }
        return Self(fromStorableConfig: StorableClockConfig(configKey: "defaultKey", clockName: "defaultName"))
    }
}
