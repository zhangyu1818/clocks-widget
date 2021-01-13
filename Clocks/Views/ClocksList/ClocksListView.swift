//
//  ClocksListView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

struct ClocksListView: View {
    @State private var showAlert = false

    var body: some View {
        VStack {
            CurrentClocksView()
            ScrollView {
                ClocksListPreviewView(title: "数字时钟")
            }
            .padding(.vertical)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("确定要删除吗？"),
                message: Text("这将删除所有已保存的组件"),
                primaryButton: .destructive(Text("删除")) {
                    ClockConfigManager.shared.deleteAllConfig()

                    WidgetCenter.shared.reloadAllTimelines()
                },
                secondaryButton: .cancel(Text("取消"))
            )
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
                    Menu {
                        Button("删除已保存的组件") {
                            showAlert = true
                        }
                    }
                    label: {
                        VStack {
                            Image(systemName: "ellipsis.circle")
                            Text("更多")
                                .font(.subheadline)
                        }
                    }
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
