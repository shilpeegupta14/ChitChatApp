//
//  ContentView.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("username") var username = ""
  @State var isDisplayingChat = false
  @State var model = BlabberModel()

  var body: some View {
    VStack {
      Text("Blabber")
        .font(.custom("Lemon", size: 48))
        .foregroundColor(Color.teal)

      HStack {
        TextField(text: $username, prompt: Text("Username")) { }
        .textFieldStyle(RoundedBorderTextFieldStyle())

        Button(action: {
          model.username = username
          self.isDisplayingChat = true
        }, label: {
          Image(systemName: "arrow.right.circle.fill")
            .font(.title)
            .foregroundColor(Color.teal)
        })
        .sheet(isPresented: $isDisplayingChat, onDismiss: {}, content: {
          ChatView(model: model)
        })
      }
      .padding(.horizontal)
    }
    .statusBar(hidden: true)
  }
}
