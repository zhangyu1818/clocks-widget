//
//  ClocksListRowView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI

/**
 新的组件每次需要一个不同的ConfigViewModel，所以得用一个新的View包一下
 */
struct NewDetail: View {
    let clockName: String

    var body: some View {
        ClocksDetailView(config: ClockConfigManager.shared.createConfigViewModel(clockName: clockName)) { detailConfig in
            ClockWidgetBundleView(date: Date(), config: detailConfig)
        }
    }
}

struct ClocksListRowView: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            TabView {
                Group {
                    NavigationLink(
                        destination: NewDetail(clockName: "简单时钟"),
                        label: {
                            WidgetPreviews(widgetFamily: [.systemMedium]) {
                                SimpleClockView(date: Date())
                            }
                        }
                    )
                    NavigationLink(
                        destination: NewDetail(clockName: "简单时钟1"),
                        label: {
                            WidgetPreviews(widgetFamily: [.systemMedium]) {
                                SimpleClock2View(date: Date())
                            }
                        }
                    )
                }
                .padding(.horizontal)
            }
            .frame(height: 169)
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct ClocksListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ClocksListRowView(title: "标题")
    }
}
