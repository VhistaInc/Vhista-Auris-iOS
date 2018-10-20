//
//  ViewController.swift
//  Auris
//
//  Created by Juan David Cruz Serrano on 10/19/18.
//  Copyright © 2018 Juan David Cruz Serrano. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    let speechRecognizerManager = SpeechRecognizerManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizerManager.askPermission { (authorized) in
            if authorized {
                self.performSegue(withIdentifier: Segues.LandingToHome, sender: nil)
            } else {
                print("UnAuth")
            }
        }
    }


}

