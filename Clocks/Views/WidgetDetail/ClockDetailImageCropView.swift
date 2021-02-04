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
    @State private var editMaskPosition: EditMaskPosition = .top
    @State private var widgetFamily: WidgetFamily = .systemSmall

    let lightUIImage: UIImage
    let darkUIImage: UIImage
    let onMaskImageCrop: ((UIImage, UIImage)) -> Void

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

    enum EditMaskPosition {
        case top
        case center
        case bottom
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                Picker("组件大小", selection: $widgetFamily) {
                    Text("小组件").tag(WidgetFamily.systemSmall)
                    Text("中组件").tag(WidgetFamily.systemMedium)
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                HStack(spacing: 12) {
                    Group {
                        if editMaskPosition == .top {
                            if widgetFamily == .systemSmall {
                                TapRectangle("上左", ratio: DeviceWidgetSize.small, postion: .smallTopLeft)
                                TapRectangle("上右", ratio: DeviceWidgetSize.small, postion: .smallTopRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("上方", ratio: DeviceWidgetSize.meduim, postion: .mediumTop)
                            }
                        }

                        if editMaskPosition == .center {
                            if widgetFamily == .systemSmall {
                                TapRectangle("中左", ratio: DeviceWidgetSize.small, postion: .smallCenterLeft)
                                TapRectangle("中右", ratio: DeviceWidgetSize.small, postion: .smallCenterRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("中间", ratio: DeviceWidgetSize.meduim, postion: .mediumCenter)
                            }
                        }

                        if editMaskPosition == .bottom {
                            if widgetFamily == .systemSmall {
                                TapRectangle("下左", ratio: DeviceWidgetSize.small, postion: .smallBottomLeft)
                                TapRectangle("下右", ratio: DeviceWidgetSize.small, postion: .smallBottomRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("下方", ratio: DeviceWidgetSize.meduim, postion: .mediumBottom)
                            }
                        }
                    }
                }
                HStack {
                    Text("上方").onTapGesture { withAnimation { editMaskPosition = .top } }
                        .foregroundColor(editMaskPosition == .top ? .accentColor : .secondary)
                    Divider().frame(height: 12)
                    Text("中间").onTapGesture { withAnimation { editMaskPosition = .center }}
                        .foregroundColor(editMaskPosition == .center ? .accentColor : .secondary)
                    Divider().frame(height: 12)
                    Text("下方").onTapGesture { withAnimation { editMaskPosition = .bottom }}
                        .foregroundColor(editMaskPosition == .bottom ? .accentColor : .secondary)
                }
                .padding(.vertical, 6)
                .font(.subheadline)
            }
            .padding(12)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    @ViewBuilder
    func TapRectangle(_ positionName: String, ratio: CGSize, postion: WidgetCropPostion) -> some View {
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
                guard let croppedLightBgImg = cropImage(lightUIImage, toRect: postion.getRect()) else { return }
                guard let croppedDarkBgImg = cropImage(darkUIImage, toRect: postion.getRect()) else { return }

                onMaskImageCrop((croppedLightBgImg, croppedDarkBgImg))
            }
    }
}
