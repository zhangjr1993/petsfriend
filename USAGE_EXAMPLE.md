# 智普AI内容审核使用示例

## 基本使用流程

### 1. 用户操作流程

1. **打开添加宠物页面**
   - 进入应用，点击"+"按钮
   - 进入添加宠物页面

2. **填写宠物信息**
   - 上传宠物头像
   - 选择宠物类型（猫/狗）
   - 输入宠物名字（限制10个字符）
   - 输入宠物年龄（限制10个字符）
   - 输入宠物描述（限制1000个字符）
   - 上传相册图片（最多9张）

3. **保存宠物信息**
   - 点击"保存"按钮
   - 系统自动显示"内容审核中..."提示
   - 调用智普AI进行内容审核
   - 根据审核结果：
     - ✅ 通过：显示"保存成功"
     - ❌ 不通过：显示错误提示，阻止保存

### 2. 测试API连接

在开发阶段，可以使用"测试API"按钮验证API连接：

1. 点击"测试API"按钮
2. 系统显示"测试API连接..."提示
3. 调用智普AI进行测试
4. 显示测试结果

## 代码示例

### 内容审核调用

```swift
// 显示HUD
let hud = HUDView()
hud.show(in: view)
hud.updateMessage("内容审核中...")

// 调用智普AI进行内容审核
ZhipuAIService.shared.checkContent(name: nameText, age: ageText, description: descText) { [weak self] isPassed, errorMessage in
    DispatchQueue.main.async {
        hud.hide()
        
        if isPassed {
            // 审核通过，继续保存流程
            self?.savePetData(avatarData: avatarData, type: type)
        } else {
            // 审核不通过，显示错误提示
            let alert = UIAlertController(title: "内容审核未通过", message: errorMessage ?? "内容包含不当信息", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
```

### HUD使用

```swift
// 创建并显示HUD
let hud = HUDView()
hud.show(in: view)

// 更新提示信息
hud.updateMessage("处理中...")

// 隐藏HUD
hud.hide()
```

## 审核规则

智普AI会根据以下内容进行审核：

1. **宠物名字**：检查是否包含不当词语
2. **宠物年龄**：检查是否包含不当词语
3. **宠物描述**：检查是否包含粗鲁、色情、低俗等不当内容

## 错误处理

系统会处理以下类型的错误：

- 网络连接错误
- API认证错误
- 服务器错误
- 响应格式错误
- 超时错误

所有错误都会通过用户友好的提示信息显示给用户。

## 性能优化

- 设置了30秒超时时间
- 使用异步处理避免阻塞UI
- 在主线程更新UI
- 包含完整的错误处理机制 