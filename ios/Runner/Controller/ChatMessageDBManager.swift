import Foundation
import SQLite
import UIKit

struct ChatMessageRecord {
    let msgId: String
    let chatId: String
    let isMe: Bool
    let type: String // "text" or "image"
    let content: String // 文本或图片本地路径
    let timestamp: Int64
}

class ChatMessageDBManager {
    static let shared = ChatMessageDBManager()
    let db: Connection
    let messages: Table
    let msgId: SQLite.Expression<String>
    let chatId: SQLite.Expression<String>
    let isMe: SQLite.Expression<Bool>
    let type: SQLite.Expression<String>
    let content: SQLite.Expression<String>
    let timestamp: SQLite.Expression<Int64>
    
    private init() {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/chat_messages.sqlite3")
        db = try! Connection(dbPath)
        messages = Table("messages")
        msgId = SQLite.Expression<String>("msgId")
        chatId = SQLite.Expression<String>("chatId")
        isMe = SQLite.Expression<Bool>("isMe")
        type = SQLite.Expression<String>("type")
        content = SQLite.Expression<String>("content")
        timestamp = SQLite.Expression<Int64>("timestamp")
        try? db.run(messages.create(ifNotExists: true) { t in
            t.column(msgId, primaryKey: true)
            t.column(chatId)
            t.column(isMe)
            t.column(type)
            t.column(content)
            t.column(timestamp)
        })
    }
    // 插入消息
    func insertMessage(_ record: ChatMessageRecord) {
        let insert = messages.insert(or: .replace,
            msgId <- record.msgId,
            chatId <- record.chatId,
            isMe <- record.isMe,
            type <- record.type,
            content <- record.content,
            timestamp <- record.timestamp
        )
        try? db.run(insert)
    }
    // 查询消息
    func fetchMessages(for chatIdValue: String, limit: Int = 100) -> [ChatMessageRecord] {
        let query = messages.filter(chatId == chatIdValue).order(timestamp.asc).limit(limit)
        var result: [ChatMessageRecord] = []
        for row in try! db.prepare(query) {
            result.append(ChatMessageRecord(
                msgId: row[msgId],
                chatId: row[chatId],
                isMe: row[isMe],
                type: row[type],
                content: row[content],
                timestamp: row[timestamp]
            ))
        }
        return result
    }
    // 删除某个会话所有消息
    func deleteMessages(for chatIdValue: String) {
        let query = messages.filter(chatId == chatIdValue)
        try? db.run(query.delete())
    }
    // 删除单条消息
    func deleteMessage(msgIdValue: String) {
        let query = messages.filter(msgId == msgIdValue)
        try? db.run(query.delete())
    }
} 
