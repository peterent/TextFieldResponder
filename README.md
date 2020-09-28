# TextFieldResponder
One way to implement the UIResponder chain in SwiftUI

My blog article at https:www.keaura.com has more details but basically this repository contains the source to `TextFieldResponder`, a custom SwiftUI component that hooks input fields into the responder chain. This allows you to tap on the keyboard's "return" key to go to the next field in the chain. Think of an login screen where the user types in their email address, taps "next" on the keyboard, then enters their password. Since the responder chain is not fully developed in SwiftUI, you would have to tap on the password field to get the keyboard focused there.

The project contains a very simple SwiftUI app to demonstrate the component.
