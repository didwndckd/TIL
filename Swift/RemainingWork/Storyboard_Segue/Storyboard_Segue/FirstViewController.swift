//
//  ViewController.swift
//  Storyboard_Segue
//
//  Created by 양중창 on 2019/12/03.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var count = 0 
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    // return이 true 이면 화면전환 가능 , false 이면 화면전환 불가
    // 왜냐하면 버튼을 누르는 순간 반응을 하기 때문에 세그를 확인한다
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        
        print("슈드 세그")
        
//        if identifier == "Card" && count+1 <= 40 {
//            return true
//        }else if identifier == "FullScrean" && count+10 <= 40 {
//            return true
//        }else {
//            return false
//        }
        
        let plus = identifier == "Card" ? 1 : 10
        return count + plus < 40
    }
    
    
    
    // 스토리보드에서 화면 전환 과정에서 어떠한 작업을 할 수 있도록 해주는 제공 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
//        segue.destination 목적지
//        segue.identifier 식별자
//        segue.source 출발지
        print("프리페어")
        guard let secondVC = segue.destination as? SecondViewController else{return}
        
        if segue.identifier == "Card" {
          
            secondVC.count = count + 1
            
        }else if segue.identifier == "PlusFive"{
            
            secondVC.count = count + 5
            
            
        }else {
            
            secondVC.count = count + 10
        }
        
        
    }
    
    @IBAction func didTapPlusFive(_ sender: Any) {
        if count < 20 { // count가 20보다 작아야 세그를 다음으로 지정한다.endd
        performSegue(withIdentifier: "PlusFive", sender: 1)
        // shouldperform 호출 안함 왜냐하면 이미 세그를 정해 놨기 때문에
        }
    }
    
    
    @IBAction func unwindToFirstViewController(_ unwindSegue: UIStoryboardSegue) {
        let source = unwindSegue.source
//        let destination = unwindSegue.destination
        
        
        guard let secondVC = source as? SecondViewController else{return}
        
        if let param = secondVC.textField.text, let param2 = Int(param) {
            
            count = secondVC.count - param2
            label.text = "\(count)"
        }else {
            count = secondVC.count
            label.text = "\(count)"
        }
        
        
    }


}

