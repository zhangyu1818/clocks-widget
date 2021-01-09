//
//  ClockDetailImageEditView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/7.
//

import SwiftUI

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

    @StateObject private var config: ClockConfigViewModel

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

    init(_ config: ClockConfigViewModel) {
        _config = StateObject(wrappedValue: config)

        let backgroundImg = config.backgroundImgPath != nil ? UIImage(contentsOfFile: config.backgroundImgPath!) : nil
        let lightMaskBasicImg = config.lightMaskBasicImgPath != nil ? UIImage(contentsOfFile: config.lightMaskBasicImgPath!) : nil
        let darkMaskBasicImg = config.darkMaskBasicImgPath != nil ? UIImage(contentsOfFile: config.darkMaskBasicImgPath!) : nil

        _backgroundUIImage = State(initialValue: backgroundImg)
        _lightUIImage = State(initialValue: lightMaskBasicImg)
        _darkUIImage = State(initialValue: darkMaskBasicImg)

        if lightMaskBasicImg != nil, darkMaskBasicImg != nil {
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

    // 把图片存到本地
    private func updateImagPath(_ image: UIImage?, imageName: String, onCompleted: @escaping (URL) -> Void) {
        if let image = image {
            saveImage(imageName: imageName, image: image, onCompleted: onCompleted)
        }
    }

    var body: some View {
        Section(header: HStack {
            Text("背景图片")
            Spacer()
            if isExistImage {
                Button("删除图片") {
                    deleteAllImage()

                    // Todo  删除bug
                    config.backgroundImgPath = nil
                    config.lightMaskBasicImgPath = nil
                    config.lightMaskImgPath = nil
                    config.darkMaskBasicImgPath = nil
                    config.darkMaskImgPath = nil
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
                    ClockDetailImageCropView(lightUIImage: lightUIImage!, darkUIImage: darkUIImage!) { lightMaskImg, darkMaskImg in
                        // 保存浅色外观原始图片
                        updateImagPath(lightMaskImg, imageName: "\(config.clockName)_lightMaskImg") { fileURL in
                            config.lightMaskImgPath = fileURL.path
                        }
                        // 保存深色外观原始图片
                        updateImagPath(darkMaskImg, imageName: "\(config.clockName)_darkMaskImg") { fileURL in
                            config.darkMaskImgPath = fileURL.path
                        }
                    }

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

                                            // 保存浅色外观原始图片
                                            updateImagPath(lightUIImage!, imageName: "\(config.clockName)_lightMaskBasicImg") { fileURL in
                                                config.lightMaskBasicImgPath = fileURL.path
                                            }
                                            // 保存深色外观原始图片
                                            updateImagPath(darkUIImage!, imageName: "\(config.clockName)_darkMaskBasicImg") { fileURL in
                                                config.darkMaskBasicImgPath = fileURL.path
                                            }
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

                            // 选中后更新图片，保存到本地
                            updateImagPath(image, imageName: "\(config.clockName)_backgroundImg") { fileURL in
                                config.backgroundImgPath = fileURL.path
                            }
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
        if isExistImage {
            Section(header: Text("图片效果")) {
                Toggle(isOn: $config.blur, label: {
                    Text("高斯模糊")
                })
            }
        }
    }
}
