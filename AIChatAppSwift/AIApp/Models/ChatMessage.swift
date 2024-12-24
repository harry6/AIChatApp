import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    var content: String
    let isUser: Bool
    let timestamp: Date
    
    init(content: String, isUser: Bool, timestamp: Date) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
    
    // Implement Equatable
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.content == rhs.content &&
               lhs.isUser == rhs.isUser &&
               lhs.timestamp == rhs.timestamp
    }
}
