//
//  ViewController.swift
//  HANGMANv.2
//
//  Created by RNLD on 2023-10-21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerName: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    @IBAction func btnStart(_ sender: UIButton) {
        
        let pName = playerName.text ?? ""
        
        if pName == "" {
            playerAlert()
        } else {
            segue()
        }
        
    }
    
    
    private func playerAlert() {
        
        let alert = UIAlertController( title: "Game Denied", message: "Player Name Needed!", preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "OK", style: .default ) )
        present( alert, animated: true, completion: nil )
        
    }
    
    private func segue() {
        
        performSegue( withIdentifier: "GameStart", sender: self )
        playerName.text = ""
        
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        if let pName = playerName {
            
            if let destination = segue.destination as? GameViewController {
                
                destination.playerName = pName.text
                
            }
        }
    }

}

