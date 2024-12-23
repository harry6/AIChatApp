import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    @State private var showCopiedAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(15)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = message.content
                            showCopiedAlert = true
                        }) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                
                Text(dateFormatter.string(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .alert("Copied to clipboard", isPresented: $showCopiedAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}