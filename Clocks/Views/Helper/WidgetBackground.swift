//
//  WidgetBackground.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/9.
//

import SwiftUI

struct WidgetBackground: View {
    let uiImage: UIImage?
    let blur: Bool

    var body: some View {
        if let image = uiImage {
            Image(uiImage: image)
                .resizable()
                .padding(.all, blur ? -35 : 0)
                .aspectRatio(contentMode: .fill)
                .blur(radius: blur ? 20.0 : 0)
        }
    }
}
