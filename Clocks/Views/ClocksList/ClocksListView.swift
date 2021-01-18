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
                ClocksListPreviewView(title: "数字时钟")
            }
            .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Button(action: {
                        WidgetCenter.shared.reloadAllTimelines()
                    }) {
                        VStack {
                            Image(systemName: "arrow.clockwise.circle")
                            Text("刷新")
                                .font(.subheadline)
                        }
                    }
                    .frame(width: 44, height: 44)
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
