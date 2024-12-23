import Foundation

class Settings: ObservableObject {
    @Published var selectedService: AIServiceType {
        didSet {
            UserDefaults.standard.set(selectedService.rawValue, forKey: "selectedService")
        }
    }
    
    @Published var openAIKey: String {
        didSet {
            UserDefaults.standard.set(openAIKey, forKey: "openAIKey")
        }
    }
    
    @Published var deepSeekKey: String {
        didSet {
            UserDefaults.standard.set(deepSeekKey, forKey: "deepSeekKey")
        }
    }
    
    init() {
        self.selectedService = AIServiceType(rawValue: UserDefaults.standard.string(forKey: "selectedService") ?? "") ?? .openAI
        self.openAIKey = UserDefaults.standard.string(forKey: "openAIKey") ?? ""
        self.deepSeekKey = UserDefaults.standard.string(forKey: "deepSeekKey") ?? ""
    }
}