//
//  CurrentForecastCell.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

final class CurrentForecastCell: UITableViewCell {
  
  private enum UI {
    static let xPadding: CGFloat = 10
    static let yPadding: CGFloat = 6
  }
  
  // MARK: - Properties
  
  private let weatherImageView = UIImageView().then {
    $0.frame = CGRect.make(16, 16, 40, 40)
    $0.contentMode = .scaleAspectFit
  }
  private let statusLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 24, weight: .light)
  }
  private let tempMinMaxLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 22, weight: .light)
  }
  private let currentTempLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 120, weight: .ultraLight)
  }
  
  // MARK: - Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    separatorInset.left = .screenWidth
    contentView.addSubviews(
      weatherImageView, statusLabel, tempMinMaxLabel, currentTempLabel
    )
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setupLayout() {
    statusLabel.width = .screenWidth
    statusLabel.height = "1".size(with: statusLabel.font!).height
    statusLabel.x = weatherImageView.maxX + UI.xPadding
    statusLabel.y = weatherImageView.maxY - statusLabel.height
    
    tempMinMaxLabel.x = weatherImageView.x + UI.xPadding
    tempMinMaxLabel.y = weatherImageView.maxY + UI.yPadding
    tempMinMaxLabel.width = .screenWidth
    tempMinMaxLabel.height = "1".size(with: tempMinMaxLabel.font!).height
    
    currentTempLabel.x = tempMinMaxLabel.x
    currentTempLabel.y = tempMinMaxLabel.maxY - UI.yPadding
    currentTempLabel.width = .screenWidth
    currentTempLabel.height = "1".size(with: currentTempLabel.font!).height
  }
  
  // MARK: - Configure Cell
  
  func configureCell(
    weatherImageName: String,
    weatherStatus: String,
    minMaxTemp: String,
    currentTemp: String
    ) {
    weatherImageView.image = UIImage(named: weatherImageName)
    statusLabel.text = weatherStatus
    tempMinMaxLabel.text = minMaxTemp
    currentTempLabel.text = currentTemp
  }
}
