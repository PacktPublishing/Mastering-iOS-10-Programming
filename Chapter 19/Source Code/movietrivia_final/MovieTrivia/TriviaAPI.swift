//
//  TriviaAPI.swift
//  MovieTrivia
//
//  Created by Donny Wals on 16/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation

struct TriviaAPI: TriviaAPIProviding {
    func loadTriviaQuestions(callback: @escaping QuestionsFetchedCallback) {
        if ProcessInfo.processInfo.arguments.contains("isUITesting") || 1==1 {
            loadQuestionsFromFile(callback: callback)
            return
        }
        
        guard let url = URL(string: "http://quesions.movietrivia.json")
            else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonObject as? JSON
                else { return }
            
            callback(json)
        }
    }
    
    func loadQuestionsFromFile(callback: @escaping QuestionsFetchedCallback) {
        guard let filename = Bundle.main.path(forResource: "TriviaQuestions", ofType: "json"),
            let triviaString = try? String(contentsOfFile: filename),
            let triviaData = triviaString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
            let triviaJSON = jsonObject as? JSON
            else { return }
        
        callback(triviaJSON)
    }
}
