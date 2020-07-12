//
//  CustomImagePickerController.swift
//  ImagePickerControllerExample_Task
//
//  Created by 양중창 on 2020/07/12.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import MobileCoreServices

class CustomImagePickerController: UIImagePickerController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setupMediaType()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    
  }
  
  func setupMediaType() {
    self.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
    self.sourceType = .camera
  }
  
  
}

extension CustomImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print(#function)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print(#function)
    self.dismiss(animated: true)
  }
}


