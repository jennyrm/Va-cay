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
    var activities = [ [ String : [String] ] ]()
    var activitiesTextFieldItems = [UITextField]()
    var dayActivities = [String]()
    var mapPinActivities = [String]()
    
    //MARK: - Lifecycles
    //load only if view is nil
    override func loadView() {
        super.loadView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
        self.view.backgroundColor = Colors.customOffWhite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // need for saving activity once view gets deallocated from memory
        saveActivities()
    }
    
    //MARK: - Create Itinerary Functions
    func updateView() {
        if let activities = ItineraryController.sharedInstance.itineraryData["activities"] as? [ [ String : [String] ] ] {
            self.activities = activities
//            print("Self.activities:", self.activities)
            updateActivitiesView()
        }
    }
    
    func updateActivitiesView() {
        activities.forEach { activity in
            for (key, value) in activity {
                if key == "Day \(dayCounter)" {
                    if value.isEmpty {
                        updateDay()
                        break
                    } else {
                        clearEditedTextFields()
                        value.forEach { dayActivities.append($0) }
                        mapPinActivities = dayActivities
                        displayActivities(for: key)
                        break
                    }
                }
            }
        }
        
        if dayCounter > activities.count {
            updateDay()
            mapPinActivities = []
        }
        
        dayActivities = []
        addActivityButtonAction()
    }
    
    func updateDay() {
        dayLabel.text = "Day \(dayCounter)"
        clearEditedTextFields()
        removeTextFields()
    }
    
    func displayActivities(for day: String) {
        dayLabel.text = day
        
        if dayCounter == 1 {
            activitiesTextFieldItems = []
            removeTextFields()
        }
        
        for index in 0..<dayActivities.count {
            addActivityButtonAction()
            activitiesTextFieldItems[index].text = dayActivities[index]
        }
    }
    
    func saveActivities() {
        let day = "Day \(dayCounter)"
        
        //editing itinerary activities
        if ItineraryController.sharedInstance.editingItinerary || !activities.isEmpty {
            for (index, activity) in activities.enumerated() {
                for (key, _) in activity {
                    if key == "Day \(dayCounter)" {
                        addActivitiesFromTextFields()
                        activities[index].updateValue(dayActivities, forKey: key)
                        break
                    }
                }
            }
        } else {
            //creating itinerary activities
            addActivitiesFromTextFields()
            activities.append([day : dayActivities])
        }
        
        //adding activities for a new day
        if dayCounter > activities.count {
            addActivitiesFromTextFields()
            activities.append([day : dayActivities])
        }
        
        removeTextFields()
        activitiesTextFieldItems = []
        dayActivities = []
        
        ItineraryController.sharedInstance.itineraryData["activities"] = activities
    }
    
    func addActivitiesFromTextFields() {
        activitiesTextFieldItems.forEach {
            if !$0.text!.isEmpty {
                dayActivities.append($0.text!)
            }
        }
        
        mapPinActivities = dayActivities
    }
    
    func clearEditedTextFields() {
        activitiesTextFieldItems.forEach { $0.text = "" }
    }
    
    func removeTextFields() {
        let subviews = scrollableStackView.subviews
        for textfield in subviews {
            textfield.removeFromSuperview()
        }
    }
    
    //MARK: - Programmatic Constraint Functions
    func createAddActivityStackView() {
        let label = CenterAlignedQuestionnaireLabel()
        label.text = "Add Activity"
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = Colors.customOffWhite
        button.tintColor = Colors.customLightBlue
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
        
        let textField = TextField()
        textField.placeholder = "Activity"
        activitiesTextFieldItems.append(textField)
        
        let button = MapPinButton()
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(showMapButtonAction), for: .touchUpInside)
        
        let textFieldButtonStackView = UIStackView()
        textFieldButtonStackView.axis = .horizontal
        textFieldButtonStackView.alignment = .fill
        textFieldButtonStackView.distribution = .fillProportionally
        textFieldButtonStackView.spacing = 10

        self.view.addSubview(textField)
        self.view.addSubview(button)
        self.view.addSubview(textFieldButtonStackView)
        
        textFieldButtonStackView.addArrangedSubview(textField)
        textFieldButtonStackView.addArrangedSubview(button)
        
        scrollableStackView.addArrangedSubview(textFieldButtonStackView)
        scrollView.addSubview(scrollableStackView)
    }
    
    func createPreviousNextDayButtonStackView() {
        let previousDayButton = SecondaryButton()
        previousDayButton.setTitle("Previous Day", for: .normal)
        previousDayButton.layer.cornerRadius = 18
        previousDayButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
        
        let nextDayButton = SecondaryButton()
        nextDayButton.setTitle("Next Day", for: .normal)
        nextDayButton.layer.cornerRadius = 18
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
        
        saveActivities()
        
        if ItineraryController.sharedInstance.editingItinerary {
            guard let itineraryToEdit = ItineraryController.sharedInstance.itineraryToEdit else {return}
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
        self.view.addSubview(travelItineraryLabel)
        self.view.addSubview(colorBar)
        self.view.addSubview(dayLabel)
        createAddActivityStackView()
        createPreviousNextDayButtonStackView()
        self.view.addSubview(submitButton)
        
        travelItineraryLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        travelItineraryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        travelItineraryLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        colorBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        colorBar.topAnchor.constraint(equalTo: travelItineraryLabel.bottomAnchor, constant: -12).isActive = true
        colorBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        colorBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        dayLabel.topAnchor.constraint(equalTo: colorBar.bottomAnchor, constant: 32).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 120).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120).isActive = true

        addActivityStackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 32).isActive = true
        addActivityStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 120).isActive = true
        addActivityStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120).isActive = true
        
        setupScrollableStackViewConstraints()
        
        previousNextDayButtonStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 40).isActive = true
        previousNextDayButtonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 48).isActive = true
        previousNextDayButtonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -48).isActive = true
        
        submitButton.topAnchor.constraint(equalTo: previousNextDayButtonStackView.bottomAnchor, constant: 24).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 140).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -140).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -48).isActive = true
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
    var travelItineraryLabel: UILabel = {
        let label = HeaderLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var colorBar: UIView = {
        let view = AccentView(frame: CGRect(x: 0, y: 0, width: 340, height: 20))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dayLabel: UILabel = {
        let label = CenterAlignedQuestionnaireLabel()
        label.text = "Day 1"
        label.font = .boldSystemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var addActivityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
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
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var submitButton: UIButton = {
        let button = SecondaryButton()
        button.setTitle("Submit", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.customLightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitItineraryObject), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActivitiesMapVC" {
            guard let destinationVC = segue.destination as? ActivitiesLocationManagerViewController else { return }
            destinationVC.day = "Day \(dayCounter)"
            destinationVC.activities = mapPinActivities
            destinationVC.mapPinDelegate = self
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripQuestionnairePartThreeViewController: MapPinDropped {
    func droppedPin(title: String, mapDay: String, mapActivities: [String]) {
        guard var activities = ItineraryController.sharedInstance.itineraryData["activities"] as? [ [ String : [String] ] ] else { return }
        
        for (index, activity) in activities.enumerated() {
            for (key, _) in activity {
                if key == mapDay {
                    activities.remove(at: index)
                    activities.insert([mapDay : mapActivities], at: index)
                    break
                }
            }
        }
        
        ItineraryController.sharedInstance.itineraryData["activities"] = activities
    }
}//End of extension

