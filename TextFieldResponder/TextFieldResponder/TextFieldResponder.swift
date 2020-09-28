//
//  TextFieldResponder.swift
//  TextFieldResponder
//
//  Created by Peter Ent on 9/27/20.
//

import SwiftUI

/**
 * TextFieldResponder allows the user to use the "return" key to go to the next TextFieldResponder
 * on the screen. It does this by assigning a unique tag to each underlying UITextField and then
 * finding the next one (by +1 increment of its own tag) and making that field the responder.
 * Failure to find a field results in the keyboard disappearing since no responder is assigned.
 *
 * Since the text property is @Binding it is changed as the user types. You can
 * use something like:
 *
 * var handleBinding: Binding<String> {
 *     Binding(
 *         get: { self.localValue },
 *         set: { (newValue) in
 *              self.localValue = newValue
 *              // now do some action if you need to
 *         }
 *     )
 * }
 *
 * instead of the $varname commonly used. This will give you more control over how
 * the data are used.
 */
struct TextFieldResponder: UIViewRepresentable {
    
    // this public static var allows you to change the base tag index to something unique
    // if this value does not suit your application
    static var tagIndex = 100
    
    // the title of the text is used as the placeholder.
    // the text is returned via binding when editing ends
    // onCommit is invoked when editing ends.
    var title: String
    @Binding var text: String
    var onCommit: (() -> Void)?
    
    private let textField: UITextField = UITextField()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let uiView = textField
        uiView.delegate = context.coordinator
        uiView.placeholder = title
        uiView.tag = TextFieldResponder.tagIndex
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal) // required to avoid the field from growing in size as you type
        
        TextFieldResponder.tagIndex += 1
        
        return uiView
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // make adjusts if needed
    }
    
    func updateBinding(value: String) {
        // important to do this async off the main queue otherwise SwiftUI will think you are trying to
        // update the state while it is refreshing the UI.
        DispatchQueue.main.async {
            self.text = value
        }
    }
    
    //
    // COORDINATOR
    //
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldResponder
        
        init(_ parent: TextFieldResponder) {
            self.parent = parent
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let nextTag = textField.tag + 1
            var parentView = textField.superview
            textField.resignFirstResponder()
            
            // locate the next field that has the nextTag and make that the
            // responder.
            while parentView != nil {
                if let field = parentView?.viewWithTag(nextTag) {
                    field.becomeFirstResponder()
                    break
                }
                parentView = parentView?.superview
            }
            
            // trigger the commit action if given.
            self.parent.onCommit?()
            return true
        }
        
        // this delegate function is called while the user is editing the field. it causes
        // the binding in the parent to update. if you only want to update the binding
        // once editing has ended, then replace this function with textFieldDidEndEditing(:).
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let newText = text.replacingCharacters(in: textRange, with: string)
                parent.updateBinding(value: newText)
            }
            return true
        }
    }
}

// MARK: - The Extension for modifiers

extension TextFieldResponder {
    func keyboardType(_ kbd: UIKeyboardType) -> TextFieldResponder {
        self.textField.keyboardType = kbd
        return self
    }
    
    func isSecure(_ secure: Bool) -> TextFieldResponder {
        self.textField.isSecureTextEntry = secure
        return self
    }
    
    func returnKeyType(_ type: UIReturnKeyType) -> TextFieldResponder {
        self.textField.returnKeyType = type
        return self
    }
    
    func autocapitalization(_ autocap: UITextAutocapitalizationType) -> TextFieldResponder {
        self.textField.autocapitalizationType = autocap
        return self
    }
    
    func autocorrection(_ autocorrect: UITextAutocorrectionType) -> TextFieldResponder {
        self.textField.autocorrectionType = autocorrect
        return self
    }
}
