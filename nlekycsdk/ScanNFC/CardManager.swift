//
//  CardManager.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import IDCardReader
import KeychainSwift
import OpenSSL
import ObjectMapper

class CardManager: NSObject {
    static var cardNumber: String?
    static var doe: String?
    static var dob: String?
    
    static var temporaryCard: CardInformation?
    
    static var cardInformation: CardInformation? {
        get {
            let keychain = KeychainSwift()
            if let data = keychain.getData("kCardInformation") {
                do {
                    if let data = keychain.getData("kCardInformation") {
                        let card = try JSONDecoder().decode(CardInformation.self, from: data)
                        return card
                    }
                } catch let error {
                    print("Error decoding: \(error)")
                }
            }else {
                return nil
            }
            
            return nil
        }
        
        set {
            let keychain = KeychainSwift()
            if let value = newValue {
                do {
                    let data = try JSONEncoder().encode(value)
                    keychain.set(data, forKey: "kCardInformation")
                } catch let error {
                    print("Error encoding: \(error)")
                }
            }else {
                keychain.delete("kCardInformation")
            }
            
        }

    }
    
    static func cleanKeyChain() {
        let keychain = KeychainSwift()
        keychain.delete("kCardInformation")
        
//        DeviceManager.shared.secret = ""
////        DeviceManager.shared.encryptedDeviceId = ""
//        DeviceManager.shared.privateKey = ""
//        DeviceManager.shared.signature = ""
//        DeviceManager.shared.accessToken = ""
//        DeviceManager.shared.refreshToken = ""
    }
    
    static func getCardLocalizedPropertiesName() -> [String: String]{
        let properties: [String: String] =  ["citizenIdentify": "Số CCCD",
                                               "oldCitizenIdentify": "Số CMND cũ",
                                               "fullName": "Họ tên",
                                               "dateOfBirth": "Ngày sinh",
                                               "dateOfExpiry": "Ngày hết hạn",
                                               "gender": "Giới tính",
                                               "nationality": "Quốc tịch",
                                               "ethnic": "Dân tộc",
                                               "religion": "Tôn giáo",
                                               "placeOfOrigin": "Quê quán",
                                               "placeOfResidence": "HKTT",
                                               "personalIdentification": "Đặc điểm nhận dạng",
                                               "dateProvide": "Ngày cấp",
                                               "fatherName": "Họ tên bố",
                                               "motherName": "Họ tên mẹ",
                                               "partnerName": "Họ tên vợ/chồng"]
        return properties
    }
    
    static func getCardPropertiesName() -> [String] {
        let properties: [String] = ["citizenIdentify",
                                               "oldCitizenIdentify",
                                               "fullName",
                                               "dateOfBirth",
                                               "dateOfExpiry",
                                               "gender",
                                               "nationality",
                                               "ethnic",
                                               "religion",
                                               "placeOfOrigin",
                                               "placeOfResidence",
                                               "personalIdentification",
                                               "dateProvide",
                                               "fatherName",
                                               "motherName",
                                               "partnerName"]
        return properties
        
    }
    static func getDefaultSharingProperties() -> [String] {
        let properties: [String] = ["fullName", "citizenIdentify",
                                               "dateOfBirth",
                                               "gender",
                                               "nationality",
                                               "placeOfOrigin",
                                               "placeOfResidence",
                                               "oldCitizenIdentify"]
        return properties
    }
    
    static func getAdditionalSharingProperties() -> [String] {
        let properties: [String] = ["personalIdentification", "dateProvide",
//                                               "Nơi cấp",
                                               "dateOfExpiry",
//                                               "Địa chỉ hiện tại",
                                               "fatherName",
                                               "motherName",
                                               "partnerName"]
        return properties
    }
}

extension Array {
    func reOrder(array : [String] , order : [String]) -> [String]{

        //common elments in order
        // order.filter{array.contains($0)}

        // the rest of the array that the order doesnt specify
        // array.filter{!order.contains($0)}

     return order.filter{array.contains($0)} + array.filter{!order.contains($0)}
    }

}
/**
 Make CardInformation as a Dictionary?
 Show tableview's numberOfRow = dictionary.keys.count
 
 */


struct CardInformation: Codable {
    var faceString: String             = ""
    
    var citizenIdentify: String        = ""
    var oldCitizenIdentify: String     = ""
    var fullName: String               = ""
    var dateOfBirth: String            = ""
    var dateOfExpiry: String    = ""
    var gender: String          = ""
    var nationality: String     = ""
    var ethnic: String          = ""
    var religion: String        = ""
    var placeOfOrigin: String   = ""
    var placeOfResidence: String       = ""
    var personalIdentification: String = ""
    var dateProvide: String            = ""
    var fatherName: String             = ""
    var motherName: String             = ""
    var partnerName: String            = ""
    var faceImage: String              = ""
    
    var chipAuthStatus: Bool    = false
    var passiveAuthStatus: Bool = false
    
    
    var documentNumber: String = "" //used for scan nfc
    var readIdCardRequestId: String?
    var updatedAt: Date?
    var cardImage: String?
    
    init(card: IDCardInformationResponse) {
        chipAuthStatus = card.chipAuthStatus == .success
        passiveAuthStatus = card.passiveAuthStatus == .success
        
        faceString = card.faceString
        
        if let data = card.data {
            citizenIdentify = data.citizenIdentify
            oldCitizenIdentify = data.oldCitizenIdentify
            fullName = data.fullname
            dateOfBirth = data.dateOfBirth
            dateOfExpiry = data.dateOfExpiry
            gender = data.gender
            nationality = data.nationality
            ethnic = data.ethnic
            religion = data.religion
            placeOfOrigin = data.placeOfOrigin
            placeOfResidence = data.placeOfResidence
            personalIdentification = data.personalIdentification
            dateProvide = data.dateProvide
            fatherName = data.fatherName
            motherName = data.motherName
            partnerName = data.partnerName
            faceImage = data.faceImage
        }
        
    }
    
    init(data: IDCardInformation) {
        citizenIdentify = data.citizenIdentify
        oldCitizenIdentify = data.oldCitizenIdentify
        fullName = data.fullname
        dateOfBirth = data.dateOfBirth
        dateOfExpiry = data.dateOfExpiry
        gender = data.gender
        nationality = data.nationality
        ethnic = data.ethnic
        religion = data.religion
        placeOfOrigin = data.placeOfOrigin
        placeOfResidence = data.placeOfResidence
        personalIdentification = data.personalIdentification
        dateProvide = data.dateProvide
        fatherName = data.fatherName
        motherName = data.motherName
        partnerName = data.partnerName
        faceImage = data.faceImage
    }
    
    init(cardId: String) {
        citizenIdentify = cardId
    }
}

extension CardInformation: Mappable {
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        citizenIdentify <- map["citizenIdentify"]
        oldCitizenIdentify <- map["oldCitizenIdentify"]
        fullName <- map["fullName"]
        dateOfBirth <- map["dateOfBirth"]
        dateOfExpiry <- map["dateOfExpiry"]
        gender <- map["gender"]
        nationality <- map["nationality"]
        ethnic <- map["ethnic"]
        religion <- map["religion"]
        placeOfOrigin <- map["placeOfOrigin"]
        placeOfResidence <- map["placeOfResidence"]
        personalIdentification <- map["personalIdentification"]
        dateProvide <- map["dateProvide"]
        fatherName <- map["fatherName"]
        motherName <- map["motherName"]
        partnerName <- map["partnerName"]
        faceImage <- map["faceImage"]
    }
}

//import JOSESwift

extension CardManager {
    
    static func createJWE(data: Data) -> String? {
        var jweString: String?
//        let payload = Payload(data)
//        var header = JWEHeader(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .A128GCM)
//        header.kid = DeviceManager.shared.secret
//
//        if let key: SecKey = CardManager.createPublicKey(pem: ""),
//           let encrypter = Encrypter(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .A128GCM, encryptionKey: key),
//           let jwe = try? JWE(header: header, payload: payload, encrypter: encrypter) {
//            jweString = jwe.compactSerializedString
//        }else {
//            print("JWE failed")
//        }
        
        return jweString
    }
    
    static func createJWS(data: Data) -> String? {
        var jwsString: String?
//        let payload = Payload(data)
//        var header = JWSHeader(algorithm: .PS256)
//        header.kid = DeviceManager.shared.secret
//        header.cty = "JWE"
//        header.typ = "JOSE"
//
//        if let key: SecKey = CardManager.createSecKeyFromPrivateKey(privateKeyPEM: DeviceManager.shared.privateKey),
//        let signer = Signer(signingAlgorithm: .PS256, key: key),
//        let jws = try? JWS(header: header, payload: payload, signer: signer) {
//            jwsString = jws.compactSerializedString
//        }else {
//            print("JWS failed")
//        }
        return jwsString
    }
    
        
    static func createPublicKey(pem: String) -> SecKey? {
        let a = """
        -----BEGIN CERTIFICATE-----
        MIIE8jCCA9qgAwIBAgIQVAESDxKv/JtHV15tvtt1UjANBgkqhkiG9w0BAQsFADAr
        MQ0wCwYDVQQDDARJLUNBMQ0wCwYDVQQKDARJLUNBMQswCQYDVQQGEwJWTjAeFw0y
        MzA2MDcwNjU1MDNaFw0yNjA2MDkwNjU1MDNaMIHlMQswCQYDVQQGEwJWTjESMBAG
        A1UECAwJSMOgIE7hu5lpMRowGAYDVQQHDBFRdeG6rW4gSG/DoG5nIE1haTFCMEAG
        A1UECgw5Q8OUTkcgVFkgQ1AgROG7ikNIIFbhu6QgVsOAIEPDlE5HIE5HSOG7hiBT
        4buQIFFVQU5HIFRSVU5HMUIwQAYDVQQDDDlDw5RORyBUWSBDUCBE4buKQ0ggVuG7
        pCBWw4AgQ8OUTkcgTkdI4buGIFPhu5AgUVVBTkcgVFJVTkcxHjAcBgoJkiaJk/Is
        ZAEBDA5NU1Q6MDExMDE4ODA2NTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
        ggEBAJO6JDU+kNEUIiO6m75LOfgHkwGExYFv0tILHInS9CkK2k0FjmvU8VYJ0cQA
        sGGabpHIwfh07llLfK3TUZlhnlFZYRrYvuexlLWQydjHYPqT+1c3iYaiXXcOqEjm
        OupCj71m93ThFrYzzI2Zx07jccRptAAZrWMjI+30vJN7SDxhYsD1uQxYhUkx7psq
        MqD4/nOyaWzZHLU94kTAw5lhAlVOMu3/6pXhIltX/097Wji1eyYqHFu8w7q3B5yW
        gJYugEZfplaeLLtcTxok4VbQCb3cXTOSFiQYJ3nShlBd89AHxaVE+eqJaMuGj9z9
        rdIoGr9LHU/P6KF+/SLwxpsYgnkCAwEAAaOCAVUwggFRMAwGA1UdEwEB/wQCMAAw
        HwYDVR0jBBgwFoAUyCcJbMLE30fqGfJ3KXtnXEOxKSswgZUGCCsGAQUFBwEBBIGI
        MIGFMDIGCCsGAQUFBzAChiZodHRwczovL3Jvb3RjYS5nb3Yudm4vY3J0L3ZucmNh
        MjU2LnA3YjAuBggrBgEFBQcwAoYiaHR0cHM6Ly9yb290Y2EuZ292LnZuL2NydC9J
        LUNBLnA3YjAfBggrBgEFBQcwAYYTaHR0cDovL29jc3AuaS1jYS52bjA0BgNVHSUE
        LTArBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcKAwwGCSqGSIb3LwEBBTAj
        BgNVHR8EHDAaMBigFqAUhhJodHRwOi8vY3JsLmktY2Eudm4wHQYDVR0OBBYEFE6G
        FFM4HXne9mnFBZInWzSBkYNLMA4GA1UdDwEB/wQEAwIE8DANBgkqhkiG9w0BAQsF
        AAOCAQEAH5ifoJzc8eZegzMPlXswoECq6PF3kLp70E7SlxaO6RJSP5Y324ftXnSW
        0RlfeSr/A20Y79WDbA7Y3AslehM4kbMr77wd3zIij5VQ1sdCbOvcZXyeO0TJsqmQ
        b46tVnayvpJYW1wbui6smCrTlNZu+c1lLQnVsSrAER76krZXaOZhiHD45csmN4dk
        Y0T848QTx6QN0rubEW36Mk6/npaGU6qw6yF7UMvQO7mPeqdufVX9duUJav+WBJ/I
        Y/EdqKp20cAT9vgNap7Bfgv5XN9PrE+Yt0C1BkxXnfJHA7L9hcoYrknsae/Fa2IP
        99RyIXaHLJyzSTKLRUhEVqrycM0UXg==
        -----END CERTIFICATE-----
        """
        let lines = a.components(separatedBy: "\n")
        var base64EncodedString = ""
        var isReadingKey = false

        for line in lines {
            if line.hasPrefix("-----BEGIN CERTIFICATE-----") {
                isReadingKey = true
            } else if line.hasPrefix("-----END CERTIFICATE-----") {
                isReadingKey = false
                break
            } else if isReadingKey {
                base64EncodedString += line
            }
        }

        let pemWithoutHeaderFooterNewlines = base64EncodedString.trimmingCharacters(in: .whitespacesAndNewlines)
        let certData = Data(base64Encoded: pemWithoutHeaderFooterNewlines)!

        guard let certificate = SecCertificateCreateWithData(nil, certData as CFData) else {
            // handle error
            return nil
        }

        // use certificate e.g. copy the public key
        let publicKey = SecCertificateCopyKey(certificate)!
        return publicKey
    }
    
    
    
    static func createSecKeyFromPrivateKey(privateKeyPEM: String) -> SecKey? {
        // Extract base64-encoded key data from the PEM format
        guard let base64EncodedData = extractBase64EncodedData(fromPEM: privateKeyPEM) else {
            return nil
        }
        
        // Decode base64-encoded data
        guard let keyData = Data(base64Encoded: base64EncodedData, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        guard let test = try? CardManager.stripPrivateKeyHeader(keyData) else {
            return nil
        }
    
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: false
            ]
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateWithData(test as CFData, attributes as CFDictionary, &error) else {
            print(error!)
            return nil
        }
        return privateKey
    }

    static func extractBase64EncodedData(fromPEM pemString: String) -> String? {
        let lines = pemString.components(separatedBy: "\n")
        var base64EncodedString = ""
        var isReadingKey = false

        for line in lines {
            if line.hasPrefix("-----BEGIN PRIVATE KEY-----") {
                isReadingKey = true
            } else if line.hasPrefix("-----END PRIVATE KEY-----") {
                isReadingKey = false
                break
            } else if isReadingKey {
                base64EncodedString += line
            }
        }

        return base64EncodedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func stripPrivateKeyHeader(_ privkey: Data) throws -> Data? {
        if ( privkey.count == 0 ) {
            return nil
        }

        var keyAsArray = [UInt8](repeating: 0, count: privkey.count / MemoryLayout<UInt8>.size)
        (privkey as NSData).getBytes(&keyAsArray, length: privkey.count)

        //PKCS#8: magic byte at offset 22, check if it's actually ASN.1
        var idx = 22
        if ( keyAsArray[idx] != 0x04 ) {
            return privkey
        }
        idx += 1

        //now we need to find out how long the key is, so we can extract the correct hunk
        //of bytes from the buffer.
        var len = Int(keyAsArray[idx])
        idx += 1
        let det = len & 0x80 //check if the high bit set
        if (det == 0) {
            //no? then the length of the key is a number that fits in one byte, (< 128)
            len = len & 0x7f
        } else {
            //otherwise, the length of the key is a number that doesn't fit in one byte (> 127)
            var byteCount = Int(len & 0x7f)
            if (byteCount + idx > privkey.count) {
                return nil
            }
            //so we need to snip off byteCount bytes from the front, and reverse their order
            var accum: UInt = 0
            var idx2 = idx
            idx += byteCount
            while (byteCount > 0) {
                //after each byte, we shove it over, accumulating the value into accum
                accum = (accum << 8) + UInt(keyAsArray[idx2])
                idx2 += 1
                byteCount -= 1
            }
            // now we have read all the bytes of the key length, and converted them to a number,
            // which is the number of bytes in the actual key.  we use this below to extract the
            // key bytes and operate on them
            len = Int(accum)
        }
        return privkey.subdata(in: idx..<idx+len)
        //return privkey.subdata(in: NSMakeRange(idx, len).toRange()!)
    }
}
