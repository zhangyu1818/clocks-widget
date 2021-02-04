//
//  ContentView.swift
//  Clocks
//
//  Created by ZhangYu on 2020/12/30.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            WidgetListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
