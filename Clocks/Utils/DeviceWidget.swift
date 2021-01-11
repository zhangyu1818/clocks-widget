//
//  DeviceWidget.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import SwiftUI

// 小组件在屏幕上的位置
struct DeviceWidgetPosition {
    // 小组件 左上
    static var smallTopLeft: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 82)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 77)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 77)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 76)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 71)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 38)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 28, y: 30)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 14, y: 30)
        default:
            return CGPoint(x: 27, y: 76)
        }
    }

    // 小组件 右上
    static var smallTopRight: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 226, y: 82)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 206, y: 77)
        case .iPhone12Mini:
            return CGPoint(x: 197, y: 77)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 218, y: 76)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 197, y: 71)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 224, y: 38)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 200, y: 30)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 165, y: 30)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 小组件 中左
    static var smallCenterLeft: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 294)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 273)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 267)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 286)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 261)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 232)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 27, y: 206)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 14, y: 200)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 小组件 中右
    static var smallCenterRight: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 226, y: 294)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 206, y: 273)
        case .iPhone12Mini:
            return CGPoint(x: 197, y: 267)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 218, y: 286)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 197, y: 261)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 224, y: 232)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 200, y: 206)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 165, y: 200)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 小组件 下左
    static var smallBottomLeft: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 506)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 469)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 457)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 495.3333)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 451)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 426)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 27, y: 382)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 0, y: 0)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 小组件 下右
    static var smallBottomRight: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 226, y: 506)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 206, y: 469)
        case .iPhone12Mini:
            return CGPoint(x: 197, y: 457)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 218, y: 495.3333)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 197, y: 451)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 224, y: 426)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 200, y: 382)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 0, y: 0)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 中组件 上方
    static var mediumTop: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 82)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 77)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 77)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 76)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 71)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 38)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 28, y: 30)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 14, y: 30)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 中组件 中间
    static var mediumCenter: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 294)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 273)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 267)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 286)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 261)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 232)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 27, y: 206)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 14, y: 200)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }

    // 中组件 下方
    static var mediumBottom: CGPoint {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGPoint(x: 32, y: 506)
        case .iPhone12Pro, .iPhone12:
            return CGPoint(x: 26, y: 469)
        case .iPhone12Mini:
            return CGPoint(x: 23, y: 457)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGPoint(x: 27, y: 495.3333)
        case .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGPoint(x: 23, y: 451)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGPoint(x: 33, y: 426)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGPoint(x: 27, y: 382)
        case .iPhoneSE, .iPod7:
            return CGPoint(x: 0, y: 0)
        default:
            return CGPoint(x: 218, y: 76)
        }
    }
}

// 小组件的大小
enum DeviceWidgetSize {
    static var small: CGSize {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGSize(width: 170, height: 170)
        case .iPhone12Pro, .iPhone12:
            return CGSize(width: 158, height: 158)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGSize(width: 169, height: 169)
        case .iPhone12Mini, .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGSize(width: 155, height: 155)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGSize(width: 159, height: 159)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGSize(width: 148, height: 148)
        case .iPhoneSE, .iPod7:
            return CGSize(width: 141, height: 144)
        default:
            return CGSize(width: 169, height: 169)
        }
    }

    static var meduim: CGSize {
        switch UIDevice().type {
        case .iPhone12ProMax:
            return CGSize(width: 364, height: 170)
        case .iPhone12Pro, .iPhone12:
            return CGSize(width: 338, height: 158)
        case .iPhone11ProMax, .iPhone11, .iPhoneXSMax, .iPhoneXR:
            return CGSize(width: 360, height: 169)
        case .iPhone12Mini, .iPhone11Pro, .iPhoneXS, .iPhoneX:
            return CGSize(width: 329, height: 155)
        case .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return CGSize(width: 348, height: 159)
        case .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGSize(width: 322, height: 148)
        case .iPhoneSE, .iPod7:
            return CGSize(width: 291, height: 144)
        default:
            return CGSize(width: 360, height: 169)
        }
    }
}
