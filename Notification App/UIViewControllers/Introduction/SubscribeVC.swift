//
//  SubscribeVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 02/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import StoreKit

class SubscribeVC: UIViewController {
    
    var products = [SKProduct]()
    let sskr = SwiftyStoreKitWrapper.shared
    
    let sub1 = SubscribeButton(price: "Price", startButtonText: "Start Subscription", description: "Description")
    let sub2 = SubscribeButton(price: "Price", startButtonText: "Start Subscription", description: "Description")
    var explanationLabel = UILabel()
    
    let consentText = "By continuing, you agree to our Terms and Conditions, and our Privacy Policy"
    let linkRanges = [NSRange(location: 32, length: 20), NSRange(location: 62, length: 14)]
    let termsAndConditionsLink = "https://docs.google.com/document/d/1nCQsl8NFpXrd2BSs6cUN7VpGX_iK3U0qw6Qmw1v2SQM/edit?usp=sharing"
    let privacyPolicyLink = "https://docs.google.com/document/d/1nCQsl8NFpXrd2BSs6cUN7VpGX_iK3U0qw6Qmw1v2SQM/edit?usp=sharing"
    
    var retrieveErrorCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        load()
    }
}

private extension SubscribeVC {
    func load() {
        sskr.retrieveProductsInfo(productIDs: [sskr.monthlySub, sskr.yearlySub], retrieved: { (products) in
            print("Retrieved IAP")
            self.products = Array(products)
            self.setInfo()
        }, invalidIDs: { (invalidIDs) in
            for invalidID in invalidIDs {
                print("Invalid product id upon IAP retrieval: \(invalidID)")
            }
        }, errorHandler: { (error) in
            print("Retrieve error")
            self.retrieveErrorCount += 1
            if self.retrieveErrorCount == 2 {
                self.showAlertWithText("Unknown error occured. Please restard the app.")
            }
        })
    }
    
    func setupViews() {
        let padding: CGFloat = 10.0
        explanationLabel = LabelWithLinks(text: consentText, rangesForLinks: linkRanges, links: [termsAndConditionsLink, privacyPolicyLink], textColor: .systemGray, font: .preferredFont(forTextStyle: .caption1), usesAutolayout: true)
        
        view.addSubview(sub1)
        view.addSubview(sub2)
        view.addSubview(explanationLabel)
        
        sub1.constrainToTopSafeAreaOf(view, padding: padding)
        sub1.constrainToSideSafeAreasOf(view, padding: padding)
        
        sub2.isBelow(sub1, padding: padding)
        sub2.constrainToSideSafeAreasOf(view, padding: padding)
        sub2.heightAnchor.constraint(equalTo: sub1.heightAnchor).isActive = true
        
        explanationLabel.isBelow(sub2, padding: padding)
        explanationLabel.constrainToBottomSafeAreaOf(view, padding: padding)
        explanationLabel.constrainToSideSafeAreasOf(view, padding: padding)
    }
}

// MARK: IAP
private extension SubscribeVC {
    private func titleFor(_ product: SKProduct) -> String {
        return product.localizedTitle
    }
    
    private func priceFor(_ product: SKProduct) -> String {
        return product.localizedPrice ?? "N/A"
    }

    private func descriptionFor(_ product: SKProduct) -> String {
//        let title = product.localizedTitle
        let desc = product.localizedDescription
        let price = product.localizedPrice ?? "NA"

        if let subscriptionPeriod = product.subscriptionPeriod {
            let unit = subscriptionPeriod.unit
            let numUnits = String(describing: subscriptionPeriod.numberOfUnits)
            var period = ""
            switch unit.rawValue {
            case 0:
                period = numUnits + " day(s)"
                break
            case 1:
                period = numUnits + " week(s)"
                break
            case 2:
                period = numUnits + " month(s)"
                break
            case 3:
                period = numUnits + " year(s)"
                break
            default:
                break
            }

            if let introPrice = product.introductoryPrice {
                let introPeriodUnit = introPrice.subscriptionPeriod.unit
                let introNumPeriod = String(describing: introPrice.subscriptionPeriod.numberOfUnits)
                var introPeriod = ""
                switch introPeriodUnit.rawValue {
                case 0:
                    introPeriod = introNumPeriod + " day(s)"
                    break
                case 1:
                    introPeriod = introNumPeriod + " week(s)"
                    break
                case 2:
                    introPeriod = introNumPeriod + " month(s)"
                    break
                case 3:
                    introPeriod = introNumPeriod + " year(s)"
                    break
                default:
                    break
                }
                
                if introPrice.price == 0 {
                    return "\(desc) Free trial for \(introPeriod), and \(price) every \(period) thereafter."
                } else {
                    return "\(desc) Introductory price of \(introPrice.price) for \(introPeriod) and \(price) every \(period) thereafter."
                }
            }
            return "\(desc) \(price) every \(period)"
        }
        return "\(desc) Price: \(price)"
    }
}

// MARK: Buttons
private extension SubscribeVC {
    @objc func button1Pressed() {
        guard products.count >= 1 else {return}
        purchase(product: products[0])
    }
    
    @objc func button2Pressed() {
        guard products.count >= 2 else {return}
        purchase(product: products[1])
    }
    
    func purchase(product: SKProduct) {
        sskr.purchaseProduct(product) { (result) in
            print("Purchase results came back!")
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.proceedToContent()
            case .error(let error):
                switch error.code {
                case .unknown: self.showAlertWithText("Unknown error. Please contact support"); break
                case .clientInvalid: self.showAlertWithText("Not allowed to make the payment"); break
                case .paymentCancelled: self.showAlertWithText("Purchase cancelled"); break
                case .paymentInvalid: self.showAlertWithText("The purchase identifier was invalid"); break
                case .paymentNotAllowed: self.showAlertWithText("The device is not allowed to make the payment"); break
                case .storeProductNotAvailable: self.showAlertWithText("The product is not available in the current storefront"); break
                case .cloudServicePermissionDenied: self.showAlertWithText("Access to cloud service information is not allowed"); break
                case .cloudServiceNetworkConnectionFailed: self.showAlertWithText("Could not connect to the network"); break
                case .cloudServiceRevoked: self.showAlertWithText("User has revoked permission to use this cloud service"); break
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    /// Set allowsAccessToContent to true in the main tab, which will hide the intro view. Then update the User object too.
    func proceedToContent() {
        let mainTab = MainTabBarC.shared
        mainTab.allowsAccessToContent = true
        mainTab.updateUserInfo()
    }
}

// MARK: Views
private extension SubscribeVC {
    func setInfo() {
        guard products.count == 2 else {return}
        sub1.setInfo(price: priceFor(products[0]), startButtonText: "Start " + titleFor(products[0]), description: descriptionFor(products[0]), action: #selector(button1Pressed))
        sub2.setInfo(price: priceFor(products[1]), startButtonText: "Start " + titleFor(products[1]), description: descriptionFor(products[1]), action: #selector(button2Pressed))
    }
    
    func alert(text: String) -> UIAlertController {
        let ac = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return ac
    }
    
    func showAlertWithText(_ text: String) {
        self.present(alert(text: text), animated: true, completion: nil)
    }
}
