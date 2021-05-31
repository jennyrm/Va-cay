//
//  AddActivityViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/28/21.
//

import UIKit

class AddActivityViewController: UIViewController {
    
    //MARK: - Properties
    var activityCounter = 1
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var activitiesArray = [UITextField]()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Methods
    func createCalendarStackView() {
        let label = UILabel()
        label.text = "Use the calendar to choose a date"
        label.textColor = .systemGray4
        label.layer.borderWidth = 1.0
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(showCalendarButtonAction), for: .touchUpInside)
        
        self.view.addSubview(label)
        self.view.addSubview(button)
        self.view.addSubview(calendarStackView)
        
        calendarStackView.addArrangedSubview(label)
        calendarStackView.addArrangedSubview(button)
    }
    
    func createAddActivityStackView() {
        let label = UILabel()
        label.text = "Add Activity"
        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addActivityButtonAction), for: .touchUpInside)
        
        self.view.addSubview(label)
        self.view.addSubview(button)
        self.view.addSubview(addActivityStackView)
        
        addActivityStackView.addArrangedSubview(label)
        addActivityStackView.addArrangedSubview(button)
    }
    
    func createScrollableStackView() {
        self.view.addSubview(scrollView)
        self.view.addSubview(scrollableStackView)
        
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Enter activity here or use the map"
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        activitiesArray.append(textField)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "mappin"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = activityCounter
        button.addTarget(self, action: #selector(showMapButtonAction), for: .touchUpInside)
        
        let textFieldButtonStackView = UIStackView()
        textFieldButtonStackView.axis = .horizontal
        textFieldButtonStackView.alignment = .fill
        textFieldButtonStackView.distribution = .fillProportionally
        textFieldButtonStackView.spacing = 0
        textFieldButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(textField)
        self.view.addSubview(button)
        self.view.addSubview(textFieldButtonStackView)
        
        textFieldButtonStackView.addArrangedSubview(textField)
        textFieldButtonStackView.addArrangedSubview(button)
        
        scrollableStackView.addArrangedSubview(textFieldButtonStackView)
        scrollView.addSubview(scrollableStackView)
    }
    
    func createEstimatedCostStackView() {
        let label = UILabel()
        label.text = "Estimated Cost of Activities"
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = UITextField()
        textField.borderStyle = .bezel
        
        self.view.addSubview(label)
        self.view.addSubview(textField)
        self.view.addSubview(estimatedCostStackView)
        
        estimatedCostStackView.addArrangedSubview(label)
        estimatedCostStackView.addArrangedSubview(textField)
    }
    
    func createFooterButtonsStackView() {
        let addDayButton = UIButton()
        addDayButton.setTitle("Add Day", for: .normal)
        addDayButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        addDayButton.layer.cornerRadius = 35.0
        addDayButton.addTarget(self, action: #selector(clearAllInput), for: .touchUpInside)
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        
        let submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        submitButton.layer.cornerRadius = 35.0
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addDayButton)
        self.view.addSubview(submitButton)
        self.view.addSubview(footerButtonsStackView)
        
        footerButtonsStackView.addArrangedSubview(addDayButton)
        footerButtonsStackView.addArrangedSubview(submitButton)
    }
    
    @objc func showCalendarButtonAction(sender: UIButton) {
        switch sender.tag {
        default:
            self.performSegue(withIdentifier: "toCalendarVC", sender: sender)            
        }
    }
    
    @objc func addActivityButtonAction() {
        activityCounter += 1
        setupScrollableStackViewConstraints()
    }
    
    @objc func showMapButtonAction(sender: UIButton) {
        switch (sender.tag) {
        default:
            self.performSegue(withIdentifier: "toMapVC", sender: sender)
        }
    }
    
    @objc func clearAllInput() {
        for textfield in activitiesArray {
            textfield.text = ""
        }
    }
    
    func setupConstraints() {
        self.view.addSubview(dayLabel)
        createCalendarStackView()
        createAddActivityStackView()
        createEstimatedCostStackView()
        createFooterButtonsStackView()
        
        dayLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor, constant: 100).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 150).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -150).isActive = true
        
        calendarStackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        calendarStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 32).isActive = true
        calendarStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -32).isActive = true
        
        addActivityStackView.topAnchor.constraint(equalTo: calendarStackView.bottomAnchor, constant: 32).isActive = true
        addActivityStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 100).isActive = true
        addActivityStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -100).isActive = true
        
        setupScrollableStackViewConstraints()
        
        estimatedCostStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32).isActive = true
        estimatedCostStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 32).isActive = true
        estimatedCostStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -32).isActive = true
        
        footerButtonsStackView.topAnchor.constraint(equalTo: estimatedCostStackView.bottomAnchor, constant: 32).isActive = true
        footerButtonsStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 140).isActive = true
        footerButtonsStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -140).isActive = true
        footerButtonsStackView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor, constant: -32).isActive = true
    }
    
    func setupScrollableStackViewConstraints() {
        createScrollableStackView()
        
        scrollView.topAnchor.constraint(equalTo: addActivityStackView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 32).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -32).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor, constant: -300).isActive = true
        
        scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollableStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollableStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    //MARK: - Views
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var addActivityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var scrollableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var estimatedCostStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var footerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
}//End of class

