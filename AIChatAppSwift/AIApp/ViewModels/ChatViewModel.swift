import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [] {
        didSet {
            messageStore.saveMessages(messages)
        }
    }
    @Published var newMessage: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let settings: Settings
    private var currentService: AIService {
        switch settings.selectedService {
        case .openAI:
            return OpenAIService(settings: settings)
        case .deepSeek:
            return DeepSeekService(settings: settings)
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
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await currentService.sendMessage(messageToSend)
            let aiMessage = ChatMessage(content: response, isUser: false, timestamp: Date())
            messages.append(aiMessage)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
} 