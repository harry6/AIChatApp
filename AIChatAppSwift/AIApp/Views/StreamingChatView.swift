import SwiftUI

struct StreamingChatView: View {
    @StateObject private var viewModel: StreamingChatViewModel
    @State private var showingClearConfirmation = false
    
    init(settings: Settings) {
        _viewModel = StateObject(wrappedValue: StreamingChatViewModel(settings: settings))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message)
                            .overlay(
                                viewModel.isStreaming && message == viewModel.messages.last && !message.isUser ?
                                ProgressView()
                                    .scaleEffect(0.5)
                                    .padding(.trailing)
                                : nil,
                                alignment: .trailing
                            )
                    }
                    .onDelete(perform: viewModel.deleteMessage)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                HStack {
                    TextField("Type a message...", text: $viewModel.newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        Task {
                            await viewModel.sendMessage()
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(viewModel.isStreaming || 
                            viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
            .navigationTitle("AI Chat (Streaming)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingClearConfirmation = true
                    }) {
                        Image(systemName: "trash")
                    }
                    .disabled(viewModel.messages.isEmpty)
                }
            }
            .alert("Clear All Messages", isPresented: $showingClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    viewModel.clearAllMessages()
                }
            } message: {
                Text("Are you sure you want to clear all messages? This action cannot be undone.")
            }
        }
    }
} 
