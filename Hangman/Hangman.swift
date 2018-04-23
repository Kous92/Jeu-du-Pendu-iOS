//
//  Hangman.swift
//  Hangman
//
//  Created by Koussaïla Ben Mamar on 28/03/2018.
//  Copyright © 2018 Koussaïla Ben Mamar. All rights reserved.
//

import Foundation
import UIKit

class Hangman
{
    var motSecret: String
    var mot: String
    var mot_format: String
    var lettre: String
    var essais: Int
    var victoire: Bool
    var phrases : NSArray!
    
    // Constructeur
    init()
    {
       // self équivaut à this en Swift
        self.mot = ""
        self.mot_format = ""
        self.essais = 6
        self.victoire = false
        self.lettre = "a"
        self.motSecret = ""
        
        // On récupère les mots du dictionnaire dans le fichier wordData.plist
        let path = Bundle.main.path(forResource:"wordData", ofType: "plist")
        phrases = NSArray.init(contentsOfFile: path!)
    }
    
    func initialiserJeu()
    {
        self.mot = ""
        self.essais = 6
        self.victoire = false
        self.motSecret = getRandomPhrase()
        initialiserMot()
    }
    
    func initialiserMot()
    {
        // motSecret.characters.index(of: char)
        var str_tmp = ""
        var pos = 0
        
        for char in motSecret
        {
            if let index = motSecret.index(of: char)
            {
                pos = motSecret.distance(from: motSecret.startIndex, to: index)
                print("\(char) existe ->  position \(pos)")
                
                // Mots composés comme Aston Martin, Savage Rivale,...
                if (char == " ")
                {
                    str_tmp.append(" ")
                }
                else
                {
                    str_tmp.append("-")
                }
                
            }
        }
    
        print("Format -> \(str_tmp) du mot secret \(motSecret)")
        mot = str_tmp
    }
    
    // Méthode de comparaison des chaînes
    func verifierLettre(letter: String) -> Int
    {
        print("Comparaison de la lettre...")
        
        // motSecret.characters.index(of: char)
        var index: Int = 0;
        
        for char in motSecret
        {
            if char == Character(letter)
            {
                if let idx = motSecret.index(of: char)
                {
                    let pos = motSecret.distance(from: motSecret.startIndex, to: idx)
                    print("\(char) existe ->  position \(pos)")
                    
                    return pos
                }
                
                // print("> \(char) existe -> Index \(index)")
            }
            
            index += 1
        }
        
        print("> False")
        return -1
    }
    
    func remplacerLettre(index: Int, letter: String)
    {
        var index_str = 0
        
        for char in motSecret
        {
            if char == Character(letter)
            {
                if let idx = motSecret.index(of: char)
                {
                    let pos = motSecret.distance(from: motSecret.startIndex, to: idx)
                    print("\(char) existe ->  position \(pos)")
                    let _index = mot.index(mot.startIndex, offsetBy: index_str)
                    mot.replaceSubrange(_index..._index, with: letter)
                }
            }
            
            index_str += 1
        }
        
        print(mot)
        
        formaterMot()
    }
    
    func formaterMot()
    {
        // motSecret.characters.index(of: char)
        var str_tmp = ""
        var pos = 0
        
        for char in mot
        {
            if let index = mot.index(of: char)
            {
                pos = mot.distance(from: mot.startIndex, to: index)
                print("\(char) existe ->  position \(pos)")
                
                if (pos < (mot.count - 1))
                {
                    str_tmp.append(char)
                }
                else
                {
                    str_tmp.append(char)
                }
            }
        }
        
        print("Format -> \(str_tmp)")
        mot_format = str_tmp
    }
    
    // Get random phrase from all available phrases
    func getRandomPhrase() -> String!
    {
        let index = Int(arc4random_uniform(UInt32(phrases.count)))
        return phrases.object(at: index) as! String
    }
}
