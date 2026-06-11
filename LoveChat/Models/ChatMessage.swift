import SwiftUI
import UIKit

struct ChatMessage: Identifiable {
    enum Sender {
        case me
        case partner
    }

    enum Content {
        case text(String)
        case image(UIImage)
        case voice(duration: TimeInterval)
    }

    let id: UUID
    let sender: Sender
    let content: Content
    let timestamp: Date

    var isMine: Bool {
        sender == .me
    }

    init(id: UUID = UUID(), sender: Sender, content: Content, timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
    }
}

extension ChatMessage {
    static let previewMessages: [ChatMessage] = [
        ChatMessage(sender: .partner, content: .text("今天也想和你聊天～"), timestamp: .now.addingTimeInterval(-800)),
        ChatMessage(sender: .me, content: .text("我也是，等下发你一张照片。"), timestamp: .now.addingTimeInterval(-720)),
        ChatMessage(sender: .partner, content: .voice(duration: 8), timestamp: .now.addingTimeInterval(-640)),
        ChatMessage(sender: .me, content: .text("语音收到啦，声音好温柔。"), timestamp: .now.addingTimeInterval(-520))
    ]
}
