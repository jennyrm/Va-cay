//
//  ItineraryInfoView.swift
//  Va-cay
//
//  Created by Jenny Morales on 11/10/21.
//

import UIKit

enum ItemInfoType {
    case flightArrival, flightDeparture, hotelAirbnb
}

class ItineraryInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel = ItineraryTitleLabel(textAlignment: .left, fontSize: 14)
    let textField = ItineraryTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemPink
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(symbolImageView)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: symbolImageView.leadingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 18),
            
            symbolImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            symbolImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func set(itemInfoType: ItemInfoType) {
        switch itemInfoType {
        case .flightArrival:
            symbolImageView.image = UIImage(named: ImageAssets.calendar)
            titleLabel.text = "Flight Arrival"
        case .flightDeparture:
            symbolImageView.image = UIImage(named: ImageAssets.calendar)
            titleLabel.text = "Flight Departure"
        case .hotelAirbnb:
            symbolImageView.image = UIImage(named: ImageAssets.map)
            titleLabel.text = "Hotel/Airbnb"
        }
    }

}//End of class
