//
//  ViewController.swift
//  View_Life_Cycle
//
//  Created by 양중창 on 2019/11/19.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let mainView : String = "Main_View"
     @IBOutlet weak var label: UILabel!
    var finishThisView : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Count.firstView += 1
        
        label.text = """
        Main View : \(Count.firstView) | Second View : \(Count.secondView) | Third View \(Count.thirdView)
        """
        
        print("\(mainView) : viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
  
    
    @IBAction func goSecondView(_ sender: Any) {
        
        let secondView = self.storyboard?.instantiateViewController(identifier: "secondView")
        
        secondView?.modalPresentationStyle = .fullScreen
        
        self.present(secondView!, animated: true, completion: nil)
        
        
    }

    @IBAction func goThirdView(_ sender: Any) {
        let thirdView = self.storyboard?.instantiateViewController(identifier: "thirdView")
        
        thirdView?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(thirdView!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func finish(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(mainView) : viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(mainView) : viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(mainView) : viewWilldisappear")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("\(mainView) : viewDidDisappear")
        
    }
    deinit {
        
        Count.firstView -= 1
        print("\(mainView) : deinit")
        
    }


}

