//
//  SecondView.swift
//  View_Life_Cycle
//
//  Created by 양중창 on 2019/11/19.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondView: UIViewController {
    
    let mainView : String = "SecondView"
    
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Count.secondView += 1
        
        label.text = """
        Main View : \(Count.firstView) | Second View : \(Count.secondView) | Third View \(Count.thirdView)
        """
        
         print("\(mainView) : viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goMainView(_ sender: Any) {
        
        let mainView = self.storyboard?.instantiateViewController(identifier: "mainView")
        
        mainView?.modalPresentationStyle = .fullScreen
        
        self.present(mainView!, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func finish(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
    @IBAction func goThirdView(_ sender: Any) {
        
        let thirdView = self.storyboard?.instantiateViewController(identifier: "thirdView")
        
        thirdView?.modalPresentationStyle = .fullScreen
        
        self.present(thirdView!, animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(mainView) : viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(mainView) : viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(mainView) : viewWilldisappear")
        
        label.text = "^^"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("\(mainView) : viewDidDisappear")
       
    }
    deinit {
        Count.secondView -= 1
        print("\(mainView) : deinit")
        
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
