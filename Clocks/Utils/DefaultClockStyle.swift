//
//  DefaultClockStyle.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/12.
//

import SwiftUI

struct DefaultStyle {
    var textColor: Color
    var backgroundColor: Color
}

let defaultClockStyle = [
    SimpleClockView.clockName: DefaultStyle(textColor: Color(hexString: "#ffffff"), backgroundColor: Color(hexString: "#11698e")),
    SimpleClock1View.clockName: DefaultStyle(textColor: Color(hexString: "#ffffff"), backgroundColor: Color(hexString: "#11698e")),
]
