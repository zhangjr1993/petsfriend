import Foundation
import StoreKit

class IAPManager: NSObject {
    static let shared = IAPManager()
    
    // MARK: - Product Models
    struct ProductInfo {
        let id: String
        let name: String
        let price: Double
        let diamonds: Int?
        let isVip: Bool
        let isFirstCharge: Bool
        
        init(id: String, name: String, price: Double, diamonds: Int? = nil, isVip: Bool = false, isFirstCharge: Bool = false) {
            self.id = id
            self.name = name
            self.price = price
            self.diamonds = diamonds
            self.isVip = isVip
            self.isFirstCharge = isFirstCharge
        }
    }
    
    // MARK: - Properties
    private var products: [SKProduct] = []
    private var productsRequest: SKProductsRequest?
    
    // 本地产品配置
    private let localProducts: [ProductInfo] = [
        ProductInfo(id: "com.huanyou.chungs60", name: "60钻石", price: 6.0, diamonds: 60),
        ProductInfo(id: "com.huanyou.chungs300", name: "300钻石", price: 28.0, diamonds: 300),
        ProductInfo(id: "com.huanyou.chungs1130", name: "1130钻石", price: 98.0, diamonds: 1130),
        ProductInfo(id: "com.huanyou.chungs2350", name: "2350钻石", price: 198.0, diamonds: 2350),
        ProductInfo(id: "com.huanyou.chungs3070", name: "3070钻石", price: 268.0, diamonds: 3070),
        ProductInfo(id: "com.huanyou.chungs3600", name: "3600钻石", price: 298.0, diamonds: 3600),
        ProductInfo(id: "com.huanyou.chungs0", name: "月会员，首充", price: 88.0, isVip: true, isFirstCharge: true),
        ProductInfo(id: "com.huanyou.chungs1", name: "月会员", price: 98.0, isVip: true),
        ProductInfo(id: "com.huanyou.chungs2", name: "季会员", price: 268.0, isVip: true)
    ]
    
    // MARK: - Callbacks
    var onProductsLoaded: (([SKProduct]) -> Void)?
    var onPurchaseSuccess: ((ProductInfo) -> Void)?
    var onPurchaseFailed: ((Error) -> Void)?
    var onRestoreSuccess: (() -> Void)?
    var onRestoreFailed: ((Error) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    func requestProducts() {
        let productIds = Set(localProducts.map { $0.id })
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchaseProduct(_ product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            onPurchaseFailed?(NSError(domain: "IAP", code: -1, userInfo: [NSLocalizedDescriptionKey: "设备不支持内购"]))
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func purchaseProduct(withId productId: String) {
        guard let product = products.first(where: { $0.productIdentifier == productId }) else {
            onPurchaseFailed?(NSError(domain: "IAP", code: -2, userInfo: [NSLocalizedDescriptionKey: "产品不存在"]))
            return
        }
        
        purchaseProduct(product)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getLocalProductInfo(for productId: String) -> ProductInfo? {
        return localProducts.first { $0.id == productId }
    }
    
    func getAllLocalProducts() -> [ProductInfo] {
        return localProducts
    }
    
    // MARK: - Private Methods
    private func handlePurchaseSuccess(_ transaction: SKPaymentTransaction) {
        let productId = transaction.payment.productIdentifier
        
        guard let productInfo = getLocalProductInfo(for: productId) else {
            onPurchaseFailed?(NSError(domain: "IAP", code: -3, userInfo: [NSLocalizedDescriptionKey: "产品信息不存在"]))
            return
        }
        
        // 处理购买成功逻辑
        if let diamonds = productInfo.diamonds {
            UserManager.shared.addDiamonds(diamonds)
        }
        
        if productInfo.isVip {
            UserManager.shared.setVipStatus(true)
        }
        
        // 完成交易
        SKPaymentQueue.default().finishTransaction(transaction)
        
        // 回调成功
        onPurchaseSuccess?(productInfo)
    }
    
    private func handlePurchaseFailed(_ transaction: SKPaymentTransaction) {
        let error = transaction.error ?? NSError(domain: "IAP", code: -4, userInfo: [NSLocalizedDescriptionKey: "购买失败"])
        onPurchaseFailed?(error)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        
        DispatchQueue.main.async {
            self.onProductsLoaded?(self.products)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.onPurchaseFailed?(error)
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchaseSuccess(transaction)
            case .failed:
                handlePurchaseFailed(transaction)
            case .restored:
                // 处理恢复购买
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.onRestoreSuccess?()
                }
            case .deferred:
                // 等待外部操作（如家长同意）
                break
            case .purchasing:
                // 购买中
                break
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.onRestoreSuccess?()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            self.onRestoreFailed?(error)
        }
    }
} 
