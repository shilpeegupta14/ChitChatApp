# ChitChatApp

## How to run this app:
- cd ChitChatApp/backendChitChat/VaporBackend
- swift run
- server will run. 
- Now open the xcode project and press cmd+R. 

## About the project:
- Messaging app based on AsyncStream with custom Vapor backend to write and read text
messages from the buffer using queue data structure.
- Other features involves scheduling text messages to be sent after the countdown and notifies
people in the chatroom when a person leaves or joins the chatroom by bridging APIs like
Timer and Notification Center with the AsyncStream using continuations with callbacks.
- It also provides location sharing by interoping with delegates based CoreLocation
Framework and async/await code
