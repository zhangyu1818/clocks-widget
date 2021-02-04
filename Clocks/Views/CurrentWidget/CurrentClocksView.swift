//
//  CurrentClocksView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/9.
//

import SwiftUI

struct CurrentClocksView: View {
    @StateObject private var widgetConfigs = ConfigKeysViewModel.shared

    var body: some View {
        if !widgetConfigs.configKeys.isEmpty {
            VStack {
                HStack {
                    Text("保存的小组件").font(.headline)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0 ..< widgetConfigs.configKeys.count, id: \.self) { index in
                            let key = widgetConfigs.configKeys[index]
                            CurrentClockPreview(key: key)
                        }
                    }
                    .frame(height: 220)
                }

                Divider()
            }
            .padding(.horizontal)
        }
    }
}

struct CurrentClocksView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentClocksView()
    }
}
