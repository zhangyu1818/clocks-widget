//
//  UIDevice.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/11.
//

import SwiftUI

extension UIDevice {
    enum Model: String {
        // Simulator
        case simulator = "simulator/sandbox",

             // iPod
             iPod7 = "iPod 7",

             // iPhone
             iPhone6S = "iPhone 6S",
             iPhone6SPlus = "iPhone 6S Plus",
             iPhoneSE = "iPhone SE",
             iPhone7 = "iPhone 7",
             iPhone7Plus = "iPhone 7 Plus",
             iPhone8 = "iPhone 8",
             iPhone8Plus = "iPhone 8 Plus",
             iPhoneX = "iPhone X",
             iPhoneXS = "iPhone XS",
             iPhoneXSMax = "iPhone XS Max",
             iPhoneXR = "iPhone XR",
             iPhone11 = "iPhone 11",
             iPhone11Pro = "iPhone 11 Pro",
             iPhone11ProMax = "iPhone 11 Pro Max",
             iPhoneSE2 = "iPhone SE 2nd gen",
             iPhone12Mini = "iPhone 12 Mini",
             iPhone12 = "iPhone 12",
             iPhone12Pro = "iPhone 12 Pro",
             iPhone12ProMax = "iPhone 12 Pro Max",

             unrecognized = "?unrecognized?"
    }

    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }

        let modelMap: [String: Model] = [
            // Simulator
            "i386": .simulator,
            "x86_64": .simulator,

            // iPod
            "iPod9,1": .iPod7,

            // iPhone
            "iPhone8,1": .iPhone6S,
            "iPhone8,2": .iPhone6SPlus,
            "iPhone8,4": .iPhoneSE,
            "iPhone9,1": .iPhone7,
            "iPhone9,3": .iPhone7,
            "iPhone9,2": .iPhone7Plus,
            "iPhone9,4": .iPhone7Plus,
            "iPhone10,1": .iPhone8,
            "iPhone10,4": .iPhone8,
            "iPhone10,2": .iPhone8Plus,
            "iPhone10,5": .iPhone8Plus,
            "iPhone10,3": .iPhoneX,
            "iPhone10,6": .iPhoneX,
            "iPhone11,2": .iPhoneXS,
            "iPhone11,4": .iPhoneXSMax,
            "iPhone11,6": .iPhoneXSMax,
            "iPhone11,8": .iPhoneXR,
            "iPhone12,1": .iPhone11,
            "iPhone12,3": .iPhone11Pro,
            "iPhone12,5": .iPhone11ProMax,
            "iPhone12,8": .iPhoneSE2,
            "iPhone13,1": .iPhone12Mini,
            "iPhone13,2": .iPhone12,
            "iPhone13,3": .iPhone12Pro,
            "iPhone13,4": .iPhone12ProMax,
        ]

        if let model = modelMap[String(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
