//
//  ClocksWidget.swift
//  ClocksWidget
//
//  Created by ZhangYu on 2020/12/30.
//

import SwiftUI
import WidgetKit

func getEntries(widgetKey: String?) -> ([WidgetEntry], Date) {
    let times = 15

    let currentDate = Date()

    let updatesDate = Calendar.current.date(byAdding: .minute, value: times, to: currentDate)!

    var config = WidgetClockConfig.createEmpty()

    if widgetKey != nil {
        config = getWidgetConfig(widgetKey!, defaultValue: config) { config in
            WidgetClockConfig(fromStorableConfig: config)
        }
    }

    var entries = [WidgetEntry]()

    for offset in 0 ..< 60 * times {
        let entryDate = Calendar.current.date(byAdding: .second, value: offset, to: currentDate)!
        entries.append(WidgetEntry(date: entryDate, config: config))
    }

    return (entries, updatesDate)
}

struct Provider: IntentTimelineProvider {
    func placeholder(in _: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }

    func getSnapshot(for _: ClocksWidgetIntent, in _: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ClocksWidgetIntent, in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentWidgetKey = configuration.currentWidget?.identifier

        let (entries, updatesDate) = getEntries(widgetKey: currentWidgetKey)

        print("entries length:\(entries.count),updates date:\(DateFormatter.timeFormatter("yyyy-MM-dd HH:mm:ss").string(from: updatesDate))")

        let timeline = Timeline(entries: entries, policy: .after(updatesDate))
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let config: WidgetClockConfig?
    init(date: Date, config: WidgetClockConfig? = nil) {
        self.date = date
        self.config = config
    }
}

struct ClocksWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        WidgetFamilyProvider {
            if let config = entry.config {
                SimpleClockView(date: entry.date, config: config)
            } else {
                SimpleClockView(date: entry.date)
            }
        }
    }
}

@main
struct ClocksWidget: Widget {
    let kind: String = "ClocksWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ClocksWidgetIntent.self, provider: Provider()) { entry in
            ClocksWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ClocksWidget_Previews: PreviewProvider {
    static var previews: some View {
        ClocksWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        ClocksWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
