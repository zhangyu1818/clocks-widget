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
    var clockName: String
    var textColor: String = "#ffffff"
    var backgroundColor: String = "#000000"

    var is12Hour: Bool = false

    var backgroundImgPath: String?
    var lightMaskBasicImgPath: String?
    var darkMaskBasicImgPath: String?

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

    var backgroundImg: UIImage?
    var lightMaskImg: UIImage?
    var darkMaskImg: UIImage?

    init(
        clockName: String,
        textColor: Color,
        backgroundColor: Color,
        is12Hour: Bool,
        backgroundImg: UIImage?,
        lightMaskImg: UIImage?,
        darkMaskImg: UIImage?
    ) {
        self.clockName = clockName
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.is12Hour = is12Hour
        self.backgroundImg = backgroundImg
        self.lightMaskImg = lightMaskImg
        self.darkMaskImg = darkMaskImg
    }

    // 通过StorableClockConfig来初始化
    init(fromStorableConfig config: StorableClockConfig) {
        var backgroundImg: UIImage?
        var lightMaskImg: UIImage?
        var darkMaskImg: UIImage?

        if let imgPath = config.backgroundImgPath {
            backgroundImg = UIImage(contentsOfFile: imgPath)
        }
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
            backgroundImg: backgroundImg,
            lightMaskImg: lightMaskImg,
            darkMaskImg: darkMaskImg
        )
    }

    static func createEmpty(name: String) -> WidgetClockConfig {
        Self(fromStorableConfig: StorableClockConfig(clockName: name))
    }
}
