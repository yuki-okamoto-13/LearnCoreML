//
//  NetModel.swift
//  LearnCoreML
//
//  Created by okamoto yuki on 2022/03/24.
//

import CoreML
import Vision

class NetModel {

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

    func request(_ coreMLModel: CoreMLModel, errorHandler: ((Error) -> Void)? = nil, completion: @escaping ([VNClassificationObservation]?) -> Void) -> VNCoreMLRequest? {
        guard let model = try? coreMLModel.model else {
            return nil
        }

        return VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                errorHandler?(error)
                return
            }

            let results = request.results as? [VNClassificationObservation]
            completion(results)
        }
    }

}
