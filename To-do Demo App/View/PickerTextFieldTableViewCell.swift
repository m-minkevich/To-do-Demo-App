//
//  PickerTextFieldTableViewCell.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 21/01/2022.
//

import UIKit

protocol PickerDelegate: class {
    func didSelectItem(_ item: String)
}

class PickerTextFieldTableViewCell: TextFieldTableViewCell {
    
    weak var delegate: PickerDelegate?
    
    var items = [String]()

    fileprivate let picker = UIPickerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.inputView = picker
        
        picker.delegate = self
        picker.dataSource = self
        
        setupToolbar()
    }
    
    fileprivate func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let fillerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Gotowe", style: .done, target: self, action: #selector(handleDismiss))
        toolbar.setItems([fillerButton, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc fileprivate func handleDismiss() {
        textField.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PickerTextFieldTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        textField.text = items[row]
        delegate?.didSelectItem(items[row])
    }
    
}
