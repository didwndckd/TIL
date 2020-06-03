//
//  SecondViewController.swift
//  Task_191203
//
//  Created by 양중창 on 2019/12/03.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: image)
        
    }
    
    
    
    @IBAction func didTapAllPlusButton(_ sender: UIButton) {
        
        guard let firstViewController = presentingViewController as? ViewController else {
            return
        }
        if firstViewController.animal.dog < 8
            && firstViewController.animal.cat < 10
            && firstViewController.animal.bird < 15 {
            firstViewController.animal.dog += 1
            firstViewController.animal.cat += 1
            firstViewController.animal.bird += 1
            dismiss(animated: true)
        }
    }
    

  

}
