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
    enum BackgroundType: String, Identifiable {
        var id: String { rawValue }
        case light
        case dark
    }

    @StateObject private var config: ClockConfigViewModel

    @State private var backgroundType: BackgroundType = .light

    @State private var maskImageToggle: Bool

    // 当前Detail的背景图片和遮罩图片
    @State private var lightBasicImg: UIImage?
    @State private var darkBasicImg: UIImage?

    @State private var lightMaskImg: UIImage?
    @State private var darkMaskImg: UIImage?

    // 控制选择添加图片类型的ActionSheet弹出
    @State private var showImagePicker = false
    // 图片裁剪弹出
    @State private var showCropEditor = false

    private let imagePrefix: String

    // 是否有存在的图片
    private var isBasicImageExist: Bool {
        lightBasicImg != nil || darkBasicImg != nil
    }

    private var isBasicImageAllExist: Bool {
        lightBasicImg != nil && darkBasicImg != nil
    }

    // 是否浅色深色遮罩图都存在
    private var isAllMaskImageExist: Bool {
        lightMaskImg != nil && darkMaskImg != nil
    }

    init(_ config: ClockConfigViewModel) {
        imagePrefix = config.configKey

        _config = StateObject(wrappedValue: config)

        let lightBasicImg = config.lightBasicImgPath != nil ? UIImage(contentsOfFile: config.lightBasicImgPath!) : nil
        let darkBasicImg = config.darkBasicImgPath != nil ? UIImage(contentsOfFile: config.darkBasicImgPath!) : nil

        let lightMaskImg = config.lightMaskImgPath != nil ? UIImage(contentsOfFile: config.lightMaskImgPath!) : nil
        let darkMaskImg = config.darkMaskImgPath != nil ? UIImage(contentsOfFile: config.darkMaskImgPath!) : nil

        _maskImageToggle = State(initialValue: lightMaskImg != nil || darkMaskImg != nil)

        _lightBasicImg = State(initialValue: lightBasicImg)
        _darkBasicImg = State(initialValue: darkBasicImg)

        _lightMaskImg = State(initialValue: lightMaskImg)
        _darkMaskImg = State(initialValue: darkMaskImg)
    }

    private func deleteAllImage() {
        lightBasicImg = nil
        lightMaskImg = nil
        darkBasicImg = nil
        darkMaskImg = nil

        // Todo  删除bug
        config.lightBasicImgPath = nil
        config.lightMaskImgPath = nil
        config.darkBasicImgPath = nil
        config.darkMaskImgPath = nil
        // 删除图片还原图片效果
        config.blur = false
    }

    private func deleteMaskImage() {
        lightMaskImg = nil
        darkMaskImg = nil

        config.lightMaskImgPath = nil
        config.darkMaskImgPath = nil
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
            if isBasicImageExist {
                Button("删除图片") {
                    deleteAllImage()
                }
                .foregroundColor(.red)
            }
        }) {
            VStack {
                Picker("外观", selection: $backgroundType) {
                    Text("浅色外观").tag(BackgroundType.light)
                    Text("深色外观").tag(BackgroundType.dark)
                }
                .pickerStyle(SegmentedPickerStyle())
                Divider()
                ZStack {
                    if !isBasicImageAllExist {
                        Text("\(Image(systemName: "photo")) 点击添加图片")
                            .foregroundColor(.accentColor)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showImagePicker = true
                            }
                    }

                    if backgroundType == .light && lightBasicImg != nil {
                        GeometryReader { geo in
                            Image(uiImage: lightBasicImg!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }

                    if backgroundType == .dark && darkBasicImg != nil {
                        GeometryReader { geo in
                            Image(uiImage: darkBasicImg!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                    Rectangle().fill(Color.clear)
                        .fullScreenCover(isPresented: $showCropEditor) {
                            ClockDetailImageCropView(lightUIImage: lightBasicImg, darkUIImage: darkBasicImg) { lightMaskImg, darkMaskImg in
                                // 保存浅色外观原始图片
                                updateImagPath(lightMaskImg, imageName: "\(imagePrefix)_lightMaskImg") { fileURL in
                                    config.lightMaskImgPath = fileURL.path
                                }
                                // 保存深色外观原始图片
                                updateImagPath(darkMaskImg, imageName: "\(imagePrefix)_darkMaskImg") { fileURL in
                                    config.darkMaskImgPath = fileURL.path
                                }

                                // 如果关闭裁剪窗时候一个都没设置，就要把开关给关了
                                if config.lightMaskImgPath == nil, config.darkMaskImgPath == nil {
                                    maskImageToggle = false
                                }
                            }
                        }
                    Rectangle().fill(Color.clear)
                        // 背景图选择的View
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker { image in
                                if backgroundType == .light {
                                    withAnimation {
                                        lightBasicImg = image
                                    }
                                    // 保存浅色外观原始图片
                                    updateImagPath(lightBasicImg!, imageName: "\(imagePrefix)_lightBasicImg") { fileURL in
                                        config.lightBasicImgPath = fileURL.path
                                    }
                                }
                                if backgroundType == .dark {
                                    withAnimation {
                                        darkBasicImg = image
                                    }
                                    // 保存深色外观原始图片
                                    updateImagPath(darkBasicImg!, imageName: "\(imagePrefix)_darkBasicImg") { fileURL in
                                        config.darkBasicImgPath = fileURL.path
                                    }
                                }
                            }
                        }
                }
                .aspectRatio(2.13, contentMode: .fill)
                .cornerRadius(8.0)
                .clipped()
            }
        }
        if isBasicImageExist {
            Section(header: Text("图片效果")) {
                Toggle(isOn: $config.blur, label: {
                    Text("高斯模糊")
                })

                // 要把image path转换成bool的开关，逻辑绕了
                Toggle(isOn: $maskImageToggle, label: {
                    Text("透明背景")
                })
                    .onTapGesture {
                        // 为false的情况才需要弹出裁剪
                        if !maskImageToggle {
                            showCropEditor = true
                        }
                    }
                    .onChange(of: maskImageToggle, perform: { value in
                        // 值变为false就需要删除所有的mask image
                        if !value {
                            deleteMaskImage()
                        }
                    })
            }
        }
    }
}
