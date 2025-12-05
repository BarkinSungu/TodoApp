import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    let adSize: AdSize

    init(adUnitID: String, adSize: AdSize = AdSizeBanner) {
        self.adUnitID = adUnitID
        self.adSize = adSize
    }

    func makeUIView(context: Context) -> BannerView {
        let view = BannerView(adSize: adSize)
        view.adUnitID = adUnitID
        view.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        view.load(Request())
        return view
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // No-op for now. If size or unit changes, you can reload here.
    }
}
