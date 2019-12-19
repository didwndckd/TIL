//
//  CustomCell.swift
//  BasicTableView
//
//  Created by Giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
  
  let myLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // 커스텀 뷰를 올릴 때는 contentView 위에 추가
    contentView.addSubview(myLabel)
    myLabel.textColor = .black
    myLabel.backgroundColor = .yellow
    
//    myLabel.frame = CGRect(x: frame.width - 120, y: 15, width: 100, height: frame.height - 30)
//  init 에서는 아직 cell의 frame이 잡혀있지 않기때문에 이 시점에서는 자기자신의 frame을 사용할 수 없다
//    오토레이아웃은 가능
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    
    // 오토레이아웃 설정 시점
//    override func updateConstraints() {
//          super.updateConstraints()
//    }
  
  // 레이아웃 조정 시
  override func layoutSubviews() {
    super.layoutSubviews()
    
//    myLabel.frame = CGRect(x: frame.width - 120, y: 15, width: 100, height: frame.height - 30)
  }
}
