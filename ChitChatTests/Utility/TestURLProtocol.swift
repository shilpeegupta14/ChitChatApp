//
//  TestURLProtocol.swift
//  ChitChatTests
//
//  Created by Shilpee Gupta on 12/01/23.
//

import Foundation

/// A catch-all URL protocol that returns successful response and records all requests.
class TestURLProtocol: URLProtocol {
  static var lastRequest: URLRequest? {
    didSet {
      if let request = lastRequest {
        continuation?.yield(request)
      }
    }
  }

  static private var continuation: AsyncStream<URLRequest>.Continuation?
  static var requests: AsyncStream<URLRequest> = {
    AsyncStream { continuation in
      TestURLProtocol.continuation = continuation
    }
  }()

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  /// Store the URL request and send success response back to the client.
  override func startLoading() {
    guard let client = client,
          let url = request.url,
          let response = HTTPURLResponse(url: url,
                                         statusCode: 200,
                                         httpVersion: nil,
                                         headerFields: nil) else {
      fatalError("Client or URL missing")
    }

    client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client.urlProtocol(self, didLoad: Data())
    client.urlProtocolDidFinishLoading(self)

    guard let stream = request.httpBodyStream else {
      fatalError("Unexpected test scenario")
    }

    var request = request
    request.httpBody = stream.data
    Self.lastRequest = request
  }

  override func stopLoading() {
  }
}
