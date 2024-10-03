import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), batteryStatus: "100%")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, batteryStatus: "100%")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, batteryStatus: "100%")
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let batteryStatus: String
}

struct NeueBluetoothWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                // Battery Status (Static)
                    Image(systemName: "battery.100")
                        .imageScale(.large)
                        .fontWeight(.bold)
                    //Text(entry.batteryStatus)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer(minLength: 30)
                
                // Power Button
                Link(destination: URL(string: "yourapp://home")!) {
                    
                    Image(systemName: "togglepower")
                        .imageScale(.large)
                        .fontWeight(.bold)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer(minLength: 30)
            
            HStack {
                // Color Palette Button
                Link(destination: URL(string: "yourapp://pattern")!) {

                    Image(systemName: "paintpalette")
                            .imageScale(.large)
                            .fontWeight(.bold)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer(minLength: 30)

                // Music Note Button
                Link(destination: URL(string: "yourapp://music")!) {
                        
                    Image(systemName: "music.mic.circle")
                            .imageScale(.large)
                            .fontWeight(.bold)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(0) // Ensure there is no corner radius to avoid background showing through rounded corners
    }
}


struct NeueBluetoothWidget: Widget {
    let kind: String = "NeueBluetoothWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NeueBluetoothWidgetEntryView(entry: entry)
                .containerBackground(Color.black, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    NeueBluetoothWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, batteryStatus: "100%")
    SimpleEntry(date: .now, configuration: .starEyes, batteryStatus: "100%")
}
