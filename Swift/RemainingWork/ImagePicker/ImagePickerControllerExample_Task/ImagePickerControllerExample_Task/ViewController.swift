//
//  ViewController.swift
//  ImagePickerControllerExample_Task
//
//  Created by 양중창 on 2020/01/06.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    private let imagePicker = UIImagePickerController()
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isToolbarHidden = false
        toolbarItems = makeToolbarItems()
        setImageView()
        imagePicker.delegate = self
//        navigationController?.delegate = self
        
    }
    
    
    
    private func makeToolbarItems() -> [UIBarButtonItem] {
        
        let album = UIBarButtonItem(title: "앨범", style: .done, target: self, action: #selector(didTapAlbum))
        let camera = UIBarButtonItem(title: "카메라", style: .done, target: self, action: #selector(didTapCamera))
        let delay = UIBarButtonItem(title: "딜레이촬영", style: .done, target: self, action: #selector(didTapDelay))
        let movie = UIBarButtonItem(title: "동영상", style: .done, target: self, action: #selector(didTapMovie))
        let changeEditing = UIBarButtonItem(title: "Editing", style: .done, target: self, action: #selector(didTapEditing))
        
        return [album, camera, delay, movie, changeEditing]
        
    }
    
    @objc private func didTapAlbum() {
        //앨범에서 사진 픽
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func didTapCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        //카메라 사용 가능한지 체크
        //사진 촬영
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
//        let mediaType = UIImagePickerController.availableMediaTypes(for: .camera)
//        imagePicker.mediaTypes = mediaType ?? []
        present(imagePicker, animated: true)
        
    }
    
    @objc private func didTapDelay() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        //카메라 사용 가능한지 체크
        //사진 딜레이 촬영
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.imagePicker.takePicture()
            })
        }
        
    }
    
    @objc private func didTapMovie() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        //카메라 사용 가능한지 체크
        //동영상촬영
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        present(imagePicker, animated: true)
        
    }
    
    @objc private func didTapEditing() {
        //이미지 편집 기능 켜기 끄기
        imagePicker.allowsEditing.toggle()
        editButtonItem.title = imagePicker.allowsEditing ? "E/ON" : "E/OFF"
    }
    
    func setImageView() {
        view.addSubview(imageView)
        let guide = view.safeAreaLayoutGuide
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }

}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! NSString
        print(mediaType)
        
        if UTTypeEqual(mediaType, kUTTypeImage){
        
            // 기본 오리지널 이미지
            let originImage = info[.originalImage] as! UIImage
            
            //편집한 이미지 일때
            let editedImage = info[.editedImage] as? UIImage
            
            let selectImage = editedImage ?? originImage
            
            imageView.image = selectImage
            
            if picker.sourceType == .camera {
                //카메라일 경우 찍은 사진을 앨범에 저장
                UIImageWriteToSavedPhotosAlbum(selectImage, nil, nil, nil)
            }
        
        }else if UTTypeEqual(mediaType, kUTTypeMovie){
           //동영상을 앨범에 저장
            if let mediaPath = (info[.mediaURL] as? NSURL)?.path,
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaPath) {
                UISaveVideoAtPathToSavedPhotosAlbum(mediaPath, nil, nil, nil)
            }
          
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
}
