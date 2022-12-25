//
//  NetModel.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/03/24.
//

import CoreImage
import CoreML
import Vision

class NetModel {

    static let shaerd = NetModel()
    private init() {}

    enum CoreMLModel {
        case squeezeNet
        case mobileNetV2

        var model: VNCoreMLModel {
            get throws {
                let configration = MLModelConfiguration()

                switch self {
                case .squeezeNet:
                    return try VNCoreMLModel(for: SqueezeNet(configuration: configration).model)
                case .mobileNetV2:
                    return try VNCoreMLModel(for: MobileNetV2(configuration: configration).model)
                }
            }
        }
    }

    func request(_ coreMLModel: CoreMLModel, errorHandler: ((Error) -> Void)? = nil, completion: @escaping ([Classification]?) -> Void) -> VNCoreMLRequest? {
        guard let model = try? coreMLModel.model else {
            return nil
        }

        return VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                errorHandler?(error)
                return
            }

            guard let results = request.results as? [VNClassificationObservation] else {
                completion(nil)
                return
            }

            completion(results.map { result in
                Classification(identifier: result.identifier, confidence: result.confidence)
            })
        }
    }

    func perform(ciImage: CIImage, requests: [VNCoreMLRequest]) throws {
        try VNImageRequestHandler(ciImage: ciImage).perform(requests)
    }
}
