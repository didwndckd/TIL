//
//  ViewController.swift
//  Task_191203
//
//  Created by 양중창 on 2019/12/03.
//  Copyright © 2019 didwndckd. All rights reserved.
//

/*
 - FirstVC 에 Dog, Cat, Bird 라는 이름의 Button을 3개 만들고 숫자를 표시하기 위한 Label 하나 생성
 - SecondVC 에 UIImageView 하나와 Dismiss 를 위한 버튼 하나 생성
 - FirstVC에 있는 버튼 3개 중 하나를 누르면 그 타이틀에 맞는 이미지를 SecondVC의 ImageView 에 넣기
   (이미지는 구글링 등을 통해 활용)
 - 각 버튼별로 전환 횟수를 세서 개는 8회, 고양이는 10회, 새는 15회가 초과되면 화면이 전환되지 않도록 막기
   (전환 횟수가 초과된 버튼은 그것만 막고, 횟수가 초과되지 않은 버튼으로는 전환 가능)
 - SecondVC에 추가로 UIButton 을 하나 생성하여 그 버튼을 누를 때마다 개와 고양이, 새 모두에 대해 전환 횟수가 각각 1회씩 추가되도록 구현
 */

import UIKit

class ViewController: UIViewController {
    
    var animal: (dog: Int , cat: Int, bird: Int) = (0,0,0){
        willSet{
            label.text = "Dog: \(newValue.dog), Cat: \(newValue.cat), Bird:\(newValue.bird)"
        }
    }


    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        
        // 세그에 해당하는 identifier를 확인 하고 횟수의 제한을 걸어준다
        // false 를 리턴하게되면 prepare 메서드를 호출 하지 않는다.
        // 때문에 화면전환이 되지 않는다.
        if identifier == "Dog" {
            return animal.dog < 8
        }else if identifier == "Cat" {
            return animal.cat < 10
        }else {
            return false
        }
        
        
    }
    
    
    
    // 세그를 받아서 처리하는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        /*
         destination:세그의 목적지이다 현재 뷰 컨트롤러에서 가고자하는 뷰 컨트롤러
         source: 세그를 보내는쪽임
         identifier: 세그의 식별자
         */
        guard  let secondVC = segue.destination as? SecondViewController else {return}
        
        switch segue.identifier {
        case "Dog": // 세그가 Dog이면 +1
            
            secondVC.image = "dog_image"
            
            
        case "Cat": // 세그가 Cat이면 +1
            
            secondVC.image = "cat_image"
            
        case "Bird": // 세그가 Bird 이면 +1
            
            secondVC.image = "bird_image"
            
        default:
            print("default")
        }
        
        
    }
    
    @IBAction func didTapBird(_ sender: Any) {
        
        if animal.bird < 15 {
            performSegue(withIdentifier: "Bird", sender: sender)
        }
        
    }
    
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        super.unwind(for: unwindSegue, towards: subsequentVC)
        print("sss")
    }
    
    @IBAction func unwindToFirstViewController(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        
        guard let source = sourceViewController as? SecondViewController else {return}
        
        if source.image == "dog_image" {
            animal.dog += 1
        }else if source.image == "cat_image" {
            animal.cat += 1
        }else if source.image == "bird_image" {
            animal.bird += 1
        }
        
        
    }


}

