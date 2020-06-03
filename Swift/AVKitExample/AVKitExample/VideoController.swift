//
//  VideoController.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/19.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import AVKit

class VideoController: AVPlayerViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsPlaybackControls = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.player?.pause()
        })
        
    }
    
    
    
    
    
    
    

}
