//
//  TriviaAPIProviding.swift
//  MovieTrivia
//
//  Created by Donny Wals on 16/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Foundation

typealias QuestionsFetchedCallback = (JSON) -> Void

protocol TriviaAPIProviding {
    func loadTriviaQuestions(callback: @escaping QuestionsFetchedCallback)
}
