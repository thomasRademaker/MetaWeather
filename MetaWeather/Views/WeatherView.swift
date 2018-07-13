//
//  WeatherView.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(cityName)
        addSubview(tempLabel)
        addSubview(temp)
        addSubview(highTempLabel)
        addSubview(highTemp)
        addSubview(lowTempLabel)
        addSubview(lowTemp)
        addSubview(condition)
        addSubview(conditionImage)
    }
    
    private func setupConstraints() {
        cityNameConstraints()
        tempLabelConstraints()
        tempConstraints()
        highTempLabelConstraints()
        highTempConstraints()
        lowTempLabelConstraints()
        lowTempConstraints()
        conditionConstraints()
        conditionImageContraints()
    }
    
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.text = "Montclair, NJ"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private func cityNameConstraints() {
        cityName.translatesAutoresizingMaskIntoConstraints = false
        cityName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        cityName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        NSLayoutConstraint(item: cityName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34).isActive = true
    }
    
    private func tempLabelFactory(labelText: String) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }
    
    private func tempFactory() -> UILabel {
        let label = UILabel()
        label.text = "75"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }
    
    private lazy var tempLabel: UILabel = {
        return tempLabelFactory(labelText: "TEMP:")
    }()
    
    private func tempLabelConstraints() {
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        tempLabel.topAnchor.constraint(equalTo: condition.bottomAnchor, constant: 16).isActive = true
    }
    
    lazy var temp: UILabel = {
        return tempFactory()
    }()
    
    private func tempConstraints() {
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 8).isActive = true
        NSLayoutConstraint(item: temp, attribute: .centerY, relatedBy: .equal, toItem: tempLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    private lazy var highTempLabel: UILabel = {
        return tempLabelFactory(labelText: "High Temp:")
    }()
    
    private func highTempLabelConstraints() {
        highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        highTempLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        highTempLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    lazy var highTemp: UILabel = {
        return tempFactory()
    }()
    
    private func highTempConstraints() {
        highTemp.translatesAutoresizingMaskIntoConstraints = false
        highTemp.leadingAnchor.constraint(equalTo: highTempLabel.trailingAnchor, constant: 8).isActive = true
        NSLayoutConstraint(item: highTemp, attribute: .centerY, relatedBy: .equal, toItem: highTempLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    private lazy var lowTempLabel: UILabel = {
        return tempLabelFactory(labelText: "Low Temp:")
    }()
    
    private func lowTempLabelConstraints() {
        lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTempLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        lowTempLabel.topAnchor.constraint(equalTo: highTempLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    lazy var lowTemp: UILabel = {
        return tempFactory()
    }()
    
    private func lowTempConstraints() {
        lowTemp.translatesAutoresizingMaskIntoConstraints = false
        lowTemp.leadingAnchor.constraint(equalTo: lowTempLabel.trailingAnchor, constant: 8).isActive = true
        NSLayoutConstraint(item: lowTemp, attribute: .centerY, relatedBy: .equal, toItem: lowTempLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    lazy var condition: UILabel = {
        let label = UILabel()
        label.text = "Sunny"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private func conditionConstraints() {
        condition.translatesAutoresizingMaskIntoConstraints = false
        condition.topAnchor.constraint(equalTo: conditionImage.bottomAnchor, constant: 16).isActive = true
        NSLayoutConstraint(item: condition, attribute: .centerX, relatedBy: .equal, toItem: conditionImage, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: condition, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22).isActive = true
    }
    
    lazy var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private func conditionImageContraints() {
        conditionImage.translatesAutoresizingMaskIntoConstraints = false
        conditionImage.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 32).isActive = true
        NSLayoutConstraint(item: conditionImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: conditionImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: conditionImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
    }
}
