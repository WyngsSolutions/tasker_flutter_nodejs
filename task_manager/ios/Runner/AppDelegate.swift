import UIKit
import Flutter
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

    let nativeAdFactory: ListTileNativeAdFactory! = ListTileNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self,factoryId:"listTile", nativeAdFactory:nativeAdFactory)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

// The UnifiedNativeAdView.xib and example GADUnifiedNativeAdView is provided and
// explained by https://developers.google.com/admob/ios/native/advanced.
    class ListTileNativeAdFactory : FLTNativeAdFactory {

        func createNativeAd(_ nativeAd: GADNativeAd,
                            customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
            let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)!.first
            let nativeAdView = nibView as! GADNativeAdView

            (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

            (nativeAdView.bodyView as! UILabel).text = nativeAd.body
            nativeAdView.bodyView!.isHidden = nativeAd.body == nil

            (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
            nativeAdView.iconView!.isHidden = nativeAd.icon == nil

            nativeAdView.callToActionView?.isUserInteractionEnabled = false

            nativeAdView.nativeAd = nativeAd

            return nativeAdView
        }
    }
}
