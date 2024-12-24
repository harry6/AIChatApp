import Foundation

class Settings: ObservableObject {
    private let keychainHelper = KeychainHelper.standard
    private let openAIKeyService = "com.TEST.AIApp.openai"
    private let deepSeekKeyService = "com.TEST.AIApp.deepseek"
    private let accountName = "apikey"
    
    @Published var selectedService: AIServiceType {
        didSet {
            UserDefaults.standard.set(selectedService.rawValue, forKey: "selectedService")
        }
    }
    
    @Published var openAIKey: String {
        didSet {
            try? keychainHelper.save(openAIKey.data(using: .utf8) ?? Data(),
                                   service: openAIKeyService,
                                   account: accountName)
        }
    }
    
    @Published var deepSeekKey: String {
        didSet {
            try? keychainHelper.save(deepSeekKey.data(using: .utf8) ?? Data(),
                                   service: deepSeekKeyService,
                                   account: accountName)
        }
    }
    
    init() {
        self.selectedService = AIServiceType(rawValue: UserDefaults.standard.string(forKey: "selectedService") ?? "") ?? .openAI
        
        // Load API keys from Keychain
        if let openAIData = keychainHelper.read(service: openAIKeyService, account: accountName),
           let openAIString = String(data: openAIData, encoding: .utf8) {
            self.openAIKey = openAIString
        } else {
            self.openAIKey = ""
        }
        
        if let deepSeekData = keychainHelper.read(service: deepSeekKeyService, account: accountName),
           let deepSeekString = String(data: deepSeekData, encoding: .utf8) {
            self.deepSeekKey = deepSeekString
        } else {
            self.deepSeekKey = ""
        }
    }
}
