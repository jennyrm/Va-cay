//
//  TripQuestionnairePartThreeViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/28/21.
//

import UIKit

class TripQuestionnairePartThreeViewController: UIViewController {
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var dayCounter = 1
    var dateOfActivityLabel: UILabel?
    var activitiesTextFieldItems = [UITextField]()
    var activities = [ [ String : [String] ] ]()
    var placeholderActivities = [String]()
    
    //MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Functions
    func updateView() {
        if let currentDay = ItineraryController.sharedInstance.itineraryData["dateOfActivity"] as? Date {
            dateOfActivityLabel?.text = currentDay.formatToStringWithLongDateAndTime()
        }
        
        if let activities = ItineraryController.sharedInstance.itineraryData["activities"] as? [ [ String : [String] ] ] {
            self.activities = activities
            print("Self.activities:", self.activities)
            updateActivitiesView()
        }
    }
    
    func updateActivitiesView() {
        activities.forEach { activity in
            for (key, value) in activity {
                if key == "Day \(dayCounter)" {
                    if value.isEmpty {
                        updateDay()
                    } else {
                        clearEditedTextFields()
                        value.forEach { placeholderActivities.append($0) }
                        displayActivities(for: key)
                    }
                }
            }
        }
        
        if dayCounter > activities.count {
            updateDay()
        }
        
        placeholderActivities = []
    }
    
    func updateDay() {
        dayLabel.text = "Day \(dayCounter)"
        clearEditedTextFields()
        removeTextFields()
    }
    
    func displayActivities(for day: String) {
        dayLabel.text = day
        for index in 0..<placeholderActivities.count {
            setupScrollableStackViewConstraints()
            activitiesTextFieldItems[index].text = placeholderActivities[index]
        }
    }
    
    func saveActivities() {
        let day = "Day \(dayCounter)"
        
        for (index, activity) in activities.enumerated() {
            for (key, _) in activity {
                if key == "Day \(dayCounter)" {
                    activitiesTextFieldItems.forEach {
                        if !$0.text!.isEmpty {
                            placeholderActivities.append($0.text!)
                        }
                    }
                    activities[index].updateValue(placeholderActivities, forKey: key)
                }
            }
        }
        
        if dayCounter > activities.count {
            activitiesTextFieldItems.forEach {
                if !$0.text!.isEmpty {
                    placeholderActivities.append($0.text!)
                }
            }
            
            activities.append([day : placeholderActivities])
        }
        removeTextFields()
        activitiesTextFieldItems = []
        placeholderActivities = []
    
        ItineraryController.sharedInstance.itineraryData["activities"] = activities
    }
    
    func clearEditedTextFields() {
        activitiesTextFieldItems.forEach { $0.text = "" }
    }
    
    func removeTextFields() {
        let subviews = scrollableStackView.subviews
        for textfield in subviews {
            textfield.removeFromSuperview()
        }
//        addActivityButtonAction()
    }
    
    //MARK: - Programmatic Constraint Functions
    func createCalendarStackView() {
        let label = UILabel()
        label.textColor = .black
        label.layer.borderWidth = 1.0
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        dateOfActivityLabel = label
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        button.tintColor = .systemBlue
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
        label.textAlignment = .center
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .green
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
        activitiesTextFieldItems.append(textField)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        button.addTarget(self, action: #selector(showMapButtonAction), for: .touchUpInside)
        
        let textFieldButtonStackView = UIStackView()
        textFieldButtonStackView.axis = .horizontal
        textFieldButtonStackView.alignment = .fill
        textFieldButtonStackView.distribution = .fillProportionally
        textFieldButtonStackView.spacing = 0
        
        self.view.addSubview(textField)
        self.view.addSubview(button)
        self.view.addSubview(textFieldButtonStackView)
        
        textFieldButtonStackView.addArrangedSubview(textField)
        textFieldButtonStackView.addArrangedSubview(button)
        
        scrollableStackView.addArrangedSubview(textFieldButtonStackView)
        scrollView.addSubview(scrollableStackView)
    }
    
    func createPreviousNextDayButtonStackView() {
        let previousDayButton = UIButton()
        previousDayButton.setTitle("Previous Day", for: .normal)
        previousDayButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        previousDayButton.layer.cornerRadius = 30.0
        previousDayButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
        
        let nextDayButton = UIButton()
        nextDayButton.setTitle("Next Day", for: .normal)
        nextDayButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        nextDayButton.layer.cornerRadius = 30.0
        nextDayButton.addTarget(self, action: #selector(nextDay), for: .touchUpInside)
        
        self.view.addSubview(previousDayButton)
        self.view.addSubview(nextDayButton)
        self.view.addSubview(previousNextDayButtonStackView)
        
        previousNextDayButtonStackView.addArrangedSubview(previousDayButton)
        previousNextDayButtonStackView.addArrangedSubview(nextDayButton)
    }
    
    //MARK: - @objc Action Functions
    @objc func showCalendarButtonAction(sender: UIButton) {
        self.performSegue(withIdentifier: "toDayCalendarVC", sender: sender)
    }
    
    @objc func addActivityButtonAction() {
        setupScrollableStackViewConstraints()
    }
    
    @objc func showMapButtonAction(sender: UIButton) {
        self.performSegue(withIdentifier: "toActivitiesMapVC", sender: sender)
    }
    
    @objc func nextDay() {
        saveActivities()
        dayCounter += 1
        updateActivitiesView()
    }
    
    @objc func previousDay() {
        if dayCounter >= 2 {
            saveActivities()
            dayCounter -= 1
            updateActivitiesView()
        }
    }
    
    @objc func submitItineraryObject() {
        guard let user = UserController.shared.user else {return}
        if ItineraryController.sharedInstance.isEditing {
            guard let itineraryToEdit = ItineraryController.sharedInstance.itinToEdit else {return}
            ItineraryController.sharedInstance.itineraryData["activities"] = activities
            ItineraryController.sharedInstance.editItinerary(userId: user.userId, itinerary: itineraryToEdit) { result in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            ItineraryController.sharedInstance.createItinerary(userId: user.userId)
            ItineraryController.sharedInstance.itineraryData = [:]
            dayCounter = 1
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Programmatic Constraints
    func setupConstraints() {
        self.view.addSubview(dayLabel)
        createCalendarStackView()
        createAddActivityStackView()
        createPreviousNextDayButtonStackView()
        self.view.addSubview(submitButton)
        
        dayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 150).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -150).isActive = true
        
        calendarStackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        calendarStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        calendarStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        addActivityStackView.topAnchor.constraint(equalTo: calendarStackView.bottomAnchor, constant: 32).isActive = true
        addActivityStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100).isActive = true
        addActivityStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100).isActive = true
        
        setupScrollableStackViewConstraints()
        
        //        previousNextDayButtonStackView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        previousNextDayButtonStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32).isActive = true
        previousNextDayButtonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 75).isActive = true
        previousNextDayButtonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -75).isActive = true
        
        submitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        submitButton.topAnchor.constraint(equalTo: previousNextDayButtonStackView.bottomAnchor, constant: 32).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 140).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -140).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -32).isActive = true
    }
    
    func setupScrollableStackViewConstraints() {
        createScrollableStackView()
        
        scrollView.topAnchor.constraint(equalTo: addActivityStackView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -210).isActive = true
        
        scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    //MARK: - Views
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
    
    var previousNextDayButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.cornerRadius = 30.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitItineraryObject), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDayCalendarVC" {
            guard let destinationVC = segue.destination as? DayCalendarViewController else { return }
            destinationVC.delegate = self
        }
        if segue.identifier == "toActivitiesMapVC" {
            guard let destinationVC = segue.destination as? ActivitiesLocationManagerViewController else { return }
            destinationVC.mapPinDelegate = self
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripQuestionnairePartThreeViewController: DatePickerDelegate {
    func dateSelected(_ date: Date?) {
        dateOfActivityLabel?.text = date?.formatToStringWithLongDateAndTime()
        ItineraryController.sharedInstance.itineraryData["dateOfActivity"] = date
    }
}//End of extension

extension TripQuestionnairePartThreeViewController: MapPinDropped {
    func droppedPin(title: String) {
        for textField in activitiesTextFieldItems {
            if textField.text == "" {
                textField.text = title
                return
            }
        }
        setupScrollableStackViewConstraints()
    }
}//End of extension


