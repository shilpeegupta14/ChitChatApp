//
//  DataModel.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import Foundation

/// The codable server status response.
struct ServerStatus: Codable {
  let activeUsers: Int
}

/// The codable message data model.
struct Message: Codable, Identifiable, Hashable {
  let id: UUID
  let user: String?
  let message: String
  var date: Date
}

extension Message {
  init(message: String) {
    self.id = .init()
    self.date = .init()
    self.user = nil
    self.message = message
  }
}
