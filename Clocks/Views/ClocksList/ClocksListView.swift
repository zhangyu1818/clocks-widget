//
//  ClocksListView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

struct ClocksListView: View {
    var body: some View {
        VStack {
            CurrentClocksView()
            ScrollView {
                ClocksListRowView(title: "数字时钟")
            }
            .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    WidgetCenter.shared.reloadAllTimelines()
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
        .navigationBarTitle("小组件列表")
    }
}

struct ClocksListView_Previews: PreviewProvider {
    static var previews: some View {
        ClocksListView()
    }
}
