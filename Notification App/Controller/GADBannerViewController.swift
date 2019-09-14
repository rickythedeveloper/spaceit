//
//  GADBannerViewController.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 11/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable {
    
    var adUnitID: String // testing ID is "ca-app-pub-3940256099942544/2934735716"
    
    func makeUIViewController(context: Context) -> UIViewController {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        let bannerViewController = UIViewController()
        bannerView.adUnitID = self.adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = BannerViewDelegate.shared
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        bannerView.load(GADRequest())
        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class BannerViewDelegate: NSObject, GADBannerViewDelegate {
    static let shared = BannerViewDelegate()
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
