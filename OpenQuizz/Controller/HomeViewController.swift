//
//  HomeViewController.swift
//  OpenQuizz
//
//  Created by Student08 on 12/10/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var myLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    var game = Game()
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(
            self, selector: #selector(questionsLoaded),
            name: name, object: nil)
        
        //Lancement du jeu au lancement de l'app
        startNewGame()
        
        //gestion de la gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    //MARK: - Gesture
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .ended, .cancelled:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        
        //rotation autour d'un axe
        let rotationAngle = (CGFloat.pi / 3) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10"
        
        //récupérer la largeur de l'écran
        let screenWidth = UIScreen.main.bounds.width
        
        //translation vers la droite ou la gauche
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        //Création de l'animation
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success {
                self.showQuestionView()
            }
        })
    }
    
    //MARK: - Animation
    private func showQuestionView() {
        questionView.transform = .identity
        
        //réduction de la taille de la view
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        questionView.style = .standard

        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        
        //animer la view pour la faire revenir à sa vue initiale avec un effet "bouing"
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    self.questionView.transform = .identity
                }, completion:nil)
    
    }
    
    //MARK: - Starting a game
    @objc func questionsLoaded() {
        myLoadingIndicator.isHidden = true
        myButton.isHidden = false
        questionView.title = game.currentQuestion.title
    }
    
    @IBAction func didTapNewGame(_ sender: Any) {
        myButton.isHidden = true
        myLoadingIndicator.isHidden = false
        
        questionView.style = .standard
        questionView.title = "Loading.."
        
        scoreLabel.text = "0/10"
        
        game.refresh()
    }
    
    func startNewGame() {
        myButton.isHidden = true
        myLoadingIndicator.isHidden = false
        
        questionView.style = .standard
        questionView.title = "Loading.."
        
        scoreLabel.text = "0/10"
        
        game.refresh()
    }
    
}
