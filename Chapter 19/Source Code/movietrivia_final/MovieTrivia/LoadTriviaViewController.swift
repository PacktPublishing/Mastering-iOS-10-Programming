//
//  LoadTriviaViewController.swift
//  MovieTrivia
//
//  Created by Donny Wals on 15/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class LoadTriviaViewController: UIViewController {
    var questionsArray: [Question]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let apiProvider = TriviaAPI()
        let questionsLoader = QuestionsLoader(apiProvider: apiProvider)
        questionsLoader.loadQuestions { [weak self] questions in
            self?.questionsArray = questions
            self?.performSegue(withIdentifier: "TriviaLoadedSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionViewController = segue.destination as? QuestionViewController,
            let questionsArray = self.questionsArray
            else { return }
        
        questionViewController.questionsArray = questionsArray
    }
}
