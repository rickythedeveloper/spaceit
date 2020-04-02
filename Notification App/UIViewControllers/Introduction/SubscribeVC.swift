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
    
    var errorFlag = false
    
    var button1 = UIButton()
    var button2 = UIButton()
    var label1 = UILabel()
    var label2 = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        load()
    }
}

private extension SubscribeVC {
    func load() {
        sskr.retrieveProductsInfo(productIDs: [sskr.monthlySub, sskr.yearlySub], retrieved: { (products) in
            self.products = Array(products)
            self.setTexts()
        }, invalidIDs: { (invalidIDs) in
            for invalidID in invalidIDs {
                print("Invalid product id upon IAP retrieval: \(invalidID)")
            }
        }, errorHandler: { (error) in
            self.errorFlag = true
            self.showAlertWithText("Unknown error occured. Please restard the app.")
        })
    }
    
    func setupButtons() {
        let padding: CGFloat = 20.0
        
        button1 = subscribeButton()
        button1.addTarget(self, action: #selector(button1Pressed), for: .touchUpInside)
        view.addSubview(button1)
        button1.constrainToTopSafeAreaOf(view, padding: padding)
        button1.constrainToSideSafeAreasOf(view, padding: padding)
        button1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        label1 = descLabel()
        view.addSubview(label1)
        label1.isBelow(button1, padding: padding)
        label1.constrainToSideSafeAreasOf(view, padding: padding)
        label1.bottomAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor).isActive = true
        
        button2 = subscribeButton()
        button2.addTarget(self, action: #selector(button2Pressed), for: .touchUpInside)
        view.addSubview(button2)
        button2.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button2.constrainToSideSafeAreasOf(view, padding: padding)
        button2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        label2 = descLabel()
        view.addSubview(label2)
        label2.isBelow(button2, padding: padding)
        label2.constrainToSideSafeAreasOf(view, padding: padding)
//        label2.constrainToBottomSafeAreaOf(view, padding: padding)
        label2.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true
        
//        button2.isBelow(button1, padding: padding)
//        button2.constrainToSideSafeAreasOf(view, padding: padding)
//        button2.constrainToBottomSafeAreaOf(view, padding: padding)
//        button2.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
    }
}

// MARK: IAP
private extension SubscribeVC {
    private func titleFor(_ product: SKProduct) -> String {
        return product.localizedTitle
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
    
    func proceedToContent() {
//        TODO
    }
}

// MARK: Views
private extension SubscribeVC {
    func subscribeButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.2)
        button.setTitleColor(UIColor.myTextColor(), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        return button
    }
    
    func descLabel() -> UILabel {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.sizeToFit()
        return lable
    }
    
    func setTexts() {
        guard products.count == 2 else {return}
        button1.setTitle(titleFor(products[0]), for: .normal)
        button2.setTitle(titleFor(products[1]), for: .normal)
        
        label1.text = descriptionFor(products[0])
        label2.text = descriptionFor(products[1])
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
