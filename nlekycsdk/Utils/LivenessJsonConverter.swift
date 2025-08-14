//
//  LivenessJsonConverter.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import FlashLiveness
import Foundation

class LivenessJsonConverter {
    static func convertToJSONString(_ liveness: LivenessResult) -> String {
        let livenessData: [String: Any] = [
            "status": liveness.status,
            "data": [
                "faceMatchingScore": liveness.data["faceMatchingScore"],
                "livenesScore": liveness.data["livenesScore"],
                "livenessScore": liveness.data["livenessScore"],
                "isColored": liveness.data["isColored"],
                "faceMatchingResult": liveness.data["faceMatchingResult"],
                "livenessType": liveness.data["livenessType"],
                "sim": liveness.data["sim"],
            ],
            "code": liveness.code,
            "request_id": liveness.request_id,
            "message": liveness.mess,
            "success": liveness.success,
            "signature": liveness.signature,
        ]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: livenessData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            debugPrint("Error converting to JSON: \(error)")
            return "{}"
        }
    }
}
