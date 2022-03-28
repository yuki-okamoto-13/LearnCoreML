//
//  ClassificationTableViewCell.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/03/26.
//

import UIKit
import Vision  // TODO: このモジュールには依存しないようにする

class ClassificationTableViewCell: UITableViewCell {

    static let height: CGFloat = 20.0

    @IBOutlet private weak var title: UILabel!

    private var identifier: String?
    private var confidence: Float?

    override func awakeFromNib() {
        super.awakeFromNib()

        initializeView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(by classificationObservation: VNClassificationObservation) {  // TODO: 引数のクラスは変える
        let objectArray = classificationObservation.identifier.components(separatedBy: ",")
        identifier = objectArray.first
        confidence = classificationObservation.confidence
    }

    private func initializeView() {
        title.text = identifier
    }
}
