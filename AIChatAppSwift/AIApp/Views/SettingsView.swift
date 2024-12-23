import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: Settings
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("AI Service")) {
                    Picker("Service", selection: $settings.selectedService) {
                        ForEach(AIServiceType.allCases, id: \.self) { service in
                            Text(service.rawValue).tag(service)
                        }
                    }
                }
                
                Section(header: Text("OpenAI Configuration")) {
                    SecureField("OpenAI API Key", text: $settings.openAIKey)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .disabled(settings.selectedService != .openAI)
                }
                
                Section(header: Text("DeepSeek Configuration")) {
                    SecureField("DeepSeek API Key", text: $settings.deepSeekKey)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .disabled(settings.selectedService != .deepSeek)
                }
                
                Section(header: Text("About")) {
                    Text("This app supports both OpenAI and DeepSeek AI services.")
                }
            }
            .navigationTitle("Settings")
        }
    }
}