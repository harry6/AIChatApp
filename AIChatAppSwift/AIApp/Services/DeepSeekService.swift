import Foundation

class DeepSeekService: AIService {
    private let settings: Settings
    private let baseURL = "https://api.deepseek.com/chat/completions"
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func sendMessage(_ message: String) async throws -> String {
        guard !settings.deepSeekKey.isEmpty else {
            throw AIServiceError.noAPIKey
        }
        
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(settings.deepSeekKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "user", "content": message]
            ],
            "stream": false
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data) // DeepSeek uses OpenAI-compatible format
        
        return response.choices.first?.message.content ?? "No response"
    }
}