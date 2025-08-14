//
//  IDCardJSONConverter.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import IDCardReader

class IDCardJSONConverter {
    static func convertToJSONString(_ idCardResponse: IDCardInformationResponse) -> String {
        // Tạo dictionary từ IDCardInformationResponse
        let cardData: [String: Any] = [
            "request_id": idCardResponse.requestId,
            "status": idCardResponse.status,
            "code": idCardResponse.code,
            "data": [
                "date_of_birth": idCardResponse.data?.dateOfBirth,
                "partner_name": idCardResponse.data?.partnerName,
                "citizen_identify": idCardResponse.data?.citizenIdentify,
                "faceImage": idCardResponse.data?.faceImage,
                "place_of_residence": idCardResponse.data?.placeOfResidence,
                "place_of_origin": idCardResponse.data?.placeOfOrigin,
                "nationality": idCardResponse.data?.nationality,
                "date_of_expiry": idCardResponse.data?.dateOfExpiry,
                "dateProvide": idCardResponse.data?.dateProvide,
                "religion": idCardResponse.data?.religion,
                "ethnic": idCardResponse.data?.ethnic,
                "father_name": idCardResponse.data?.fatherName,
                "old_citizen_identify": idCardResponse.data?.oldCitizenIdentify,
                "personal_identification": idCardResponse.data?.personalIdentification,
                "gender": idCardResponse.data?.gender,
                "mother_name": idCardResponse.data?.motherName,
                "full_name": idCardResponse.data?.fullname,
            ],
            "message": idCardResponse.message,
            "faceString": idCardResponse.faceString,
        ]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: cardData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            debugPrint("Error converting to JSON: \(error)")
            return "{}"
        }
    }

    static func convertToJSONStringWithFaceImage(
        _ idCardResponse: IDCardInformationResponse, faceImageData: Data? = nil
    ) -> String {
        let faceImageBase64 = faceImageData?.base64EncodedString() ?? ""

        let cardData: [String: Any] = [
            "request_id": idCardResponse.requestId,
            "status": idCardResponse.status,
            "code": idCardResponse.code,
            "data": [
                "date_of_birth": idCardResponse.data?.dateOfBirth,
                "partner_name": idCardResponse.data?.partnerName,
                "citizen_identify": idCardResponse.data?.citizenIdentify,
                "faceImage": idCardResponse.data?.faceImage,
                "place_of_residence": idCardResponse.data?.placeOfResidence,
                "place_of_origin": idCardResponse.data?.placeOfOrigin,
                "nationality": idCardResponse.data?.nationality,
                "date_of_expiry": idCardResponse.data?.dateOfExpiry,
                "dateProvide": idCardResponse.data?.dateProvide,
                "religion": idCardResponse.data?.religion,
                "ethnic": idCardResponse.data?.ethnic,
                "father_name": idCardResponse.data?.fatherName,
                "old_citizen_identify": idCardResponse.data?.oldCitizenIdentify,
                "personal_identification": idCardResponse.data?.personalIdentification,
                "gender": idCardResponse.data?.gender,
                "mother_name": idCardResponse.data?.motherName,
                "full_name": idCardResponse.data?.fullname,
            ],
            "message": idCardResponse.message,
            "faceString": idCardResponse.faceString,
        ]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: cardData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            debugPrint("Error converting to JSON: \(error)")
            return "{}"
        }
    }

    static func convertToJSONString(_ cardInformation: CardInformation) -> String {
        // Tạo dictionary từ CardInformation
        let cardData: [String: Any] = [
            "request_id": cardInformation.readIdCardRequestId ?? "",
            "status": 200,
            "code": 0,
            "data": [
                "date_of_birth": cardInformation.dateOfBirth,
                "partner_name": cardInformation.partnerName,
                "citizen_identify": cardInformation.citizenIdentify,
                "faceImage": cardInformation.faceImage,
                "place_of_residence": cardInformation.placeOfResidence,
                "place_of_origin": cardInformation.placeOfOrigin,
                "nationality": cardInformation.nationality,
                "date_of_expiry": cardInformation.dateOfExpiry,
                "dateProvide": cardInformation.dateProvide,
                "religion": cardInformation.religion,
                "ethnic": cardInformation.ethnic,
                "father_name": cardInformation.fatherName,
                "old_citizen_identify": cardInformation.oldCitizenIdentify,
                "personal_identification": cardInformation.personalIdentification,
                "gender": cardInformation.gender,
                "mother_name": cardInformation.motherName,
                "full_name": cardInformation.fullName,
            ],
            "message": "Success",
            "faceString": cardInformation.faceString,
        ]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: cardData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            debugPrint("Error converting CardInformation to JSON: \(error)")
            return "{}"
        }
    }
}
