//
//  ClockDetailImageEditView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/7.
//

import SwiftUI

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

struct MaskImageSettingView: View {
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

/**
 小组件详情的背景图片添加和删除
 */
struct ClockDetailImageEditView: View {
    // 当前选择的图片类型
    enum ImageType {
        case background
        case mask
    }

    // 遮罩图片的外观
    enum ImageAppearance {
        case light
        case dark
    }

    @State private var imageType: ImageType?
    @State private var imageAppearance: ImageAppearance = .light

    // 当前Detail的背景图片和遮罩图片
    @State private var backgroundUIImage: UIImage?
    @State private var lightUIImage: UIImage?
    @State private var darkUIImage: UIImage?

    // 控制选择添加图片类型的ActionSheet弹出
    @State private var showActionSheet = false

    // 控制背景图片选择的Imagepicker弹出
    @State private var showBackgroundImagePicker = false
    // 控制ImagePicker弹出
    @State private var showMaskImagePicker = false
    // 控制遮罩图片选择的fullScreenCover弹出
    @State private var showScreenCover = false

    // 是否有存在的图片
    private var isExistImage: Bool {
        backgroundUIImage != nil || isAllMaskImageExist
    }

    // 遮罩图选择时显示的图片
    private var maskImage: UIImage? {
        imageAppearance == .light ? lightUIImage : darkUIImage
    }

    // 是否浅色深色遮罩图都存在
    private var isAllMaskImageExist: Bool {
        lightUIImage != nil && darkUIImage != nil
    }

    private var settingAreaRatio: CGSize {
        if imageType == .mask {
            return CGSize(width: 1, height: 0.75)
        }
        return CGSize(width: 360, height: 169)
    }

    // 选中背景图片后事件
    let onBackgroundImageSelect: (UIImage) -> Void
    // 选中遮罩图片后事件
    let onMaskImageSelet: (UIImage, UIImage) -> Void
    // 遮罩图片裁剪事件
    let onMaskImageCrop: (UIImage, UIImage) -> Void
    // 删除图片事件
    let onDelete: () -> Void

    init(
        onBackgroundImageSelect: @escaping (UIImage) -> Void,
        onMaskImageSelet: @escaping (UIImage, UIImage) -> Void,
        onMaskImageCrop: @escaping (UIImage, UIImage) -> Void,
        onDelete: @escaping () -> Void,
        getInitImgs: () -> (UIImage?, UIImage?, UIImage?)
    ) {
        self.onBackgroundImageSelect = onBackgroundImageSelect
        self.onMaskImageSelet = onMaskImageSelet
        self.onMaskImageCrop = onMaskImageCrop
        self.onDelete = onDelete

        let (backgroundImg, lightImg, darkImg) = getInitImgs()

        _backgroundUIImage = State(initialValue: backgroundImg)
        _lightUIImage = State(initialValue: lightImg)
        _darkUIImage = State(initialValue: darkImg)

        if lightImg != nil, darkImg != nil {
            _imageType = State(initialValue: .mask)
        } else if backgroundImg != nil {
            _imageType = State(initialValue: .background)
        }
    }

    private func deleteAllImage() {
        withAnimation {
            backgroundUIImage = nil
            lightUIImage = nil
            darkUIImage = nil
            // 还原操作区大小
            imageType = .background
        }
    }

    var body: some View {
        Section(header: HStack {
            Text("背景图片")
            Spacer()
            if isExistImage {
                Button("删除图片") {
                    deleteAllImage()
                    onDelete()
                }
                .foregroundColor(.red)
            }
        }) {
            ZStack {
                if !isExistImage {
                    Text("\(Image(systemName: "photo")) 点击添加图片")
                        .foregroundColor(.accentColor)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showActionSheet = true
                        }
                        .transition(.scale)
                }

                if imageType == .background && backgroundUIImage != nil {
                    GeometryReader { geo in
                        Image(uiImage: backgroundUIImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .transition(.scale)
                    }
                }

                if imageType == .mask && isAllMaskImageExist {
                    MaskImageSettingView(lightUIImage: lightUIImage!, darkUIImage: darkUIImage!, onMaskImageCrop: onMaskImageCrop)
                        .transition(.scale)
                }

                Rectangle().fill(Color.clear)
                    // 遮罩图选择的View
                    .fullScreenCover(isPresented: $showScreenCover) {
                        GeometryReader { geo in
                            ZStack {
                                VStack {
                                    Text("请先选择当前的壁纸图片")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.secondary)
                                // 展示选中的MaskImage
                                if let uiImage = maskImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .renderingMode(.original)
                                        .aspectRatio(contentMode: .fit)
                                }

                                VStack {
                                    HStack {
                                        Button("取消") {
                                            showScreenCover = false
                                            deleteAllImage()
                                        }
                                        Spacer()
                                        Button("确定") {
                                            imageType = .mask
                                            showScreenCover = false

                                            // 调用传入的选择事件
                                            onMaskImageSelet(lightUIImage!, darkUIImage!)
                                        }
                                        .disabled(!isExistImage)
                                    }
                                    .padding()
                                    Picker("外观", selection: $imageAppearance.animation()) {
                                        Text("浅色外观").tag(ImageAppearance.light)
                                        Text("深色外观").tag(ImageAppearance.dark)
                                    }
                                    .frame(height: 100)
                                    .clipped()
                                    .contentShape(Rectangle())
                                    Button("选择图片") {
                                        showMaskImagePicker = true
                                    }
                                    Spacer()
                                }
                                .frame(height: 220)
                                .background(Color.systemBackground)
                                .position(x: geo.size.width / 2, y: geo.size.height - 110)
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                            .background(Color.secondarySystemBackground)
                            .sheet(isPresented: $showMaskImagePicker) {
                                ImagePicker { image in
                                    if imageAppearance == .light {
                                        lightUIImage = image
                                    }
                                    if imageAppearance == .dark {
                                        darkUIImage = image
                                    }
                                }
                            }
                        }
                        .ignoresSafeArea(.all)
                    }
                Rectangle().fill(Color.clear)
                    // 背景图选择的View
                    .sheet(isPresented: $showBackgroundImagePicker) {
                        ImagePicker { image in
                            imageType = .background

                            withAnimation {
                                backgroundUIImage = image
                            }

                            onBackgroundImageSelect(image)
                        }
                    }
            }
            .listRowInsets(EdgeInsets())
            .aspectRatio(settingAreaRatio, contentMode: .fit)
        }
        // 选择图片类型
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("请选择背景类型"), buttons: [
                .default(Text("背景图片")) {
                    showBackgroundImagePicker = true
                },
                .default(Text("透明遮罩图片")) {
                    showScreenCover = true
                },
                .cancel(Text("取消")),
            ])
        }
    }
}
