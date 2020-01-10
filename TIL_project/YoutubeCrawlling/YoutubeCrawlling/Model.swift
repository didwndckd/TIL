//
//  Model.swift
//  YoutubeCrawlling
//
//  Created by 양중창 on 2020/01/08.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var imageUrl: String?
    var title: String?
    var subtitle: String?
    var contentUrl: String?
    
    init(imageUrl: String?, title: String?, subtitle: String?, contentUrl: String?) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.contentUrl = contentUrl
    }
}


class Model {
    
    private let baseUrl = "https://www.youtube.com/results?search_query="
    private var query = "아임뚜렛"
    private var itemList: [Item] = []
    
    
    
    private func crwalling () -> NSString? {
        guard let urlSet = (baseUrl + query).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return nil}
        
        if let url = URL(string: urlSet ) {
            do {
                let contents = try NSString(contentsOf: url, usedEncoding: nil)
                return contents
            }catch {
                print("do error")
            }
        }else {
            print("url is nil")
        }
        
        return nil
    }
    
     func parsing () {
        guard let crwallingValue = crwalling() else { return }
//        print(crwallingValue)
        let contents = setContents(crwallingValue: crwallingValue)
        
        setItemList(contents: contents)
        
        
    }
    
    private func setItemList(contents:[String]) {
        
        for content in contents {
            let imageUrl = getImageUrl(item: content)
            let title = gettitle(item: content)
            print(imageUrl)
            print(title)
        }
        
    }
    
    private func gettitle (item: String) -> String? {
        
        let headCut = "dir=\"ltr\">"
        var tempStr = item.components(separatedBy: headCut)
        tempStr.removeFirst()
        let secondTempStr = tempStr.first?.components(separatedBy: "</a>")
        guard let title = secondTempStr?.first else {return nil}
        
        return title
    }
    
    
    private func getImageUrl (item: String) -> String? {
        
        let headCut = "src=\""
        var tempStr = item.components(separatedBy: headCut)
        tempStr.removeFirst()
        let secondTempStr = tempStr.first?.components(separatedBy: "\"")
        guard let imageUrl = secondTempStr?.first else {return nil}
        
        return imageUrl
    }
    
    private func setContents( crwallingValue: NSString ) -> [String] {
        
        let headCut = "<li><div class=\"yt-lockup yt-lockup-tile yt-lockup-"
        let videoCheck = "video"
        var contents = crwallingValue.components(separatedBy: headCut)
        contents.removeFirst()
        contents.removeLast()
        
        for (index, content) in contents.enumerated() {

           var loop = 0
            var tempVideo = ""
            for (index, char) in content.enumerated() {
                if loop == videoCheck.count-1 {
                    break
                }
                tempVideo += String(char)
                loop = index
            }

            if tempVideo != videoCheck {
                contents.remove(at: index)
            }

        }
        // content 하나씩 완전히 분리함
        print(contents[contents.count - 1])
        return contents
    }
    
    
    
}
