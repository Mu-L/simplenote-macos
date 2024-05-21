//
//  IntentHandler.swift
//  SimplenoteIntents
//
//  Created by Charlie Scheer on 5/21/24.
//  Copyright © 2024 Simperium. All rights reserved.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is OpenNewNoteIntent:
            return OpenNewNoteIntentHandler()
        default:
            return self
        }
    }
}
