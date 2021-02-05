//
//  ClockDetailImageCropView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/8.
//

/**
 iphone 11 prox max 宽414，小组件横间距22，屏幕边距27，上小组件上边距76
 小
 左上 CGRect(x: 27, y: 76, width: 169, height: 169)
 右上 CGRect(x: 218, y: 76, width: 169, height: 169)
 左中 CGRect(x: 27, y: 286, width: 169, height: 169)
 右中 CGRect(x: 218, y: 286, width: 169, height: 169)
 左下 CGRect(x: 27, y: 495.3, width: 169, height: 169)
 右下 CGRect(x: 218, y: 495.3, width: 169, height: 169)
 */

import SwiftUI
import WidgetKit

struct ClockDetailImageCropView: View {
    @Environment(\.presentationMode) private var presentationMode

    @State private var widgetFamily: WidgetFamily = .systemSmall

    let lightUIImage: UIImage?
    let darkUIImage: UIImage?
    let onMaskImageCrop: ((UIImage?, UIImage?)) -> Void

    enum WidgetCropPostion {
        case smallTopLeft
        case smallTopRight
        case smallCenterLeft
        case smallCenterRight
        case smallBottomLeft
        case smallBottomRight

        case mediumTop
        case mediumCenter
        case mediumBottom

        func getRect() -> CGRect {
            switch self {
            case .smallTopLeft:
                return CGRect(origin: DeviceWidgetPosition.smallTopLeft, size: DeviceWidgetSize.small)
            case .smallTopRight:
                return CGRect(origin: DeviceWidgetPosition.smallTopRight, size: DeviceWidgetSize.small)
            case .smallCenterLeft:
                return CGRect(origin: DeviceWidgetPosition.smallCenterLeft, size: DeviceWidgetSize.small)
            case .smallCenterRight:
                return CGRect(origin: DeviceWidgetPosition.smallCenterRight, size: DeviceWidgetSize.small)
            case .smallBottomLeft:
                return CGRect(origin: DeviceWidgetPosition.smallBottomLeft, size: DeviceWidgetSize.small)
            case .smallBottomRight:
                return CGRect(origin: DeviceWidgetPosition.smallBottomRight, size: DeviceWidgetSize.small)
            case .mediumTop:
                return CGRect(origin: DeviceWidgetPosition.mediumTop, size: DeviceWidgetSize.meduim)
            case .mediumCenter:
                return CGRect(origin: DeviceWidgetPosition.mediumCenter, size: DeviceWidgetSize.meduim)
            case .mediumBottom:
                return CGRect(origin: DeviceWidgetPosition.mediumBottom, size: DeviceWidgetSize.meduim)
            }
        }
    }

    var body: some View {
        ZStack {
            if lightUIImage != nil || darkUIImage != nil {
                Image(uiImage: lightUIImage ?? darkUIImage!)
                    .resizable()
            }

            if widgetFamily == .systemSmall {
                TapRectangle("上左", ratio: DeviceWidgetSize.small, postion: .smallTopLeft)
                TapRectangle("上右", ratio: DeviceWidgetSize.small, postion: .smallTopRight)
                TapRectangle("中左", ratio: DeviceWidgetSize.small, postion: .smallCenterLeft)
                TapRectangle("中右", ratio: DeviceWidgetSize.small, postion: .smallCenterRight)
                // iphone se 都不显示6个
                if UIDevice().type != .iPhoneSE {
                    TapRectangle("下左", ratio: DeviceWidgetSize.small, postion: .smallBottomLeft)
                    TapRectangle("下右", ratio: DeviceWidgetSize.small, postion: .smallBottomRight)
                }
            }
            if widgetFamily == .systemMedium {
                TapRectangle("上方", ratio: DeviceWidgetSize.meduim, postion: .mediumTop)
                TapRectangle("中间", ratio: DeviceWidgetSize.meduim, postion: .mediumCenter)
                if UIDevice().type != .iPhoneSE {
                    TapRectangle("下方", ratio: DeviceWidgetSize.meduim, postion: .mediumBottom)
                }
            }

            VStack {
                Spacer()
                VStack {
                    Text("小组件会呈现对应区域的透明效果")
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                    Picker("组件大小", selection: $widgetFamily) {
                        Text("小组件").tag(WidgetFamily.systemSmall)
                        Text("中组件").tag(WidgetFamily.systemMedium)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Button("返回") {
                        onMaskImageCrop((nil, nil))
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    .font(.subheadline)
                }
                .padding()
                .background(Color.tertiarySystemGroupedBackground)
                .cornerRadius(16.0)
                .padding(24)
            }
        }
        .ignoresSafeArea(.all)
        .navigationTitle("设置透明背景")
    }

    @ViewBuilder
    func TapRectangle(_ positionName: String, ratio: CGSize, postion: WidgetCropPostion) -> some View {
        let ox = postion.getRect().origin.x
        let oy = postion.getRect().origin.y
        let width = postion.getRect().width
        let height = postion.getRect().height
        Rectangle()
            .fill(Color.tertiarySystemGroupedBackground)
            .overlay(
                ZStack {
                    Text("\(Image(systemName: "paintbrush")) 点击设置\(positionName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            )
            .aspectRatio(ratio, contentMode: .fit)
            .cornerRadius(16)
            .onTapGesture {
                let croppedLightBgImg = lightUIImage != nil ? cropImage(lightUIImage!, toRect: postion.getRect()) : nil
                let croppedDarkBgImg = darkUIImage != nil ? cropImage(darkUIImage!, toRect: postion.getRect()) : nil

                onMaskImageCrop((croppedLightBgImg, croppedDarkBgImg))

                presentationMode.wrappedValue.dismiss()
            }
            .frame(width: width, height: height)
            .position(x: ox + width / 2, y: oy + height / 2)
    }
}
