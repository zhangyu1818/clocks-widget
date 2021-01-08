//
//  ClocksDetail.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/31.
//

import SwiftUI
import WidgetKit

struct ClocksDetailView<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode

    @StateObject private var config: ClockConfigViewModel

    let clockContent: (WidgetClockConfig) -> Content
    let clockName: String

    init(_ name: String, @ViewBuilder content: @escaping (WidgetClockConfig) -> Content) {
        clockName = name
        clockContent = content

        // 获取当前小组件的配置信息，clone一份用作本页面的动态展示
        let baseConfig = ClockConfigManager.shared.getConfigViewModel(name).clone()

        _config = StateObject(wrappedValue: baseConfig)
    }

    var body: some View {
        VStack {
            // 小组件展示
            ScrollView(.horizontal, showsIndicators: false) {
                WidgetPreviews {
                    clockContent(config.toWidgetConfig())
                        .shadow(radius: 4)
                }
                .padding()
            }

            // 小组件配置信息
            Form {
                Section(header: Text("基础设置")) {
                    ColorPicker("字体色", selection: $config.textColor, supportsOpacity: false)
                    ColorPicker("背景色", selection: $config.backgroundColor, supportsOpacity: false)
                    Toggle(isOn: $config.is12Hour) {
                        Text("12小时制")
                    }
                }

                ClockDetailImageEditView(
                    onBackgroundImageSelect: { backgroundImg in
                        // 选中后更新图片，保存到本地
                        updateImagPath(backgroundImg, imageName: "\(clockName)_backgroundImg") { fileURL in
                            config.backgroundImgPath = fileURL.path
                        }
                    },
                    onMaskImageSelet: { lightMaskImg, darkMaskImg in
                        // 保存浅色外观原始图片
                        updateImagPath(lightMaskImg, imageName: "\(clockName)_lightMaskBasicImg") { fileURL in
                            config.lightMaskBasicImgPath = fileURL.path
                        }
                        // 保存深色外观原始图片
                        updateImagPath(darkMaskImg, imageName: "\(clockName)_darkMaskBasicImg") { fileURL in
                            config.darkMaskBasicImgPath = fileURL.path
                        }
                    },
                    onMaskImageCrop: { lightMaskImg, darkMaskImg in
                        // 保存浅色外观原始图片
                        updateImagPath(lightMaskImg, imageName: "\(clockName)_lightMaskImg") { fileURL in
                            config.lightMaskImgPath = fileURL.path
                        }
                        // 保存深色外观原始图片
                        updateImagPath(darkMaskImg, imageName: "\(clockName)_darkMaskImg") { fileURL in
                            config.darkMaskImgPath = fileURL.path
                        }
                    },
                    onDelete: {
                        // Todo  删除bug
                        config.backgroundImgPath = nil
                        config.lightMaskBasicImgPath = nil
                        config.lightMaskImgPath = nil
                        config.darkMaskBasicImgPath = nil
                        config.darkMaskImgPath = nil
                    }
                ) {
                    // 传递初始图片
                    let backgroundImg = config.backgroundImgPath != nil ? UIImage(contentsOfFile: config.backgroundImgPath!) : nil
                    let lightMaskBasicImg = config.lightMaskBasicImgPath != nil ? UIImage(contentsOfFile: config.lightMaskBasicImgPath!) : nil
                    let darkMaskBasicImg = config.darkMaskBasicImgPath != nil ? UIImage(contentsOfFile: config.darkMaskBasicImgPath!) : nil

                    return (backgroundImg, lightMaskBasicImg, darkMaskBasicImg)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("完成") {
                    ClockConfigManager.shared.updateConfig(name: clockName, newConfig: config)
                    presentationMode.wrappedValue.dismiss()

                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        .navigationBarTitle(clockName, displayMode: .inline)
    }

    // 把图片存到本地
    func updateImagPath(_ image: UIImage?, imageName: String, onCompleted: @escaping (URL) -> Void) {
        if let image = image {
            saveImage(imageName: imageName, image: image, onCompleted: onCompleted)
        }
    }
}

struct ClocksDetail_Previews: PreviewProvider {
    static var previews: some View {
        ClocksDetailView("SimpleClock") { _ in
            SimpleClockView(date: Date())
        }
    }
}
