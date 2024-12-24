import Foundation
import Combine

protocol StreamingAIService {
    func streamMessage(_ message: String, onReceive: @escaping (String) -> Void) async throws
}

enum StreamingAIServiceType: String, CaseIterable {
    case openAIStream = "OpenAI Stream"
    case deepSeekStream = "DeepSeek Stream"
}

class StreamingOpenAIService: StreamingAIService {
    private let settings: Settings
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func streamMessage(_ message: String, onReceive: @escaping (String) -> Void) async throws {
        guard !settings.openAIKey.isEmpty else {
            throw AIServiceError.noAPIKey
        }
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(settings.openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": message]],
            "stream": true
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (stream, _) = try await URLSession.shared.bytes(for: request)
        
        for try await line in stream.lines {
            guard line.hasPrefix("data: "),
                  let jsonData = line.dropFirst(6).data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let delta = choices.first?["delta"] as? [String: Any],
                  let content = delta["content"] as? String else {
                continue
            }
            
            await MainActor.run {
                onReceive(content)
            }
        }
    }
}

class StreamingDeepSeekService: StreamingAIService {
    private let settings: Settings
    private let baseURL = "https://api.deepseek.com/v1/chat/completions" // Adjust URL as needed
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func streamMessage(_ message: String, onReceive: @escaping (String) -> Void) async throws {
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
            "stream": true
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (stream, _) = try await URLSession.shared.bytes(for: request)
        
        for try await line in stream.lines {
            guard line.hasPrefix("data: "),
                  let jsonData = line.dropFirst(6).data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let delta = choices.first?["delta"] as? [String: Any],
                  let content = delta["content"] as? String else {
                continue
            }
            
            await MainActor.run {
                print(content)
                onReceive(content)
            }
        }
    }
} 
