//
//  ClockLinkView.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/4.
//

import SwiftUI

struct ClockLinkView<Content: View>: View {
    @StateObject private var currentClockConfig: ClockConfigViewModel

    private let name: String
    private let clock: (WidgetClockConfig) -> Content

    init(_ name: String, @ViewBuilder clock: @escaping (WidgetClockConfig) -> Content) {
        self.name = name
        self.clock = clock

        _currentClockConfig = StateObject(wrappedValue: ClockConfigManager.shared.getConfigViewModel(name))
    }

    var body: some View {
        NavigationLink(
            destination: ClocksDetailView(name) { config in
                clock(config)
            }
        ) {
            clock(currentClockConfig.toWidgetConfig())
                .cornerRadius(24)
        }
    }
}

struct ClocksLink_Previews: PreviewProvider {
    static var previews: some View {
        ClockLinkView("") { _ in
        }
    }
}
