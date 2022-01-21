//
//  DatePickerTextFieldTableViewCell.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 21/01/2022.
//

import UIKit

protocol DatePickerDelegate: class {
    func didSelectDate(_ date: Date)
}

class DatePickerTextFieldTableViewCell: TextFieldTableViewCell {
    
    weak var delegate: DatePickerDelegate?
    
    fileprivate let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(handleDateChange), for: .valueChanged)
        
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
    
    @objc fileprivate func handleDateChange() {
        textField.text = "\(datePicker.date)"
        delegate?.didSelectDate(datePicker.date)
    }
    
    @objc fileprivate func handleDismiss() {
        textField.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
