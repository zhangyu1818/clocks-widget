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

    @State private var showAlert = false

    let clockContent: (WidgetClockConfig) -> Content
    let clockName: String

    init(config: ClockConfigViewModel, @ViewBuilder content: @escaping (WidgetClockConfig) -> Content) {
        clockContent = content

        clockName = config.clockName

        _config = StateObject(wrappedValue: config)
    }

    private func configable(_ fieldName: String) -> Bool {
        !config.nonConfigurableFields.contains(fieldName)
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
                    if configable(WidgetDetailConfigFields.textColor) {
                        ColorPicker("字体色", selection: $config.textColor, supportsOpacity: false)
                    }
                    if configable(WidgetDetailConfigFields.backgroundColor) {
                        ColorPicker("背景色", selection: $config.backgroundColor, supportsOpacity: false)
                    }
                    if configable(WidgetDetailConfigFields.is12Hour) {
                        Toggle(isOn: $config.is12Hour) {
                            Text("12小时制")
                        }
                    }
                    if configable(WidgetDetailConfigFields.showDateInfo) {
                        Toggle(isOn: $config.showDateInfo) {
                            Text("显示日期")
                        }
                    }
                }

                if configable(WidgetDetailConfigFields.backgroundImage) {
                    ClockDetailImageEditView(config)
                }

                if !config.isNewConfig {
                    Section {
                        GeometryReader { geo in
                            Button("删除小组件") { showAlert = true }
                                .frame(width: geo.size.width, height: geo.size.height)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("确定要删除吗？"),
                primaryButton: .destructive(Text("删除")) {
                    ClockConfigManager.shared.deleteConfig(config: config)

                    presentationMode.wrappedValue.dismiss()

                    WidgetCenter.shared.reloadAllTimelines()
                },
                secondaryButton: .cancel(Text("取消"))
            )
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(config.isNewConfig ? "添加小组件" : "保存") {
                    ClockConfigManager.shared.updateConfig(newConfig: config)

                    presentationMode.wrappedValue.dismiss()

                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        .navigationBarTitle(clockName, displayMode: .inline)
    }
}

struct ClocksDetail_Previews: PreviewProvider {
    static var previews: some View {
        ClocksDetailView(config: ClockConfigManager.shared.createConfigViewModel(clockName: "简单时钟")) { _ in
            SimpleClockView(date: Date())
        }
    }
}
