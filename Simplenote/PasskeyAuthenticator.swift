import Foundation
import AuthenticationServices

class PasskeyAuthControllerDelegate: NSObject, ASAuthorizationControllerDelegate {

    var onCompletion: ((Result<PasskeyAuthResponse, Error>) -> Void)?

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        onCompletion?(.failure(error))
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion else {
            onCompletion?(.failure(PasskeyError.authFailed))
            return
        }

        let response = PasskeyAuthResponse(from: credential)
        onCompletion?(.success(response))
    }
}

class PasskeyAuthenticator: NSObject {
    private let passkeyRemote: PasskeyRemote
    private let internalAuthControllerDelegate: PasskeyAuthControllerDelegate

    init(passkeyRemote: PasskeyRemote = PasskeyRemote(), authControllerDelegate: PasskeyAuthControllerDelegate = .init()) {
        self.passkeyRemote = passkeyRemote
        self.internalAuthControllerDelegate = authControllerDelegate
    }

    func attemptPasskeyAuth(for email: String, in presentationContext: PresentationContext) async throws -> PasskeyVerifyResponse {
        let challenge = try await passkeyRemote.passkeyAuthChallenge(for: email)

        let challengeData = try Data.decodeUrlSafeBase64(challenge.challenge)
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: challenge.relayingParty)
        let request = provider.createCredentialAssertionRequest(challenge: challengeData)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = internalAuthControllerDelegate
        controller.presentationContextProvider = presentationContext

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PasskeyVerifyResponse, any Error>) in
            internalAuthControllerDelegate.onCompletion = { [weak self] result in
                guard let self else {
                    continuation.resume(throwing: PasskeyError.authFailed)
                    return
                }

                switch result {
                case .success(let response):
                    Task {
                        do {
                            let verify = try await self.performPasskeyAuthentication(with: response)
                            continuation.resume(returning: verify)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }

            controller.performRequests()
        }
    }

    private func performPasskeyAuthentication(with response: PasskeyAuthResponse) async throws -> PasskeyVerifyResponse {
        guard let response = try? await passkeyRemote.verifyPasskeyLogin(with: response) else {
            throw PasskeyError.authFailed
        }

        return response
    }
}
