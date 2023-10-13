//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Student08 on 12/10/2023.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    var title: String? = nil {
        didSet {
            label.text = title
        }
    }
    enum Style {
        case correct, incorrect, standard
    }
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    func setStyle(_ style: Style) {
        switch style {
        case .correct:
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
            backgroundColor = UIColor(red: 200.0/255.0, green: 236.0/255.0, blue: 160.0/255.0, alpha: 1) // Vert
        case .incorrect:
            icon.isHidden = false
            icon.image = UIImage(named: "Icon Error")
            backgroundColor = UIColor(red: 243.0/255.0, green: 135.0/255.0, blue: 148.0/255.0, alpha: 1) // Rouge
        case .standard:
            icon.isHidden = true
            backgroundColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1) // Gris
        }
    }
    
}
