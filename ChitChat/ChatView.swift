//
//  ChatView.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import SwiftUI

struct ChatView: View {
  @ObservedObject var model: BlabberModel

  /// `true` if the message text field is focused.
  @FocusState var focused: Bool

  /// The message that the user has typed.
  @State var message = ""

  /// The last error message that happened.
  @State var lastErrorMessage = "" {
    didSet {
      isDisplayingError = true
    }
  }
  @State var isDisplayingError = false

  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack {
      ScrollView(.vertical) {
        ScrollViewReader { reader in
          ForEach($model.messages) { message in
            MessageView(message: message, myUser: model.username)
          }
          .onChange(of: model.messages.count) { _ in
            guard let last = model.messages.last else { return }

            withAnimation(.easeOut) {
              reader.scrollTo(last.id, anchor: .bottomTrailing)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      HStack {
        Button(action: {
          Task {
            do {
              try await model.shareLocation()
            } catch {
              lastErrorMessage = error.localizedDescription
            }
          }
        }, label: {
          Image(systemName: "location.circle.fill")
            .font(.title)
            .foregroundColor(Color.gray)
        })

        Button(action: {
          Task {
            do {
              let countdownMessage = message
              message = ""
              try await model.countdown(to: countdownMessage)
            } catch {
              lastErrorMessage = error.localizedDescription
            }
          }
        }, label: {
          Image(systemName: "timer")
            .font(.title)
            .foregroundColor(Color.gray)
        })

        TextField(text: $message, prompt: Text("Message")) {
          Text("Enter message")
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .focused($focused)
        .onSubmit {
          Task {
            try await model.say(message)
            message = ""
          }
          focused = true
        }

        Button(action: {
          Task {
            try await model.say(message)
            message = ""
          }
        }, label: {
          Image(systemName: "arrow.up.circle.fill")
            .font(.title)
        })
      }
    }
    .padding()
    .onAppear {
      focused = true
    }
    .alert("Error", isPresented: $isDisplayingError, actions: {
      Button("Close", role: .cancel) {
        self.presentationMode.wrappedValue.dismiss()
      }
    }, message: {
      Text(lastErrorMessage)
    })
    .task {
      do {
        try await model.chat()
      } catch {
        lastErrorMessage = error.localizedDescription
      }
    }
  }
}
