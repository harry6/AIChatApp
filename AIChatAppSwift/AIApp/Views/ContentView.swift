import SwiftUI

struct ContentView: View {
    @StateObject private var settings = Settings()
    
    var body: some View {
        TabView {
            ChatView(settings: settings)
                .tabItem {
                    Label("Standard", systemImage: "message")
                }
            
            StreamingChatView(settings: settings)
                .tabItem {
                    Label("Streaming", systemImage: "message.and.waveform")
                }
            
            SettingsView(settings: settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
} 