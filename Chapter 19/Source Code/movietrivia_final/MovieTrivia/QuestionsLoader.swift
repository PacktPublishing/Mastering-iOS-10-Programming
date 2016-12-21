//
//  QuestionsLoader.swift
//  MovieTrivia
//
//  Created by Donny Wals on 16/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation
typealias QuestionsLoadedCallback = ([Question]) -> Void

struct QuestionsLoader {
    
    let apiProvider: TriviaAPIProviding
    
    func loadQuestions(callback: @escaping QuestionsLoadedCallback) {
        apiProvider.loadTriviaQuestions { json in
            guard let jsonQuestions = json["questions"] as? [JSON]
                else { return }
            
            let questions = jsonQuestions.map { jsonQuestion in
                return Question(json: jsonQuestion)
            }.flatMap { $0 }
            
            callback(questions)
        }
    }
}
