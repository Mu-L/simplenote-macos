enum PasskeyError: Error {
    case couldNotRequestRegistrationChallenge
    case couldNotFetchAuthChallenge
    case authFailed
    case registrationFailed

    var localizedDescription: String {
        switch self {
        case .couldNotRequestRegistrationChallenge:
            return NSLocalizedString("Could not prepare an registration challenge", comment: "Error message that registering passkeys could not receive needed challeng")
        case .couldNotFetchAuthChallenge:
            return NSLocalizedString("Could not prepare an authorization challenge", comment: "Error message that authorizing passkeys could not receive needed challeng")
        case .authFailed:
            return NSLocalizedString("Authorization Failed", comment: "Error message that passkey authorization failed")
        case .registrationFailed:
            return NSLocalizedString("Registration Failed", comment: "Error message that passkey registration failed")
        }
    }
}
