//
//  WidgetListPreviewView.swift
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

struct WidgetListPreviewView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 30) {
                self.content
            }
            .padding(.horizontal)
        }
    }
}

struct ClocksListRowView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetListPreviewView(title: "标题") {}
    }
}
