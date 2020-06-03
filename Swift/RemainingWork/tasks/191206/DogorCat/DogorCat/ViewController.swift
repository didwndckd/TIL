//
//  ViewController.swift
//  DogorCat
//
//  Created by 양중창 on 2019/12/06.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let image = UIImageView()
    let label = UILabel()
    let switchButton = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUI()
        
        
    }

    
    
    func setUI () {
        
        image.frame = CGRect(x: 15, y: 40, width: view.frame.size.width - 30, height: 300 )
        view.addSubview(image)
        
        print(UserDefaults.standard.bool(forKey: "isbool"))
        switchButton.setOn(UserDefaults.standard.bool(forKey: "isbool"), animated: false)
        
        
        label.frame.size = CGSize(width: 100, height: 50)
        label.center.x = view.center.x
        label.center.y = image.center.y + 200
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        view.addSubview(label)
        
        switchButton.frame.size = CGSize(width: 80, height: 40)
        switchButton.center = view.center
        switchButton.addTarget(self, action: #selector(didTapSwitch(_:)), for: .touchUpInside)
        view.addSubview(switchButton)
        
        if switchButton.isOn {
            image.image = UIImage(named: "dog")
            label.text = "Dog"
        }else {
            image.image = UIImage(named: "cat")
            label.text = "Cat"
        }
        
        
        
        
        
    }
    
    @objc func didTapSwitch(_ sender: UISwitch) {
        
            UserDefaults.standard.set(sender.isOn, forKey: "isbool")
        print(UserDefaults.standard.bool(forKey: "isbool"))
        
        if sender.isOn {
            image.image = UIImage(named: "dog")
            label.text = "Dog"
        }else {
            image.image = UIImage(named: "cat")
            label.text = "Cat"
        }
        
    }
    
    
    

}

