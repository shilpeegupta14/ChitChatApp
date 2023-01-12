//
//  ChitChatTests.swift
//  ChitChatTests
//
//  Created by Shilpee Gupta on 10/01/23.
//

import XCTest
@testable import ChitChat

class BlabberTests: XCTestCase {
  let model: BlabberModel = {
    let model = BlabberModel()
    model.username = "test"

    let testConfiguration = URLSessionConfiguration.default
    testConfiguration.protocolClasses = [TestURLProtocol.self]

    model.urlSession = URLSession(configuration: testConfiguration)
    model.sleep = { try await Task.sleep(nanoseconds: $0 / 1_000_000_000) }
    return model
  }()

  func testModelSay() async throws {
    try await model.say("Hello!")

    let request = try XCTUnwrap(TestURLProtocol.lastRequest)

    XCTAssertEqual(
      request.url?.absoluteString,
      "http://localhost:8080/chat/say"
    )

    let httpBody = try XCTUnwrap(request.httpBody)
    let message = try XCTUnwrap(try? JSONDecoder()
      .decode(Message.self, from: httpBody))

    XCTAssertEqual(message.message, "Hello!")
  }

  func testModelCountdown() async throws {
    async let countdown: Void = model.countdown(to: "Tada!")
    async let messages = TimeoutTask(seconds: 10) {
      await TestURLProtocol.requests
        .prefix(4)
        .reduce(into: []) { result, request in
          result.append(request)
        }
        .compactMap(\.httpBody)
        .compactMap { data in
          try? JSONDecoder()
            .decode(Message.self, from: data).message
        }
    }
    .value

    let (messagesResult, _) = try await (messages, countdown)

    XCTAssertEqual(
      ["3...", "2...", "1...", "🎉 Tada!"],
      messagesResult
    )
  }
}
