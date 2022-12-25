//
//  ClassificationTableViewCell.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/03/26.
//

import UIKit

class ClassificationTableViewCell: UITableViewCell {

    static let height: CGFloat = 24.0
    static let nibName = "ClassificationTableViewCell"
    static let reuseIdentifier = "ClassificationTableViewCell"

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var confidence: UILabel!

    func configure(by classification: Classification) {
        title.text = classification.firstIdentifier
        confidence.text = "\(String(format: "%.1f", classification.confidence * 100))%"
    }
}
