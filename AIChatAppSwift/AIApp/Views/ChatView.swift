import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var showingClearConfirmation = false
    
    init(settings: Settings) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(settings: settings))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message)
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
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.horizontal)
                    } else {
                        Button(action: {
                            Task {
                                await viewModel.sendMessage()
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                        }
                        .disabled(viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Chat")
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