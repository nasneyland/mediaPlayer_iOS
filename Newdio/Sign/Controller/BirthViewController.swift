//
//  BirthViewController.swift
//  Newdio
//
//  Created by 박지영 on 2021/11/01.
//

import UIKit
import AnyFormatKit
import SnapKit

class BirthViewController: InputViewController {
    
    //MARK: - Properties
    
    var user: User!
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.addLeftPadding()
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .newdioGray4
        textField.textColor = .newdioGray2
        textField.placeholder = "YYYY-MM-DD"
        return textField
    }()
    
    lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.textColor = .newdioGray1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "social_login_recommended_news".localized()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .newdioRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "social_login_incorrect_date_format".localized()
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    //MARK: - Configure
    
    private func configureUI() {
        titleLabel.text = "social_login_birth".localized()
        
        inputButton.isHidden = true
        inputTextField.delegate = self
        
        nextButton.setTitle("common_next".localized(), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        disabledButton()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.height.equalTo(48)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(inputTextField.snp.bottom).offset(8)
        }
        
        nextButton.snp.updateConstraints { make in
            make.top.equalTo(inputButton.snp.bottom).offset(49)
        }
    }
    
    //MARK: - Helpers
    
    @objc func didTapNext() {
        user.birthday = inputTextField.text
        
        let vc = GenderViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - TextField Delegate

extension BirthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return false
        }
        
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        let formatter = DefaultTextInputFormatter(textPattern: "####-##-##")
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        textField.textColor = .newdioWhite
        textField.text = result.formattedText
        let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        
        //정규표현식 평가하기
        let pattern = "^(19|20)\\d\\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$"
        
        if(inputTextField.text?.range(of: pattern, options: .regularExpression) == nil){
            errorLabel.textColor = UIColor.newdioRed
            errorLabel.text = "social_login_incorrect_date_format".localized()
            disabledButton()
        } else{
            errorLabel.textColor = UIColor.newdioMain
            errorLabel.text = "social_login_correct_date_format".localized()
            enabledButton()
        }
        return false
    }
}
