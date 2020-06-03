//
//  NameWSViewController.swift
//  SlackNewWorkspaceUI
//
//  Created by giftbot on 2020/01/07.
//  Copyright © 2020 giftbot. All rights reserved.
//

import AudioToolbox.AudioServices
import UIKit

final class NameWSViewController: UIViewController {
  
  // MARK: Properties
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("None", for: .normal)
    button.setTitle("Next", for: .selected)
    button.setTitleColor(.lightGray, for: .normal)
    button.setTitleColor(.init(red: 18/255, green: 90/255, blue: 153/255, alpha: 1.0), for: .selected)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
    return button
  }()
  
  private let closeButton: UIButton = {
    let button = UIButton()
    let closeImage = UIImage(systemName: "xmark")
    button.setImage(closeImage, for: .normal)
    button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
    return button
  }()
  
  private let wsNameTextField: UITextField = {
    let textField = UITextField()
    let attrString = NSAttributedString(
      string: "Name your workspace",
      attributes: [.foregroundColor: UIColor.darkText.withAlphaComponent(0.5)]
    )
    textField.attributedPlaceholder = attrString
    textField.font = UIFont.systemFont(ofSize: 22, weight: .light)
    textField.enablesReturnKeyAutomatically = true // 텍스트필드에 텍스트가 없을때 return키를 비활성화 한다
    textField.borderStyle = .none
    textField.returnKeyType = .go // return키를 어떤식으로 보여줄 지 결정
    textField.autocorrectionType = .no // 자동수정기능 사용할지 말지 결정
    textField.autocapitalizationType = .none // shift키가 자동으로 눌리는 방식을 지정
    return textField
  }()
  
  private let floatingLabel: UILabel = {
    let label = UILabel()
    label.text = "Name your workspace"
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.alpha = 0.0
    return label
  }()
  private var floatingCenterYConst: NSLayoutConstraint!
  
  private let indicatorView: UIActivityIndicatorView = { //-> 프로그레스바
    let indicatorView = UIActivityIndicatorView(style: .medium)
    indicatorView.hidesWhenStopped = true // 프로그레스바가 돌아가지 않을때는 hidden상태로 한다
    return indicatorView
  }()
  private var indicatorViewLeadingConst: NSLayoutConstraint!
  
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    wsNameTextField.becomeFirstResponder()
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubviews([nextButton, closeButton])
    view.addSubviews([wsNameTextField, floatingLabel, indicatorView])
    
    navigationController?.navigationBar.isHidden = true
    wsNameTextField.delegate = self
  }
  
  private func setupConstraints() {
    nextButton.layout.top().trailing(constant: -16)
    closeButton.layout.leading(constant: 16).centerY(equalTo: nextButton.centerYAnchor)
    wsNameTextField.layout.leading(constant: 16).trailing(constant: -16).centerY(constant: -115)
    
    // Floating Label
    floatingLabel.layout.leading(equalTo: wsNameTextField.leadingAnchor)
    
    let defaultCenterYConst = floatingLabel.centerYAnchor.constraint(equalTo: wsNameTextField.centerYAnchor)
    defaultCenterYConst.priority = UILayoutPriority(500) // 우선순위를 줘서 디폴트 상태에는 텍스트필드의 가운데 위치
    defaultCenterYConst.isActive = true
    
    floatingCenterYConst = floatingLabel.centerYAnchor.constraint(equalTo: wsNameTextField.centerYAnchor, constant: -30)
    floatingCenterYConst.priority = .defaultLow   // 250 // 우선순위를 낮게 줘서 디퐅트 상태에는 무시하다가
                                                         // 우선순위를 올리면 텍스트필드의 위로 이동
    floatingCenterYConst.isActive = true
    
    // indicatorView
    indicatorView.layout.centerY(equalTo: wsNameTextField.centerYAnchor)
    indicatorViewLeadingConst = indicatorView.leadingAnchor.constraint(equalTo: wsNameTextField.leadingAnchor) // 프로스레스바의 위치를 텍스트필드의 leadingAnchor에 맞춘다
    indicatorViewLeadingConst.isActive = true
  }
  
  
  // MARK: - Action Handle
  
  // import AudioToolbox.AudioServices
  private func vibrate() {
    //핸드폰에 진동주는 함수
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }
  
  @objc private func didTapNextButton(_ sender: UIButton) {
    guard nextButton.isSelected, let text = wsNameTextField.text else { return vibrate() }
    // 버튼의 상태가 selected 상태일 경우 넘어가고 텍스트필드의 텍스트가 nil이 아니면 넘어가고 아닐경우 핸드폰에 진동
    guard !indicatorView.isAnimating else { return }
    // 프로그레스바가 돌아가지 않고 있을때
    
    let textSize = (text as NSString).size(withAttributes: [.font: wsNameTextField.font!])
    // 텍스트의 사이즈를 구해서 프로스레스바의 leadingAnchor의 constant로 넣어준다 (+ margin 8 추가)
    indicatorViewLeadingConst.constant = textSize.width + 8
    indicatorView.startAnimating()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1 초후 실행되는 코드( 비동기로 실행된다 )
       self.indicatorView.stopAnimating()
       let vc = UrlWSViewController()
       vc.workspaceName = text
       self.navigationController?.pushViewController(vc, animated: true)
     }
  }
  
  @objc private func didTapCloseButton(_ sender: UIButton) {
    dismiss(animated: true)
  }
}


// MARK: - UITextFieldDelegate

extension NameWSViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTapNextButton(nextButton)
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let text = textField.text ?? ""
    let replacedText = (text as NSString).replacingCharacters(in: range, with: string)
    //textField의 text를 보다 정확하게 뽑아낼 수 있음
    
    nextButton.isSelected = !replacedText.isEmpty
    print(replacedText)
    print("rang: ", range.location, "with: ", string)
    
    
    UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
        // 텍스트 필드 안에 있는 텍스트 레이블 위로 올리면서 알파값 1로 설정해서 보이게 하는 애니메이션
      if replacedText.isEmpty {
        self.floatingCenterYConst.priority = .defaultLow
        self.floatingLabel.alpha = 0.0
      } else {
        self.floatingCenterYConst.priority = .defaultHigh
        self.floatingLabel.alpha = 1.0
      }
      self.view.layoutIfNeeded()
    })
    return true
  }
}
