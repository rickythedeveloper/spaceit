//
//  SwiftyStoreKitWrapper.swift
//  SwiftStoreKitTest
//
//  Created by Rintaro Kawagishi on 02/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit



enum AccessRight {
    case subscribed
    case expired
    case neverPurchased
    case notClear
}

class SwiftyStoreKitWrapper {
    static let shared = SwiftyStoreKitWrapper()
    
    let sharedSecret = "0c53e21bf5fd438fab5483800df9cafa"
    let monthlySub = "com.rickythedeveloper.spaceit.appaccess"
    let yearlySub = "com.rickythedeveloper.spaceit.yearlysub"
}

// MARK: Retrieve products info
extension SwiftyStoreKitWrapper {
    func retrieveProductsInfo(productIDs: Set<String>, retrieved: @escaping (Set<SKProduct>) -> Void, invalidIDs: @escaping (Set<String>) -> Void, errorHandler: @escaping (Error) -> Void)  {
        SwiftyStoreKit.retrieveProductsInfo(productIDs) { result in
            retrieved(result.retrievedProducts)
            invalidIDs(result.invalidProductIDs)
            if let error = result.error {
                errorHandler(error)
            }
        }
    }
    
//    MARK: Example Handlers
//    private func successRetrievalHandler(products: Set<SKProduct>) {
//        for product in products {
//            self.interpretProduct(product: product)
//        }
//    }
//
//    private func interpretProduct(product: SKProduct) {
//        let title = product.localizedTitle
//        let desc = product.localizedDescription
//        let price = product.localizedPrice ?? "NA"
//
//        if let subscriptionPeriod = product.subscriptionPeriod {
//            let unit = subscriptionPeriod.unit
//            let numUnits = String(describing: subscriptionPeriod.numberOfUnits)
//            var period = ""
//            switch unit.rawValue {
//            case 0:
//                period = numUnits + " day(s)"
//                break
//            case 1:
//                period = numUnits + " week(s)"
//                break
//            case 2:
//                period = numUnits + " month(s)"
//                break
//            case 3:
//                period = numUnits + " year(s)"
//                break
//            default:
//                break
//            }
//
//            if let introPrice = product.introductoryPrice {
//                let introPeriodUnit = introPrice.subscriptionPeriod.unit
//                let introNumPeriod = String(describing: introPrice.subscriptionPeriod.numberOfUnits)
//                var introPeriod = ""
//                switch introPeriodUnit.rawValue {
//                case 0:
//                    introPeriod = introNumPeriod + " day(s)"
//                    break
//                case 1:
//                    introPeriod = introNumPeriod + " week(s)"
//                    break
//                case 2:
//                    introPeriod = introNumPeriod + " month(s)"
//                    break
//                case 3:
//                    introPeriod = introNumPeriod + " year(s)"
//                    break
//                default:
//                    break
//                }
//
//                print("Product title: \(title), description: \(desc), price: \(price), Intro Price: \(introPrice.price) for \(introPeriod) and then \(price) every \(period)")
//                return
//            }
//
//            print("Product title: \(title), description: \(desc), price: \(price), Price: \(price) every \(period)")
//        }
//
//        print("Product title: \(title), description: \(desc), price: \(price)")
//    }
//
//    private func invalidIDHandlerForRetrieval(invalidID: String) {
//        print("Invalid product id: \(invalidID)")
//    }
//
//    private func errorHandlerForRetrieval(error: Error) {
//        print("Error retrieving product info: \(error.localizedDescription)")
//    }
}

// MARK: Purchase Product & Purchase Handler & Handler for purchase started on the App Store
extension SwiftyStoreKitWrapper {
    func purchaseProduct(_ productID: String, purchaseHandler: @escaping (PurchaseResult) -> Void) {
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
            purchaseHandler(result)
        }
    }
    
    func purchaseProduct(_ product: SKProduct, purchaseHandler: @escaping (PurchaseResult) -> Void) {
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
            purchaseHandler(result)
        }
    }
    
//    MARK: Example handler
//    private func purchaseHandler(result: PurchaseResult) {
//        switch result {
//        case .success(let purchase):
//            print("Purchase Success: \(purchase.productId)")
//        case .error(let error):
//            switch error.code {
//            case .unknown: print("Unknown error. Please contact support")
//            case .clientInvalid: print("Not allowed to make the payment")
//            case .paymentCancelled: print("Purchase cancelled")
//            case .paymentInvalid: print("The purchase identifier was invalid")
//            case .paymentNotAllowed: print("The device is not allowed to make the payment")
//            case .storeProductNotAvailable: print("The product is not available in the current storefront")
//            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
//            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
//            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
//            default: print((error as NSError).localizedDescription)
//            }
//        }
//    }
}

// MARK: Restore
extension SwiftyStoreKitWrapper {
    func restore(failureHandler: @escaping (RestoreResults) -> Void, successHandler: @escaping (RestoreResults) -> Void, nothingToRestoreHandler: @escaping (RestoreResults) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                failureHandler(results)
            }
            else if results.restoredPurchases.count > 0 {
                successHandler(results)
            }
            else {
                nothingToRestoreHandler(results)
            }
        }
    }
    
//    MARK: Example handlers
//    private func failedRestoreHandler(results: RestoreResults) {
//        print("Restore Failed: \(results.restoreFailedPurchases)")
//    }
//
//    private func successfulRestoreHandler(results: RestoreResults) {
//        print("Restore Success: \(results.restoredPurchases)")
//    }
//
//    private func nothingToRestoreHandler(results: RestoreResults) {
//        print("Nothing to Restore")
//    }
}

// MARK: Receipt fetch and validation -------------------(Change the service here for production!)-------------------
extension SwiftyStoreKitWrapper {
    /// Access receipt or fetch it if necessary, validate the receipt.
    func fetchReceiptAndValidate(successHandler: @escaping (ReceiptInfo) -> Void, failureHandler: @escaping (ReceiptError) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                successHandler(receipt)
            case .error(let error):
                failureHandler(error)
            }
        }
    }
    
//    MARK: Example handlers
//    private func receiptVerificationSuccessHandler(receipt: ReceiptInfo) {
//        print("Verify receipt success: \(receipt)")
//    }
//
//    private func receiptVerificationFailureHandler(error: ReceiptError) {
//        print("Verify receipt failed: \(error)")
//    }
}

// MARK: Subscription Verification
extension SwiftyStoreKitWrapper {
    /// Access receipt or fetch it if necessary, validate the receipt and verify the subscription. The completion block will come out with AccessRight.
    func verifySubscription(productIDs: [String], completion: @escaping (AccessRight) -> Void) {
        /// Success handler for validation when verifying subscription
        func verifySubscriptionUponReceiptValidation(receipt: ReceiptInfo) {
            var purchased = false
            var expired = false
            for productId in productIDs {
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    purchased = true
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    expired = true
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            }
            
            if purchased {
                completion(.subscribed)
            } else if expired {
                completion(.expired)
            } else {
                completion(.neverPurchased)
            }
        }
        
        func receiptValidationFailed(error: ReceiptError) {
            print("Receipt validation failed during subscription vefirication: \(error.localizedDescription)")
            completion(.notClear)
        }
        
        fetchReceiptAndValidate(successHandler: verifySubscriptionUponReceiptValidation(receipt:), failureHandler: receiptValidationFailed(error:))
    }
}
