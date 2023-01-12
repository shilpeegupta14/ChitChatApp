//
//  ChatLocationDelegate+.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import Foundation
import CoreLocation

class ChatLocationDelegate: NSObject, CLLocationManagerDelegate {
  typealias LocationContinuation = CheckedContinuation<CLLocation, Error>
  private var continuation: LocationContinuation?
  private let manager = CLLocationManager()

  init(continuation: LocationContinuation) {
    self.continuation = continuation
    super.init()
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .notDetermined:
      break
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    default:
      continuation?.resume(
        throwing: "The app isn't authorized to use location data"
      )
      continuation = nil
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.first else { return }
    continuation?.resume(returning: location)
    continuation = nil
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    continuation?.resume(throwing: error)
    continuation = nil
  }
}
