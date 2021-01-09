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
                return CGRect(x: 27, y: 76, width: 169, height: 169)
            case .smallTopRight:
                return CGRect(x: 218, y: 76, width: 169, height: 169)
            case .smallCenterLeft:
                return CGRect(x: 27, y: 286, width: 169, height: 169)
            case .smallCenterRight:
                return CGRect(x: 218, y: 286, width: 169, height: 169)
            case .smallBottomLeft:
                return CGRect(x: 27, y: 495.3, width: 169, height: 169)
            case .smallBottomRight:
                return CGRect(x: 218, y: 495.3, width: 169, height: 169)
            case .mediumTop:
                return CGRect(x: 27, y: 76, width: 360, height: 169)
            case .mediumCenter:
                return CGRect(x: 27, y: 286, width: 360, height: 169)
            case .mediumBottom:
                return CGRect(x: 27, y: 495.3, width: 360, height: 169)
            }
        }
    }

    enum EditMaskPosition {
        case top
        case center
        case bottom

        func cropRect(widgetFamily: WidgetFamily) -> CGRect {
            let rectWidth = widgetFamily == .systemSmall ? 169 : 360
            switch self {
            case .top:
                return CGRect(x: 27, y: 76, width: rectWidth, height: 169)
            case .center:
                return CGRect(x: 27, y: 76, width: rectWidth, height: 169)
            case .bottom:
                return CGRect(x: 27, y: 76, width: rectWidth, height: 169)
            }
        }
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
                                TapRectangle("上左", ratio: CGSize(width: 169, height: 169), postion: .smallTopLeft)
                                TapRectangle("上右", ratio: CGSize(width: 169, height: 169), postion: .smallTopRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("上方", ratio: CGSize(width: 360, height: 169), postion: .mediumTop)
                            }
                        }

                        if editMaskPosition == .center {
                            if widgetFamily == .systemSmall {
                                TapRectangle("中左", ratio: CGSize(width: 169, height: 169), postion: .smallCenterLeft)
                                TapRectangle("中右", ratio: CGSize(width: 169, height: 169), postion: .smallCenterRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("中间", ratio: CGSize(width: 360, height: 169), postion: .mediumCenter)
                            }
                        }

                        if editMaskPosition == .bottom {
                            if widgetFamily == .systemSmall {
                                TapRectangle("下左", ratio: CGSize(width: 169, height: 169), postion: .smallBottomLeft)
                                TapRectangle("下右", ratio: CGSize(width: 169, height: 169), postion: .smallBottomRight)
                            }
                            if widgetFamily == .systemMedium {
                                TapRectangle("下方", ratio: CGSize(width: 360, height: 169), postion: .mediumBottom)
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
