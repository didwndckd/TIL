//
//  ShortRangeForecastCell.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

final class ShortRangeForecastCell: UITableViewCell {
  
  private enum UI {
    static let leftMargin: CGFloat = 16
    static let rightMargin: CGFloat = 16
    static let xPadding: CGFloat = 10
    static let yPadding: CGFloat = 4
    
    static let weatherImageSize: CGFloat = 40
  }
  
  // MARK: - Properties
  
  private let dateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .light)
    $0.textColor = .white
  }
  private let timeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 22, weight: .regular)
    $0.textColor = .white
  }
  private let weatherImageView = UIImageView().then {
    let size = UI.weatherImageSize
    $0.size = CGSize(width: size, height: size)
    $0.contentMode = .scaleAspectFit
  }
  private let temperatureLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 40, weight: .thin)
  }
  
  // MARK: - Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    contentView.addSubviews(
      dateLabel, timeLabel, weatherImageView, temperatureLabel
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dateLabel.sizeToFit()
    dateLabel.x = UI.leftMargin
    dateLabel.center.y = (height - dateLabel.height) / 2 - UI.yPadding
    
    timeLabel.sizeToFit()
    timeLabel.x = dateLabel.x
    timeLabel.y = dateLabel.maxY
    
    weatherImageView.x = (width / 2) + UI.xPadding
    weatherImageView.center.y = height / 2
    
    let leftInset = center.x + UI.xPadding
    let rightInset = width - leftInset - UI.weatherImageSize
    separatorInset = UIEdgeInsets(
      top: 0, left: leftInset, bottom: 0, right: rightInset
    )
    
    temperatureLabel.sizeToFit()
    temperatureLabel.x = width - temperatureLabel.width - UI.rightMargin
    temperatureLabel.center.y = height / 2
  }
  
  // MARK: - Configure Cell
  
  func configureCell(
    date: String,
    time: String,
    imageName: String,
    temperature: String
    ) {
    dateLabel.text = date
    timeLabel.text = time
    weatherImageView.image = UIImage(named: imageName)
    temperatureLabel.text = temperature
  }
}
