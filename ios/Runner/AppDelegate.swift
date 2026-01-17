import UIKit
import Flutter
import GoogleMaps  // <-- Dodaj ovo

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Registracija Google Maps API key-a
    GMSServices.provideAPIKey("OVDE_STAVI_SVOJ_GOOGLE_MAPS_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
