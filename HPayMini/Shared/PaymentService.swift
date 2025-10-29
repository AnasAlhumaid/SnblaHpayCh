import Foundation
import SwiftUI
import Stripe
import StripePaymentSheet

// MARK: - Payment Protocol (shared between real & mock)
protocol PaymentServiceType {
    func createPaymentIntent(amount: Decimal) async throws -> String
    func presentPaymentSheet(clientSecret: String) async throws
    func createTopUpIntent(userId: Int, amountSar: Decimal) async throws -> String
}

// MARK: - Mock Payment Service (Simulates Stripe Test Mode)
enum PaymentError: LocalizedError {
    case failed
    var errorDescription: String? {
        switch self {
        case .failed: return "Payment failed. Please try again."
        }
    }
}

struct MockPaymentService: PaymentServiceType {
    func createPaymentIntent(amount: Decimal) async throws -> String {
        // Simulate API latency
        try await Task.sleep(for: .seconds(1.2))
        
        // 10% chance to fail randomly (for error state testing)
        if Int.random(in: 1...10) == 1 {
            throw PaymentError.failed
        }
        // Return a fake client secret
        return "mock_client_secret_\(UUID().uuidString.prefix(6))"
    }
    
    func createTopUpIntent(userId: Int, amountSar: Decimal) async throws -> String {
        
        if Int.random(in: 1...10) == 1 {
            throw PaymentError.failed
        }
        return "mock_client_secret_\(UUID().uuidString.prefix(6))"
    }
    
  

    func presentPaymentSheet(clientSecret: String) async throws {
      
                if Int.random(in: 1...10) == 1 {
            throw PaymentError.failed
        }
    }
}

struct StripePaymentService: PaymentServiceType {
    
    
    let baseURL = URL(string: "https://hpaymini-stripe-backend-1.onrender.com")!

    
    
    func createPaymentIntent(amount: Decimal) async throws -> String {
        var req = URLRequest(url: baseURL.appendingPathComponent("create-payment-intent"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert SAR → halalah (×100)
        let halalah = NSDecimalNumber(decimal: amount).intValue * 100
        req.httpBody = try JSONSerialization.data(withJSONObject: ["amount": halalah])

        let (data, _) = try await URLSession.shared.data(for: req)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        return json["clientSecret"] as! String
    }
    
    
    func createTopUpIntent(userId: Int, amountSar: Decimal) async throws -> String {
          var req = URLRequest(url: baseURL.appendingPathComponent("wallet/top-up-intent"))
          req.httpMethod = "POST"
          req.setValue("application/json", forHTTPHeaderField: "Content-Type")
          let sar = (amountSar as NSDecimalNumber).doubleValue
          req.httpBody = try JSONSerialization.data(withJSONObject: [
              "userId": 1,
              "amountSar": sar
          ])
          let (data, _) = try await URLSession.shared.data(for: req)
          let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
          return json["clientSecret"] as! String
      }
    
    
    @MainActor
        func presentPaymentSheet(clientSecret: String) async throws {
            var config = PaymentSheet.Configuration()
            config.merchantDisplayName = "HPay"
            let sheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: config)

            // Use the topMostViewController logic to find the correct view controller
            guard let root = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                .first else { throw NSError(domain: "Stripe", code: 0) }

            // Find the topmost view controller, which may not be the root
            let topMostViewController = Self.topMostViewController(from: root)

            return try await withCheckedThrowingContinuation { cont in
                sheet.present(from: topMostViewController) { result in
                    switch result {
                    case .completed: cont.resume()
                    case .failed(let error): cont.resume(throwing: error)
                    case .canceled:
                        cont.resume(throwing: NSError(domain: "Stripe", code: 1,
                                                      userInfo: [NSLocalizedDescriptionKey: "Canceled"]))
                    }
                }
            }
        }


    private static func topMostViewController(from root: UIViewController?) -> UIViewController {
            if let presented = root?.presentedViewController {
                return topMostViewController(from: presented)
            } else if let nav = root as? UINavigationController {
                return topMostViewController(from: nav.visibleViewController)
            } else if let tab = root as? UITabBarController {
                return topMostViewController(from: tab.selectedViewController)
            } else {
                return root!
            }
        }
}
