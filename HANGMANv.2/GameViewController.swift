//
//  GameViewController.swift
//  HANGMANv.2
//
//  Created by RNLD on 2023-10-21.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gamePlayerName: UILabel!
    
    @IBOutlet weak var word : UILabel!
    @IBOutlet weak var blurdWord: UILabel!
    
    @IBOutlet weak var firstLetter          : UILabel!
    @IBOutlet weak var secondLetter         : UILabel!
    @IBOutlet weak var thirdLetter          : UILabel!
    @IBOutlet weak var fourthLetter         : UILabel!
    @IBOutlet weak var fifthLetter          : UILabel!
    @IBOutlet weak var sixthLetter          : UILabel!
    @IBOutlet weak var seventhLetter        : UILabel!

    @IBOutlet weak var countWins            : UILabel!
    @IBOutlet weak var lossesCount          : UILabel!
   
    @IBOutlet weak var thankYou             : UILabel!
    @IBOutlet weak var gameOver             : UILabel!
    
    @IBOutlet weak var imgTrees             : UIImageView!
    @IBOutlet weak var imgBoiGrimmerLvl1    : UIImageView!
    @IBOutlet weak var imgBoiGrimmerLvl2    : UIImageView!
    @IBOutlet weak var imgBoiGrimmerLvl3    : UIImageView!
    @IBOutlet weak var imgBoiGrimmerFin     : UIImageView!
    @IBOutlet weak var grimmerCry           : UIImageView!
    @IBOutlet weak var boiDead              : UIImageView!
    
    @IBOutlet weak var btnYes               : UIButton!
    @IBOutlet weak var btnNo                : UIButton!
    @IBOutlet weak var secBtnYes            : UIButton!
    @IBOutlet weak var secBtnNo             : UIButton!
    @IBOutlet weak var btnExit              : UIButton!
    
    var playerName : String?
    var win : Int = 0
    var loss : Int = 0
    
    var wrongLtr = 5
    
    var currentWord: String = ""
    var guessedLetters: [ Character ] = []
    
    var allKeyButtons: [ UIButton ] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        resetGame()
        setupButtons()
        gamePlayerName.text = "Hang \"\(playerName ?? "")\", please!!"

    }
    
    @IBAction func reset(_ sender: Any ) {

        resetGame()
        resetScore()
        word.isHidden = true
        
    }

    
    @IBAction func keyBoard( _ sender: Any ) {
        
        guard let button = sender as? UIButton,
              let letter = button.titleLabel?.text?.uppercased().first
           else {
            
               return
            
           }

        if currentWord.contains( letter ) {
            
            guessedLetters.append( letter )
            updateLettersLabel()
            
            button.backgroundColor = UIColor.green
            button.setTitleColor( .white, for: .normal )
            button.isEnabled = false
            
            
        } else {
            
            let imagesToHide = [ imgTrees, imgBoiGrimmerLvl1,imgBoiGrimmerLvl2,imgBoiGrimmerLvl3,imgBoiGrimmerFin ]
            
            wrongLtr = wrongLtr - 1
            
            button.backgroundColor = UIColor.red
            button.setTitleColor( .white, for: .normal )
            button.isEnabled = false
            
            let imahe = [ imgBoiGrimmerFin, imgBoiGrimmerLvl3, imgBoiGrimmerLvl2, imgBoiGrimmerLvl1, imgTrees ]
            
            if wrongLtr < imahe.count {
                
                imahe[ wrongLtr ]?.isHidden = false
                
            }
            
            let indexToHide = imahe.count - wrongLtr - 2
            print( indexToHide )
            
            if indexToHide >= 1 && indexToHide < imahe.count {
                
                imagesToHide[indexToHide]?.isHidden = true
                print( "HIDE : ", indexToHide )
                
            }
            
            if wrongLtr == 0 {
                
                loss += 1
                lossesCount?.text = String( loss )
                word.isHidden   = false
                btnNo.isHidden  = false
                btnYes.isHidden = false
                
                for remainingButton in allKeyButtons {
                    
                    if !guessedLetters.contains( remainingButton.titleLabel?.text?.uppercased().first ?? Character("") ) {
                        
                        if remainingButton.titleColor( for: .normal ) == UIColor.black {
                            
                            remainingButton.setTitleColor( .lightGray, for: .normal )
                            remainingButton.isEnabled = false
                            
                        }
                    }
                }
            }
        }

        if Set( guessedLetters ) == Set( currentWord ) {
            
            let imahe = [ imgBoiGrimmerFin, imgBoiGrimmerLvl3, imgBoiGrimmerLvl2, imgBoiGrimmerLvl1 ]
            
            print( "Fudge! you've guessed the word!" )
            
            win += 1
            print( "YOU WIN : ", win )
            
            countWins?.text = String( win )
            
            grimmerCry.isHidden = false
            boiDead.isHidden = false
            secBtnYes.isHidden  = false
            secBtnNo.isHidden = false
            
            for image in imahe {
                image?.isHidden = true
            }
            
            for remainingButton in allKeyButtons {
                
                if !guessedLetters.contains( remainingButton.titleLabel?.text?.uppercased().first ?? Character("") ) {
                    
                    remainingButton.isEnabled = false
                    remainingButton.setTitleColor( .lightGray, for: .normal )
                    
                }
            }
        }
    }
    
    func resetGame() {
        
        let randomIndex = Int.random( in: 0..<SevenLetterWord.count )
            currentWord = SevenLetterWord[ randomIndex ].uppercased()
            guessedLetters.removeAll()
            updateLettersLabel()

        for subview in view.subviews {
            
            if let button = subview as? UIButton {
                
                resetButtonAppearance( button )
                
            }
        }
        
        
        let imaheArray: [ UIImageView ] = [ imgTrees, imgBoiGrimmerLvl1, imgBoiGrimmerLvl2, imgBoiGrimmerFin, imgBoiGrimmerLvl3 ]
        
        for imageView in imaheArray {
            
            imageView.isHidden = true
            
        }
        
        wrongLtr = 5
        resetScore()
        
    }
    
    
    func resetButtonAppearance(_ button: UIButton) {
    
        button.backgroundColor = UIColor.clear
        button.setTitleColor( .black, for: .normal )
        
        button.isEnabled    = true
        btnNo.isHidden      = true
        btnYes.isHidden     = true
        grimmerCry.isHidden = true
        boiDead.isHidden    = true
        secBtnYes.isHidden  = true
        secBtnNo.isHidden   = true
        
        
    }
    
    func updateLettersLabel() {
        
        let guessedWord = currentWord.map { guessedLetters.contains( $0 ) ? "\( $0 )" : "_" }.joined()
        word.text       = currentWord
        blurdWord.text  = currentWord
        
        let labels = [ firstLetter, secondLetter, thirdLetter, fourthLetter, fifthLetter, sixthLetter, seventhLetter ]
        
        for ( index, label ) in labels.enumerated() {
            
            if index < guessedWord.count {
                
                let letter = guessedWord[ guessedWord.index( guessedWord.startIndex, offsetBy: index ) ]
                label?.text = String( letter )
                
            } else {
                
                label?.text = ""
                
            }
        }
    }
    
    func resetScore() {
        
        print( "Number of buttons: \( allKeyButtons.count )" )
        for button in allKeyButtons {
            print( "Button title: \( button.titleLabel?.text ?? "No title" )" )
        }
        
    }
    

    func setupButtons() {
        
        for tag in 0...26 {
            
            if let button = view.viewWithTag( tag ) as? UIButton {
                
                allKeyButtons.append( button )
                
            }
        }
    }
    
    
    
    @IBAction func btnNo(_ sender: UIButton ) {
        
        thankYou.isHidden   = false
        gameOver.isHidden   = false
        btnYes.isEnabled    = false
        btnExit.isHidden    = false
        secBtnYes.isEnabled = false
        
    }
    
    
    @IBAction func btnExit(_ sender: UIButton) {
        
        dismiss( animated: true )
        
    }
    
}
