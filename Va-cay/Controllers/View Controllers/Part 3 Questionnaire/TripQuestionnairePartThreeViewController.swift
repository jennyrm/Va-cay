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
    var dayDateLabel: UILabel?
    var addOrEditDayText = "Add Day"
    var activities = [ [ String : [String] ] ]()
    var currentActivities = [String]()
    var activitiesTextFieldItems = [UITextField]()
    var itinerary: Itinerary? {
        didSet {
            if itinerary == nil {
                return
            } else {
                addOrEditDayText = "Next Day"
                loadViewIfNeeded()
                updateEditedItineraryView()
            }
        }
    }
    
    //MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTextFieldInputs()
    }
    
    //MARK: - Create Itinerary Functions
    func updateView() {
        if let currentDay = ItineraryController.sharedInstance.itineraryData["currentDay"] as? Date {
            dayDateLabel?.text = currentDay.formatToStringWithLongDateAndTime()
        }
        if let currentActivities = ItineraryController.sharedInstance.itineraryData["currentActivities"] as? [String] {
            for index in 0..<currentActivities.count {
                setupScrollableStackViewConstraints()
                activitiesTextFieldItems[index].text = currentActivities[index]
            }
        }
        if let dayCounter = ItineraryController.sharedInstance.itineraryData["dayCounter"] as? Int {
            self.dayCounter = dayCounter
            dayLabel.text = "Day \(dayCounter)"
        }
    }
    
    func saveTextFieldInputs() {
        activitiesTextFieldItems.forEach {
            if !$0.text!.isEmpty {
                currentActivities.append($0.text!)
            }
        }
        ItineraryController.sharedInstance.itineraryData["currentActivities"] = currentActivities
        if !currentActivities.isEmpty {
            activities.append(["Day \(dayCounter)" : currentActivities])
        }
        currentActivities = []
        
        ItineraryController.sharedInstance.itineraryData["dayCounter"] = dayCounter
        
        ItineraryController.sharedInstance.itineraryData["activities"] = activities
    }
    
    func clearTextFieldInputs() {
        ItineraryController.sharedInstance.itineraryData.removeValue(forKey: "currentDay")
        dayDateLabel?.text = ""
        
        ItineraryController.sharedInstance.itineraryData.removeValue(forKey: "currentActivities")
        activitiesTextFieldItems.forEach { $0.text = "" }
        removeTextFields()
            
        updateView()
    }
    
    func removeTextFields() {
        let subviews = scrollableStackView.subviews
        for textfield in subviews {
            textfield.removeFromSuperview()
        }
//        addActivityButtonAction()
    }
    
    //MARK: - Edit Itinerary Functions
    func updateEditedItineraryView() {
        guard let itinerary = itinerary,
              let itineraryActivities = itinerary.activities else { return }
        
        self.activities = itineraryActivities

        for (index, activity) in activities.enumerated() {
            if index + 1 == dayCounter {
                for (key, value) in activity {
                    if value.isEmpty {
                        updateDay()
                    } else {
                        clearEditedTextFields()
                        value.forEach { currentActivities.append($0) }
                        displayItinerary(for: key)
                    }
                }
            }
        }
        
        if dayCounter > activities.count {
            updateDay()
        }
    
        currentActivities = []
    }
    
    func displayItinerary(for day: String) {
        dayLabel.text = day
        for index in 0..<currentActivities.count {
            setupScrollableStackViewConstraints()
            activitiesTextFieldItems[index].text = currentActivities[index]
        }
    }
    
    func saveEditedItinerary() {
        let key = "Day \(dayCounter)"
        
        for (index, _) in activities.enumerated() {
            if index + 1 == dayCounter {
                activitiesTextFieldItems.forEach {
                    if !$0.text!.isEmpty {
                        currentActivities.append($0.text!)
                    }
                }
                activities[index].updateValue(currentActivities, forKey: key)
                itinerary?.activities = self.activities
                print(itinerary?.activities as Any)
            }
        }
        
        if dayCounter > activities.count {
            activitiesTextFieldItems.forEach {
                if !$0.text!.isEmpty {
                    currentActivities.append($0.text!)
                }
            }
            
            itinerary?.activities?.append([key : currentActivities])
            print(itinerary?.activities as Any)
        }

        removeTextFields()
        activitiesTextFieldItems = []
        currentActivities = []
    }
    
    func clearEditedTextFields() {
        activitiesTextFieldItems.forEach { $0.text = "" }
    }
    
    func updateDay() {
        dayLabel.text = "Day \(dayCounter)"
        clearEditedTextFields()
        removeTextFields()
    }

//MARK: - Programmatic Constraint Functions
func createCalendarStackView() {
    let label = UILabel()
    label.textColor = .black
    label.layer.borderWidth = 1.0
    label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    //        label.backgroundColor = .systemGray6
    label.textAlignment = .center
    dayDateLabel = label
    
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

func createFooterButtonsStackView() {
    let addEditDayButton = UIButton()
    addEditDayButton.setTitle(addOrEditDayText, for: .normal)
    addEditDayButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    addEditDayButton.layer.cornerRadius = 30.0
    addEditDayButton.addTarget(self, action: #selector(addOrEditDay), for: .touchUpInside)
    
    let submitButton = UIButton()
    submitButton.setTitle("Submit", for: .normal)
    submitButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    submitButton.layer.cornerRadius = 30.0
    submitButton.addTarget(self, action: #selector(createItineraryObject), for: .touchUpInside)
    
    self.view.addSubview(addEditDayButton)
    self.view.addSubview(submitButton)
    self.view.addSubview(footerButtonsStackView)
    
    footerButtonsStackView.addArrangedSubview(addEditDayButton)
    footerButtonsStackView.addArrangedSubview(submitButton)
}

//MARK: - @obj Action Functions
@objc func showCalendarButtonAction(sender: UIButton) {
    self.performSegue(withIdentifier: "toDayCalendarVC", sender: sender)
}

@objc func addActivityButtonAction() {
    setupScrollableStackViewConstraints()
}

@objc func showMapButtonAction(sender: UIButton) {
    self.performSegue(withIdentifier: "toActivitiesMapVC", sender: sender)
}


@objc func addOrEditDay() {
    if addOrEditDayText == "Add Day" {
        saveTextFieldInputs()
        
        let currentActivities = ItineraryController.sharedInstance.itineraryData["currentActivities"] as? [String]
      
        if currentActivities != [] {
            dayCounter += 1
            ItineraryController.sharedInstance.itineraryData["dayCounter"] = dayCounter
            ItineraryController.sharedInstance.itineraryData["activities"] = activities
            clearTextFieldInputs()
            dayLabel.text = "Day \(dayCounter)"
        }
    } else {
        saveEditedItinerary()
        dayCounter += 1
        updateEditedItineraryView()
    }
}

@objc func createItineraryObject() {
    guard let user = UserController.shared.user else {return}
    if ItineraryController.sharedInstance.isEditing {
        guard let itineraryToEdit = ItineraryController.sharedInstance.itinToEdit else {return}
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
    createFooterButtonsStackView()
    
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
  
    footerButtonsStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32).isActive = true
    footerButtonsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 140).isActive = true
    footerButtonsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -140).isActive = true
    footerButtonsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -32).isActive = true
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
    stackView.distribution = .fillProportionally
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

var footerButtonsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
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
        dayDateLabel?.text = date?.formatToStringWithLongDateAndTime()
        ItineraryController.sharedInstance.itineraryData["currentDay"] = date
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


