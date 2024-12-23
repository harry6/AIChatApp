import Foundation

protocol AIService {
    func sendMessage(_ message: String) async throws -> String
}

enum AIServiceType: String, CaseIterable {
    case openAI = "OpenAI"
    case deepSeek = "DeepSeek"
}

enum AIServiceError: LocalizedError {
    case noAPIKey
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "Please set your API key in Settings"
        }
    }
}