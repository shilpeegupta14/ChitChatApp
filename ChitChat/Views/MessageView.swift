//
//  MessageView.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import SwiftUI

/// A chat message view.
struct MessageView: View {
  @Binding var message: Message
  let myUser: String

  private func color(for username: String?, myUser: String) -> Color {
    guard let username = username else {
      return Color.clear
    }
    return username == myUser ? Color.teal : Color.orange
  }

  var body: some View {
    HStack {
      if myUser == message.user {
        Spacer()
      }

      VStack(alignment: myUser == message.user ? .trailing : .leading) {
        if let user = message.user {
          HStack {
            if myUser != message.user {
              Text(user).font(.callout)
            }
          }
        }

        Text(message.message)
          .padding(.horizontal, 10)
          .padding(.vertical, 8)
          .overlay {
            RoundedRectangle(cornerRadius: 15)
              .strokeBorder(color(for: message.user, myUser: myUser), lineWidth: 1)
          }
      }

      if myUser != message.user && message.user != nil {
        Spacer()
      }
    }
    .padding(.vertical, 2)
    .frame(maxWidth: .infinity)
  }
}
