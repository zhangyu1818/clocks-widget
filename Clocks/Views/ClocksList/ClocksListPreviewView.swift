//
//  ClocksListPreviewView.swift
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

struct ClocksListPreviewView: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 30) {
                NavigationLink(
                    destination: NewDetail(clockName: SimpleClockView.clockName),
                    label: {
                        WidgetPreviews(widgetFamily: [.systemMedium]) {
                            SimpleClockView(date: Date())
                        }
                    }
                )
                NavigationLink(
                    destination: NewDetail(clockName: SimpleClock1View.clockName),
                    label: {
                        WidgetPreviews(widgetFamily: [.systemMedium]) {
                            SimpleClock1View(date: Date())
                        }
                    }
                )
            }
            .padding(.horizontal)
        }
    }
}

struct ClocksListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ClocksListPreviewView(title: "标题")
    }
}
