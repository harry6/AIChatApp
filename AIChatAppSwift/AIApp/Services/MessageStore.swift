import Foundation

class MessageStore {
    private let key = "savedMessages"
    
    func saveMessages(_ messages: [ChatMessage]) {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadMessages() -> [ChatMessage] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) else {
            return []
        }
        return messages
    }
}