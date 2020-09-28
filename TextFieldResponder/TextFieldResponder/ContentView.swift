//
//  ContentView.swift
//  TextFieldResponder
//
//  Created by Peter Ent on 9/28/20.
//

import SwiftUI

struct ContentView: View {
    @State private var login = ""
    @State private var password = ""
    @State private var website = ""
    @State private var other = ""
    
    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextFieldResponder(title: "Login", text: self.$login)
                    .keyboardType(.emailAddress)
                    .autocorrection(.yes)
                    .autocapitalization(.none)
                TextFieldResponder(title: "Password", text: self.$password, onCommit: {
                    print("Now try to log in")
                })
                .isSecure(true)
            }
            
            Section(header: Text("Details")) {
                TextFieldResponder(title: "Website", text: self.$website)
                    .keyboardType(.URL)
                TextFieldResponder(title: "Other", text: self.$other) {
                    print("Response from Other field")
                }
                .autocapitalization(.allCharacters)
                .returnKeyType(.done)
            }
            
            
            Section(header: Text("Results as You Type")) {
                Text("Login: \(self.login)")
                Text("Password: \(self.password)")
                Text("Website: \(self.website)")
                Text("Other: \(self.other)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
