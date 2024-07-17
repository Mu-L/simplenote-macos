//
//  NSAlert+Passkeys.swift
//  Simplenote
//
//  Created by Charlie Scheer on 7/17/24.
//  Copyright © 2024 Simperium. All rights reserved.
//

import Foundation

extension NSAlert {
    static func presentPasskeyRegistrationAlert(onSubmit: @escaping (String) -> Void) {
        let alert = NSAlert(messageText: PasskeyAuthentication.alertTitle, informativeText: PasskeyAuthentication.message)
        let passwordField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = passwordField
        alert.addButton(withTitle: PasskeyAuthentication.submit)
        alert.addButton(withTitle: PasskeyAuthentication.cancel)

        let modalResult = alert.runModal()
        
        guard modalResult == .alertFirstButtonReturn else {
            return
        }

        onSubmit(passwordField.stringValue)
    }

    static func presentPasskeyResolvedAlert(succeeded: Bool) {
        let title = succeeded ? PasskeyAuthentication.successTitle : PasskeyAuthentication.failureTitle
        let message = succeeded ? PasskeyAuthentication.successMessage : PasskeyAuthentication.failureMessage
        let alert = NSAlert(messageText: title, informativeText: message)
        alert.addButton(withTitle: PasskeyAuthentication.okay)
        alert.runModal()
    }
}

private struct PasskeyAuthentication {
    static let alertTitle = NSLocalizedString("Passkey Setup", comment: "Alert title for setting up passkeys")
    static let message = NSLocalizedString("To add passkeys you must enter your password", comment: "Message prompting user for password to create passkey")
    static let submit = NSLocalizedString("Submit", comment: "Submit button title")
    static let cancel = NSLocalizedString("Cancel", comment: "Cancel button title")
    static let failureTitle = NSLocalizedString("Passkey Registration Failed", comment: "Title for alert when passkey registration fails")
    static let failureMessage = NSLocalizedString("Could not register passkey.  Please try again later", comment: "Message for when passkey registration fails")
    static let okay = NSLocalizedString("Okay", comment: "confirm button title")
    static let successTitle = NSLocalizedString("Success!!", comment: "Title for alert when passkey registration succeeds")
    static let successMessage = NSLocalizedString("Passkey Registration Succeeded", comment: "message for alert when passkey registration succeeds")
}
