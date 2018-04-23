//
//  ViewController.swift
//  Hangman
//
//  Created by Koussaïla Ben Mamar on 28/03/2018.
//  Copyright © 2018 Koussaïla Ben Mamar. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var secretWordLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var essaisLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageHangmanLabel: UIImageView!
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet var keyboardButtons: [UIButton]!
    
    var jeu: Hangman = Hangman()
    var secondes = 0
    var timer = Timer()
    var timerOn = false
    var imageNumber = 0
    var imageName = "Hangman-0"
    var start = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonState.layer.cornerRadius = 8
        start = false
        letterLabel.isHidden = true
    }
    
    @IBAction func touchButton(_ sender: UIButton)
    {
        // Le clavier et le jeu est lancé uniquement si le bouton
        if (start == true)
        {
            if (jeu.essais > 0)
            {
                essaisLabel.text = "Essais: " + String(jeu.essais)
                
                let letter = sender.currentTitle!
                
                print("Pressed button \(letter)")
                jeu.lettre = letter
                letterLabel.text = "Vous avez saisi: " + jeu.lettre
                
                if checkLetter(on: sender)
                {
                    secondes = 6
                    print("C'est la bonne touche")
                    
                    sender.isEnabled = false

                    if (sender.isEnabled == false)
                    {
                        print("Le bouton \(sender.currentTitle!) est désactivé \n")
                    }
                }
                else
                {
                    secondes = 6
                    jeu.essais -= 1
                    essaisLabel.text = "Essais: " + String(jeu.essais)
                    imageNumber += 1
                    imageName = "Hangman-" + String(imageNumber)
                    imageHangmanLabel.image = UIImage(named: imageName)
                    print("Mauvaise touche !")
                    
                    sender.isEnabled = false
                    
                    if (sender.isEnabled == false)
                    {
                        print("Le bouton \(sender.currentTitle!) est désactivé \n")
                    }
                }
            }
            
            if (jeu.mot == jeu.motSecret)
            {
                gameOverLabel.textColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
                gameOverLabel.text = "GAGNÉ"
                gameOverLabel.isHidden = false
                letterLabel.isHidden = true
                print("Fin de partie, chrono désactivé")
                timer.invalidate()
                
                setButtonState()
            }
            else if (jeu.essais == 0)
            {
                gameOverLabel.textColor = UIColor.red
                essaisLabel.textColor = UIColor.red
                essaisLabel.text = "Essais: " + String(jeu.essais)
                gameOverLabel.isHidden = false
                gameOverLabel.text = "PERDU !"
                letterLabel.textColor = UIColor.red
                letterLabel.text = "Le bon mot: " + jeu.motSecret
                print("Fin de partie, chrono désactivé")
                timer.invalidate()
                
                setButtonState()
            }
            else if (jeu.essais == 1)
            {
                gameOverLabel.textColor = UIColor(red: 227/255, green: 115/255, blue: 2/255, alpha: 1.0)
                essaisLabel.textColor = UIColor(red: 227/255, green: 115/255, blue: 2/255, alpha: 1.0)
                gameOverLabel.isHidden = false
                gameOverLabel.text = "DERNIER ESSAI !"
            }
        }
    }
    
    @IBAction func startStopButton(_ sender: Any)
    {
        // Initialiser le jeu
        if (start == false)
        {
            buttonState.backgroundColor = UIColor.red
            buttonState.setTitle("Stop", for: .normal)
            essaisLabel.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
            setButtonState()
            imageNumber = 0
            
            enableKeyboard()
            jeu.initialiserJeu()
            
            letterLabel.textColor = UIColor.black
            essaisLabel.text = "Essais: " + String(jeu.essais)
            gameOverLabel.isHidden = true
            imageHangmanLabel.image = UIImage(named: "Hangman-0")
            jeu.formaterMot()
            secretWordLabel.text = jeu.mot_format
            letterLabel.isHidden = false
            
            // On démarre le temps imparti et le jeu
            if (jeu.essais > 0)
            {
                secondes = 5
                timeLabel.text = "Temps: \(secondes)"
                print("Jeu démarré, chrono lancé")
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
        }
        else
        {
            // Le jeu est stoppé, on stoppe le temps imparti
            timer.invalidate()
            setButtonState()
            gameOverLabel.isHidden = false
            gameOverLabel.textColor = UIColor.black
            gameOverLabel.text = "GAME OVER"
            letterLabel.isHidden = true
        }
    }
    
    // On vérifie si la lettre proposée est correcte
    func checkLetter(on button: UIButton) -> Bool
    {
        var isOk: Bool = true
        let char_pos: Int = jeu.verifierLettre(letter: jeu.lettre)
    
        print("> Lettre: \(jeu.lettre)")
        
        // On vérifie si la lettre proposée est correcte
        if (char_pos != -1)
        {
            print("> True: pos = \(char_pos)")
            isOk = true
            jeu.remplacerLettre(index: char_pos, letter: jeu.lettre)
            secretWordLabel.text = jeu.mot_format
        }
        else
        {
            isOk = false
        }
        
        return isOk
    }
    
    /* Actualisé toutes les secondes, cette fonction fonctionne comme un Thread
       - En fonction du temps imparti, on va vérifier les différentes situations
    */
    @objc func updateTimer()
    {
        // Si le jeu continue
        if (jeu.essais > 0)
        {
            // Il ne reste plus qu'un essai après en avoir perdu un à cause du temps écoulé
            if (jeu.essais == 1)
            {
                gameOverLabel.isHidden = false
                gameOverLabel.textColor = UIColor(red: 227/255, green: 115/255, blue: 2/255, alpha: 1.0)
                essaisLabel.textColor = UIColor(red: 227/255, green: 115/255, blue: 2/255, alpha: 1.0)
                gameOverLabel.text = "DERNIER ESSAI !"
            }
            
            // On décremente d'une seconde à chaque fois
            if (secondes > 0)
            {
                secondes -= 1
                
                // 2 secondes restantes: ça chauffe ! On change la couleur du label temps en orange
                if (secondes == 2)
                {
                    timeLabel.textColor = UIColor(red: 227/255, green: 115/255, blue: 2/255, alpha: 1.0)
                }
                else if (secondes <= 1)
                {
                    timeLabel.textColor = UIColor.red
                }
                else
                {
                    timeLabel.textColor = UIColor.black
                }
                
                // timeLabel.text = "Temps: \(secondes)"
            }
            else
            {
                timeLabel.textColor = UIColor.black
                secondes = 5
                // timeLabel.text = "Temps: \(secondes)"
                jeu.essais -= 1
                essaisLabel.text = "Essais: " + String(jeu.essais)
                imageNumber += 1
                imageName = "Hangman-" + String(imageNumber)
                imageHangmanLabel.image = UIImage(named: imageName)
                print("Essais restants: \(jeu.essais)")
            }
        }
        else
        {
            timer.invalidate()
            essaisLabel.textColor = UIColor.red
            gameOverLabel.textColor = UIColor.red
            gameOverLabel.isHidden = false
            timeLabel.textColor = UIColor.red
            essaisLabel.text = "Essais: " + String(jeu.essais)
            gameOverLabel.text = "PERDU !"
            letterLabel.textColor = UIColor.red
            letterLabel.text = "Le bon mot: " + jeu.motSecret
            print("Fin de partie, chrono désactivé")
            
            setButtonState()
        }
        
        timeLabel.text = "Temps: \(secondes)"
        print("Temps: \(secondes)")
    }
    
    func setButtonState()
    {
        // Lancer la partie
        if (start == true)
        {
            buttonState.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
            buttonState.setTitle("Démarrer", for: .normal)
            
            start = false
        }
        else
        {
            buttonState.backgroundColor = UIColor.red
            buttonState.setTitle("Arrêter", for: .normal)
            
            start = true
        }
    }
    
    func enableKeyboard()
    {
        for key in keyboardButtons
        {
            if (key.isEnabled == false)
            {
                key.isEnabled = true
                
                if (key.isEnabled == true)
                {
                    print("Le bouton \(key.currentTitle!) est activé")
                }
            }
        }
    }
}

