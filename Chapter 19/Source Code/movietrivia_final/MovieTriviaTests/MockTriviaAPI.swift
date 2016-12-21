//
//  MockTriviaAPI.swift
//  MovieTrivia
//
//  Created by Donny Wals on 16/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation
@testable import MovieTrivia

struct MockTriviaAPI: TriviaAPIProviding {
    func loadTriviaQuestions(callback: @escaping QuestionsFetchedCallback) {
        
        guard let filename = Bundle(for: LoadQuestionsTest.self).path(forResource: "TriviaQuestions", ofType: "json"),
            let triviaString = try? String(contentsOfFile: filename),
            let triviaData = triviaString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
            let triviaJSON = jsonObject as? JSON
            else { return }
        
        callback(triviaJSON)
    }
}
