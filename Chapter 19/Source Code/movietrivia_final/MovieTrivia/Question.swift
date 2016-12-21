//
//  Question.swift
//  MovieTrivia
//
//  Created by Donny Wals on 16/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation

struct Question {
    
    let title: String
    let answerA: String
    let answerB: String
    let answerC: String
    let correctAnswer: Int
    
    init?(json: JSON) {
        guard let title = json["title"] as? String,
            let answerA = json["answer_a"] as? String,
            let answerB = json["answer_b"] as? String,
            let answerC = json["answer_c"] as? String,
            let correctAnswer = json["correct_answer"] as? Int
            else { return nil }
        
        self.title = title
        self.answerA = answerA
        self.answerB = answerB
        self.answerC = answerC
        self.correctAnswer = correctAnswer
    }
}
