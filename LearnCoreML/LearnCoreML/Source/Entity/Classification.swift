//
//  Classification.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/12/25.
//

import Foundation

struct Classification {
    let identifier: String
    let confidence: Float

    var firstIdentifier: String? {
        identifier.components(separatedBy: ",").first
    }
}
