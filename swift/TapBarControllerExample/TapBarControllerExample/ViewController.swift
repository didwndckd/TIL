//
//  ViewController.swift
//  TapBarControllerExample
//
//  Created by 양중창 on 2019/12/23.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tag = "First"

    override func viewDidLoad() {
        super.viewDidLoad()
       print(tag, "viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(tag, "viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(tag, "viewDidAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(tag, "viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(tag, "viewDidDisappear")
    }
    
    deinit {
        print(tag, "deinit")
    }


}

