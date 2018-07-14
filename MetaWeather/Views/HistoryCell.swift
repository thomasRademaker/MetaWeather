//
//  HistoryCell.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/13/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    // This cell is so boring looking. If I had more time I would have created a prettier cell
    // preferably with the help of a UI designer
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        keywordText.text = ""
        timeStampText.text = ""
    }
    
    private func setupView() {
        addSubview(keywordText)
        addSubview(timeStampText)
    }
    
    private func setupConstraints() {
        keywordTextConstraints()
        timeStampTextConstraints()
    }
    
    lazy var keywordText: UILabel = {
        return UILabel()
    }()
    
    private func keywordTextConstraints() {
        keywordText.translatesAutoresizingMaskIntoConstraints = false
        keywordText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        NSLayoutConstraint(item: keywordText, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }

    lazy var timeStampText: UILabel = {
        return UILabel()
    }()
    
    private func timeStampTextConstraints() {
        timeStampText.translatesAutoresizingMaskIntoConstraints = false
        timeStampText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        NSLayoutConstraint(item: timeStampText, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
