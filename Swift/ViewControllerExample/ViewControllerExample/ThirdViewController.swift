//
//  ThirdViewController.swift
//  ViewControllerExample
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    let firstButton = UIButton()
    let secondButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        setfirst()
        setSecond()

        // Do any additional setup after loading the view.
    }
    
    func setfirst() {
        firstButton.frame.size = CGSize(width: 100, height: 50)
        firstButton.center.x = view.center.x - 100
        firstButton.center.y = view.center.y
        firstButton.addTarget(self, action: #selector(tapFirst(_:)), for: .touchUpInside)
        firstButton.setTitle("go First", for: .normal)
        view.addSubview(firstButton)
        
    }
    @objc func tapFirst(_ sender: UIButton) {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
//        presentingViewController?.dismiss(animated: true) -> dismiss랑 같은거임(자기 자신)
    }
    
    
    
    func setSecond() {
        
        secondButton.frame.size = CGSize(width: 100, height: 50)
        secondButton.center.x = view.center.x + 100
        secondButton.center.y = view.center.y
        secondButton.setTitle("go Second", for: .normal)
        secondButton.addTarget(self, action: #selector(tapSecond(_:)), for: .touchUpInside)
        view.addSubview(secondButton)
    }
    @objc func tapSecond(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
