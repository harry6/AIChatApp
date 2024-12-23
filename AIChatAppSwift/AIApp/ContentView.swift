import SwiftUI

struct ContentView: View {
    @StateObject private var settings = Settings()
    
    var body: some View {
        TabView {
            ChatView(settings: settings)
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            SettingsView(settings: settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
} 