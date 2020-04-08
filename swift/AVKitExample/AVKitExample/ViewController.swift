//
//  ViewController.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/19.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import AVKit

class ViewController: UIViewController {
    
    private let nextButton = UIButton(type: .system)
    
    private let scrollView = UIScrollView()
    
    
    private let starURL =  "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/%E1%84%89%E1%85%A6%E1%86%AB%E1%84%90%E1%85%A5%E1%84%85%E1%85%B3%E1%86%AF+%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9+300%E1%84%80%E1%85%A2%E1%84%85%E1%85%A9+%E1%84%81%E1%85%AA%E1%86%A8%E1%84%81%E1%85%AA%E1%86%A8+%E1%84%8E%E1%85%A2%E1%84%8B%E1%85%AE%E1%84%86%E1%85%A7%E1%86%AB+%E1%84%89%E1%85%A2%E1%86%BC%E1%84%80%E1%85%B5%E1%84%82%E1%85%B3%E1%86%AB+%E1%84%8B%E1%85%B5%E1%86%AF.mp4"
    
    private let dogURL = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/videoplayback.mp4"
    
    private let shortURL = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/mov_bbb.mp4"
    
    private let views = [UIView(), UIView(), UIView(), UIView()]
    private let colors = [UIColor.red, UIColor.blue, UIColor.gray, UIColor.green]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraint()
//        setScrollView()
        
        
        
        
    }
    
    private func setScrollView() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        for (index, view) in views.enumerated() {
            
            scrollView.addSubview(view)
            view.backgroundColor = colors[index]
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let leading = index == 0 ? scrollView.leadingAnchor: views[index - 1 ].trailingAnchor
            view.leadingAnchor.constraint(equalTo: leading).isActive = true
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            if index == views.count - 1 {
                view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
            
        }
        
        
        
    }
    
    private func setUI() {
        
        
        view.addSubview(nextButton)
        
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
    }
    
    private func setConstraint() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    @objc private func didTapNextButton() {
       
        guard let url = URL(string: starURL) else { return print("urlError")}
        let player = AVPlayer(url: url)
        
        let videoController = VideoController()
        videoController.player = player
        
        
        videoController.modalPresentationStyle = .fullScreen
        present(videoController, animated: true) {
            player.play()
        }
        
        
    }


}

