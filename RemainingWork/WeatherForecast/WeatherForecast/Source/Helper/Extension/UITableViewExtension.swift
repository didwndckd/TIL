//
//  UITableViewExtension.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

protocol Identifiable {
  static var identifier: String { get }
}
extension Identifiable {
  static var identifier: String { String(describing: self) }
}
extension UITableViewCell: Identifiable { }


extension UITableView {
  func register<Cell>(
    cell: Cell.Type,
    forCellReuseIdentifier reuseIdentifier: String = Cell.identifier
  ) where Cell: UITableViewCell {
    register(cell, forCellReuseIdentifier: reuseIdentifier)
  }
  
  func dequeue<Cell>(_ reusableCell: Cell.Type) -> Cell where Cell: UITableViewCell {
    if let cell = dequeueReusableCell(withIdentifier: reusableCell.identifier) as? Cell {
      return cell
    } else {
      fatalError("Identifier required")
    }
  }
}

