//
//  WidgetListView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

struct WidgetListView: View {
    var body: some View {
        ScrollView {
            CurrentClocksView()
                .padding(.bottom)

            WidgetListPreviewView(title: "时间") {
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

            Spacer().padding()

            WidgetListPreviewView(title: "图片") {
                NavigationLink(
                    destination: NewDetail(clockName: SimplePicture.clockName),
                    label: {
                        WidgetPreviews(widgetFamily: [.systemMedium]) {
                            SimplePicture(date: Date())
                        }
                    }
                )
            }
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
        WidgetListView()
    }
}
