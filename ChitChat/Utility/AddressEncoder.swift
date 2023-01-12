//
//  AddressEncoder.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import CoreLocation
import Contacts

/// A type that converts a location into a human readable address.
enum AddressEncoder {
  /// Converts the given location into the nearest address, calls `completion` when finished.
  ///
  /// - Note: This method is "simulating" an old-style callback API that the reader can wrap
  ///   as an async code while working through the book.
  static func addressFor(location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
    let geocoder = CLGeocoder()

    Task {
      do {
        guard
          let placemark = try await geocoder.reverseGeocodeLocation(location).first,
          let address = placemark.postalAddress else {
            completion(nil, "No addresses found")
            return
          }
        completion(CNPostalAddressFormatter.string(from: address, style: .mailingAddress), nil)
      } catch {
        completion(nil, error)
      }
    }
  }
}
