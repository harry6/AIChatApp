import Foundation

@MainActor
class StreamingChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [] {
        didSet {
            messageStore.saveMessages(messages)
        }
    }
    @Published var newMessage: String = ""
    @Published var isStreaming = false
    @Published var errorMessage: String?
    
    private let settings: Settings
    private var currentService: StreamingAIService {
        switch settings.selectedService {
        case .openAI:
            return StreamingOpenAIService(settings: settings)
        case .deepSeek:
            return StreamingDeepSeekService(settings: settings)
        }
    }
    private let messageStore = MessageStore()
    
    init(settings: Settings) {
        self.settings = settings
        self.messages = messageStore.loadMessages()
    }
    
    func deleteMessage(at indexSet: IndexSet) {
        messages.remove(atOffsets: indexSet)
    }
    
    func clearAllMessages() {
        messages.removeAll()
    }
    
    func sendMessage() async {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: newMessage, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        let messageToSend = newMessage
        newMessage = ""
        
        isStreaming = true
        errorMessage = nil
        
        // Create an initial AI message that will be updated
        var aiMessage = ChatMessage(content: "", isUser: false, timestamp: Date())
        messages.append(aiMessage)
        
        do {
            try await currentService.streamMessage(messageToSend) { chunk in
                if let lastIndex = self.messages.indices.last {
                    self.messages[lastIndex].content += chunk
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isStreaming = false
    }
} 