//
//  TripQuestionnairePartTwoViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/30/21.
//

import UIKit

class TripQuestionnairePartTwoViewController: UIViewController {
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var calendarCounter = 0
    var flightArrivalDateLabel = UILabel()
    var flightDepartureDateLabel = UILabel()
    var flightArrivalOrDeparture: String?
    var hotelAirbnbTextField: UITextField?
    var budgetTextField: UITextField?
    var checklistTextFieldItems = [UITextField]()
    var checklistButtons = [UIButton]()
    var checklist = [ [String??: Bool] ]()
    
    //MARK: - Lifecyle
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
    
    //MARK: - Functions
    func updateView() {
        if let flightArrival = ItineraryController.sharedInstance.itineraryData["flightArrival"] as? Date {
            flightArrivalDateLabel.text = flightArrival.formatToStringWithShortDateAndTime()
        }
        if let flightDeparture = ItineraryController.sharedInstance.itineraryData["flightDeparture"] as? Date {
            flightDepartureDateLabel.text = flightDeparture.formatToStringWithShortDateAndTime()
        }
        if let hotelAirbnb = ItineraryController.sharedInstance.itineraryData["hotelAirbnb"] as? String {
            hotelAirbnbTextField?.text = hotelAirbnb
        }
        if let budget = ItineraryController.sharedInstance.itineraryData["budget"] as? String {
            budgetTextField?.text = budget
        }
        if let checklist = ItineraryController.sharedInstance.itineraryData["checklist"] as? [ [String?? : Bool] ] {
                        for index in 0..<checklist.count {
                            for (key, value) in checklist[index] {
                                checklistTextFieldItems[index].text = key!
                                if value {
                                    checklistButtons[index].setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                                }
                            }
                            setupScrollableStackViewConstraints()
                        }
            self.checklist = checklist
        }
    }
    
    func saveTextFieldInputs() {
        if hotelAirbnbTextField?.text != "" {
            ItineraryController.sharedInstance.itineraryData["hotelAirbnb"] = hotelAirbnbTextField?.text
        }
        if budgetTextField?.text != "" {
            ItineraryController.sharedInstance.itineraryData["budget"] = budgetTextField?.text
        }
        if checklistTextFieldItems[0].text != "" {
            checklistTextFieldItems.enumerated().forEach { (index, el) in
                if index > checklist.count - 1 && !el.text!.isEmpty {
                    if checklistButtons[index].currentImage == UIImage(named: "square") {
                        checklist.append([el.text : true])
                    } else {
                        checklist.append([el.text : false])
                    }
                }
            }
            ItineraryController.sharedInstance.itineraryData["checklist"] = checklist
        }
    }
    
    func createLabelCalendarButton(with flightLabel: UILabel) -> UIStackView {
        flightLabel.textAlignment = .center
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemGray6
        button.tag = calendarCounter
        calendarCounter += 1
        button.addTarget(self, action: #selector(showCalendarButtonAction), for: .touchUpInside)
        
        let labelButtonStackView = UIStackView()
        labelButtonStackView.axis = .horizontal
        labelButtonStackView.alignment = .fill
        labelButtonStackView.distribution = .fill
        labelButtonStackView.spacing = 8
        labelButtonStackView.addAccentBorder()
        
        self.view.addSubview(flightLabel)
        self.view.addSubview(button)
        self.view.addSubview(labelButtonStackView)
        
        labelButtonStackView.addArrangedSubview(flightLabel)
        labelButtonStackView.addArrangedSubview(button)
        
        return labelButtonStackView
    }
    
    func createFlightDetailsStackView() {
        let flightArrivalLabel = LeftAlignedQuestionnaireLabel()
        flightArrivalLabel.text = "Flight Arrival"
        
        let flightDepartureLabel = LeftAlignedQuestionnaireLabel()
        flightDepartureLabel.text = "Flight Departure"
        
        let flightArrivalStackView = UIStackView()
        flightArrivalStackView.axis = .vertical
        flightArrivalStackView.alignment = .fill
        flightArrivalStackView.spacing = 4
        
        let flightDepartureStackView = UIStackView()
        flightDepartureStackView.axis = .vertical
        flightDepartureStackView.alignment = .fill
        flightDepartureStackView.spacing = 4
        
        self.view.addSubview(flightArrivalLabel)
        self.view.addSubview(flightDepartureLabel)
        self.view.addSubview(flightArrivalStackView)
        self.view.addSubview(flightDepartureStackView)
        self.view.addSubview(flightDetailsStackView)
        
        flightArrivalStackView.addArrangedSubview(flightArrivalLabel)
        flightArrivalStackView.addArrangedSubview(createLabelCalendarButton(with: flightArrivalDateLabel))
        
        flightDepartureStackView.addArrangedSubview(flightDepartureLabel)
        flightDepartureStackView.addArrangedSubview(createLabelCalendarButton(with: flightDepartureDateLabel))
        
        flightDetailsStackView.addArrangedSubview(flightArrivalStackView)
        flightDetailsStackView.addArrangedSubview(flightDepartureStackView)
    }
    
    func createHotelAirbnbStackView() {
        let label = CenterAlignedQuestionnaireLabel()
        label.text = "Hotel/Airbnb"
        
        let textField = TextField()
        hotelAirbnbTextField = textField
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        button.addTarget(self, action: #selector(showMapButtonAction), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addAccentBorder()
        
        self.view.addSubview(label)
        self.view.addSubview(textField)
        self.view.addSubview(button)
        self.view.addSubview(stackView)
        self.view.addSubview(hotelAirbnbStackView)
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        
        hotelAirbnbStackView.addArrangedSubview(label)
        hotelAirbnbStackView.addArrangedSubview(stackView)
    }
    
    func createTotalBudgetStackView() {
        let label = CenterAlignedQuestionnaireLabel()
        label.text = "Total Budget"
        
        let textField = TextField()
        budgetTextField = textField
        
        self.view.addSubview(label)
        self.view.addSubview(textField)
        self.view.addSubview(totalBudgetStackView)
        
        totalBudgetStackView.addArrangedSubview(label)
        totalBudgetStackView.addArrangedSubview(textField)
    }
    
    func createAddToChecklistStackView() {
        let label = CenterAlignedQuestionnaireLabel()
        label.text = "Checklist"
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .green
        button.addTarget(self, action: #selector(addNewChecklistItem), for: .touchUpInside)
        
        self.view.addSubview(label)
        self.view.addSubview(button)
        self.view.addSubview(addToChecklistStackView)
        
        addToChecklistStackView.addArrangedSubview(label)
        addToChecklistStackView.addArrangedSubview(button)
    }
    
    func createScrollableStackView() {
        self.view.addSubview(scrollView)
        self.view.addSubview(scrollableStackView)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.backgroundColor = .systemGray6
        button.tintColor = .black
        button.addTarget(self, action: #selector(checklistButtonTapped), for: .touchUpInside)
        checklistButtons.append(button)
        
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Add a to-do item"
        checklistTextFieldItems.append(textField)
        
        let textFieldButtonStackView = UIStackView()
        textFieldButtonStackView.axis = .horizontal
        textFieldButtonStackView.alignment = .fill
        textFieldButtonStackView.distribution = .fillProportionally
        textFieldButtonStackView.spacing = 0
        
        self.view.addSubview(button)
        self.view.addSubview(textField)
        self.view.addSubview(textFieldButtonStackView)
        
        textFieldButtonStackView.addArrangedSubview(button)
        textFieldButtonStackView.addArrangedSubview(textField)
        
        scrollableStackView.addArrangedSubview(textFieldButtonStackView)
        scrollView.addSubview(scrollableStackView)
    }

    @objc func showCalendarButtonAction(sender: UIButton) {
        switch (sender.tag) {
        case 0:
            flightArrivalOrDeparture = "flightArrival"
            self.performSegue(withIdentifier: "toFlightArrivalVC", sender: sender)
        case 1:
            flightArrivalOrDeparture = "flightDeparture"
            self.performSegue(withIdentifier: "toFlightDepartureVC", sender: sender)
        default:
            break
        }
    }
    
    @objc func showMapButtonAction(sender: UIButton) {
        self.performSegue(withIdentifier: "toHotelAirbnbMapVC", sender: sender)
    }
    
    @objc func addNewChecklistItem() {
        setupScrollableStackViewConstraints()
    }
    
    @objc func checklistButtonTapped(sender: UIButton){
        guard let index = checklistButtons.firstIndex(of: sender) else {return}
        if sender.currentImage == UIImage(systemName: "square") {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            if index < checklist.count {
                for (key, _) in checklist[index] {
                    checklist[index][key] = true
                }
            }
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            if index < checklist.count {
                for (key, _) in checklist[index] {
                    checklist[index][key] = false
                }
            }
        }
        saveTextFieldInputs()
        
    }
    
    @objc func nextVC(sender: UIButton) {
        saveTextFieldInputs()
        self.performSegue(withIdentifier: "toAddActivityVC", sender: sender)
    }
    
    //MARK: - Constraints
    func setupConstraints() {
        self.view.addSubview(travelItineraryLabel)
        self.view.addSubview(colorBar)
        createFlightDetailsStackView()
        createHotelAirbnbStackView()
        createTotalBudgetStackView()
        createAddToChecklistStackView()
        self.view.addSubview(nextButton)
        
        travelItineraryLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        travelItineraryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        travelItineraryLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        colorBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        colorBar.topAnchor.constraint(equalTo: travelItineraryLabel.bottomAnchor, constant: -12).isActive = true
        colorBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        colorBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        flightDetailsStackView.topAnchor.constraint(equalTo: colorBar.bottomAnchor, constant: 32).isActive = true
        flightDetailsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        flightDetailsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        hotelAirbnbStackView.topAnchor.constraint(equalTo: flightDetailsStackView.bottomAnchor, constant: 16).isActive = true
        hotelAirbnbStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        hotelAirbnbStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        totalBudgetStackView.topAnchor.constraint(equalTo: hotelAirbnbStackView.bottomAnchor, constant: 16).isActive = true
        totalBudgetStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        totalBudgetStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        addToChecklistStackView.topAnchor.constraint(equalTo: totalBudgetStackView.bottomAnchor, constant: 16).isActive = true
        addToChecklistStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 120).isActive = true
        addToChecklistStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120).isActive = true
        
        setupScrollableStackViewConstraints()
        
        nextButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 140).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -140).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -64).isActive = true
    }
    
    func setupScrollableStackViewConstraints() {
        createScrollableStackView()
        
        scrollView.topAnchor.constraint(equalTo: addToChecklistStackView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -150).isActive = true
        
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
    
    var flightDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var hotelAirbnbStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var totalBudgetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var addToChecklistStackView: UIStackView = {
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
    
    var nextButton: UIButton = {
        let button = SecondaryButton()
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFlightArrivalVC" {
            guard let destinationVC = segue.destination as? FlightArrivalCalendarViewController else { return }
            destinationVC.delegate = self
        }
        if segue.identifier == "toFlightDepartureVC" {
            guard let destinationVC = segue.destination as? FlightDepartureCalendarViewController else { return }
            destinationVC.delegate = self
        }
        if segue.identifier == "toHotelAirbnbMapVC" {
            guard let destinationVC = segue.destination as? HotelAirbnbLocationManagerViewController else { return }
            destinationVC.mapPinDelegate = self
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripQuestionnairePartTwoViewController: DatePickerDelegate {
    func dateSelected(_ date: Date?) {
        if flightArrivalOrDeparture == "flightArrival" {
            flightArrivalDateLabel.text = date?.formatToStringWithShortDateAndTime()
        }
        if flightArrivalOrDeparture == "flightDeparture" {
            flightDepartureDateLabel.text = date?.formatToStringWithShortDateAndTime()
        }
    }
}//End of extension

extension TripQuestionnairePartTwoViewController: MapPinDropped {
    func droppedPin(title: String, mapDay day: String, mapActivities activities: [String]) {
        hotelAirbnbTextField?.text = title
    }
}//End of extension
