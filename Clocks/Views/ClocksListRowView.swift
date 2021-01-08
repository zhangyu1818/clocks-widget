//
//  ClocksListRowView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI

struct ClocksListRowView: View {
    @StateObject var temp = ClockConfigManager.shared.getConfigViewModel("简单时钟")

    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            TabView {
                Group {
                    ClockLinkView("简单时钟") { config in
                        SimpleClockView(date: Date(), config: config)
                    }
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
