import Foundation

class ZhipuAIService {
    static let shared = ZhipuAIService()
    private let apiKey = "be1a22e4cf964ac4a1293625181b4516.98AXCRDRWEXvQbLt"
    private let baseURL = "https://open.bigmodel.cn/api/paas/v4/chat/completions"
    private let session = URLSession.shared
    private let timeoutInterval: TimeInterval = 30
    
    private init() {}
    
    // MARK: - 内容检查接口
    func checkContent(name: String, age: String, description: String, completion: @escaping (Bool, String?) -> Void) {
        let prompt = """
        请检查以下宠物信息是否包含粗鲁、色情、低俗的词语：
        
        宠物名字：\(name)
        宠物年龄：\(age)
        宠物描述：\(description)
        
        请只回答"通过"或"不通过"，如果包含不当内容请说明原因。
        """
        
        let requestBody: [String: Any] = [
            "model": "glm-4",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.1,
            "max_tokens": 100,
            "stream": false
        ]
        
        guard let url = URL(string: baseURL) else {
            completion(false, "网络请求失败")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(false, "请求参数错误")
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "网络错误: \(error.localizedDescription)")
                    return
                }
                
                // 检查HTTP状态码
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        completion(false, "服务器错误: HTTP \(httpResponse.statusCode)")
                        return
                    }
                }
                
                guard let data = data else {
                    completion(false, "服务器无响应")
                    return
                }
                
                // 打印响应数据用于调试
                if let responseString = String(data: data, encoding: .utf8) {
                    print("智普API响应: \(responseString)")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let error = json["error"] as? [String: Any] {
                            completion(false, "API错误: \(error["message"] as? String ?? "未知错误")")
                            return
                        }
                        
                        if let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            
                            let response = content.trimmingCharacters(in: .whitespacesAndNewlines)
                            if response.contains("通过") {
                                completion(true, nil)
                            } else {
                                completion(false, response)
                            }
                        } else {
                            completion(false, "服务器响应格式错误")
                        }
                    } else {
                        completion(false, "解析响应失败")
                    }
                } catch {
                    completion(false, "解析响应失败: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // MARK: - AI咨询接口
    func consultQuestion(question: String, completion: @escaping (String?, String?) -> Void) {
        let systemPrompt = """
        你是一位专业的宠物健康顾问，拥有丰富的宠物饲养、健康、训练等方面的知识。
        请以专业、友好、易懂的方式回答用户的问题，提供实用的建议和解决方案。
        回答要简洁明了，避免过于冗长，但要确保信息准确有用。
        """
        
        let requestBody: [String: Any] = [
            "model": "glm-4",
            "messages": [
                [
                    "role": "system",
                    "content": systemPrompt
                ],
                [
                    "role": "user",
                    "content": question
                ]
            ],
            "temperature": 0.7,
            "max_tokens": 1000,
            "stream": false
        ]
        
        guard let url = URL(string: baseURL) else {
            completion(nil, "网络请求失败")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(nil, "请求参数错误")
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, "网络错误: \(error.localizedDescription)")
                    return
                }
                
                // 检查HTTP状态码
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        completion(nil, "服务器错误: HTTP \(httpResponse.statusCode)")
                        return
                    }
                }
                
                guard let data = data else {
                    completion(nil, "服务器无响应")
                    return
                }
                
                // 打印响应数据用于调试
                if let responseString = String(data: data, encoding: .utf8) {
                    print("智普AI咨询响应: \(responseString)")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let error = json["error"] as? [String: Any] {
                            completion(nil, "API错误: \(error["message"] as? String ?? "未知错误")")
                            return
                        }
                        
                        if let choices = json["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            
                            let response = content.trimmingCharacters(in: .whitespacesAndNewlines)
                            completion(response, nil)
                        } else {
                            completion(nil, "服务器响应格式错误")
                        }
                    } else {
                        completion(nil, "解析响应失败")
                    }
                } catch {
                    completion(nil, "解析响应失败: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
} 