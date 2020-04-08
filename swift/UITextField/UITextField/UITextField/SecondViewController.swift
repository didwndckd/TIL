//
//  SecondViewController.swift
//  UITextField
//
//  Created by 양중창 on 2019/11/26.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController {

    var count = 0{
        didSet{
            label.text = "\(count)"
        }
    }
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func alert(_ sender: Any) {
        
        let alertController = UIAlertController(title: "계산", message: "뭐할래?", preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addTextField() {_ in
            
        }
        
        let edit = UIAlertAction(title: "edit", style: .default) {
            _ in
            print(alertController.textFields)
            guard let edit = alertController.textFields?[0] else {return}
            guard let editText = edit.text else {return}
            self.count = Int(editText)!
        }
        
        let add = UIAlertAction(title: "add", style: .default) {
            _ in
            self.count += 1
            //self.label.text = String(self.count)
        }
        let sub = UIAlertAction(title: "sub", style: .default) {
            _ in
            self.count -= 1
            //self.label.text = String(self.count)
        }
        let reset = UIAlertAction(title: "reset", style: .destructive) {
            _ in
            self.count = 0
            //self.label.text = String(self.count)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        alertController.addAction(edit)
        alertController.addAction(add)
        alertController.addAction(sub)
        alertController.addAction(reset)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("뷰 윌 어피어")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("뷰 디드 어피어")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("뷰 윌 디스어피어")
    }
}
