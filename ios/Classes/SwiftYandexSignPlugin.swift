import Flutter
import UIKit
import Security
import CommonCrypto
import Foundation

@available(iOS 10.0, *)
public class SwiftYandexSignPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yandex_sign", binaryMessenger: registrar.messenger())
    let instance = SwiftYandexSignPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  @available(iOS 10.0, *)
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "getSignUrl" else {
            result(FlutterMethodNotImplemented)
            return
        }
    self.getSignUrl(result: result, arguments: call.arguments)
  }

@available(iOS 10.0, *)
private func getSignUrl(result: FlutterResult, arguments: Any?) {
    guard let params = arguments as? [String: Any],
          let url = params["url"] as? String,
          let privateKey = params["key"] as? String,
          let key = try? privateKeyStringToSecKey(privateKeyString: privateKey) else {
        // Handle missing parameters or nil key
        result(nil)
        return
    }

    do {
        let signature = try signString(string: url, key: key)

        if let escapedSignature = signature.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            result(escapedSignature)
        } else {
            result(nil)
        }
    } catch {
        // Handle the error here
        print("Error signing the string: \(error)")
        result(nil)
    }
}


      @available(iOS 10.0, *)
      // Зашифровывает SHA256 с помощью DER-ключа.
      func signString(string: String, key: SecKey) -> String {
          let messageData = string.data(using:String.Encoding.utf8)!
          var hash = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

          _ = hash.withUnsafeMutableBytes {digestBytes in
              messageData.withUnsafeBytes {messageBytes in
                  CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
              }
          }

          let signature = SecKeyCreateSignature(key,
                                                SecKeyAlgorithm.rsaSignatureDigestPKCS1v15SHA256,
                                                hash as CFData,
                                                nil) as Data?

          return (signature?.base64EncodedString())!
      }
@available(iOS 10.0, *)
func privateKeyStringToSecKey(privateKeyString: String) throws -> SecKey? {
    // Remove the header and footer lines from the PEM string
    let strippedKeyString = privateKeyString
        .replacingOccurrences(of: "-----BEGIN RSA PRIVATE KEY-----", with: "")
        .replacingOccurrences(of: "-----END RSA PRIVATE KEY-----", with: "")
        .replacingOccurrences(of: "\n", with: "")

    // Convert the base64-encoded private key string to Data
    guard let privateKeyData = Data(base64Encoded: strippedKeyString) else {
        throw CryptoError.invalidPrivateKey
    }

    
    // Define the key attributes
    let keyAttributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass as String: kSecAttrKeyClassPrivate
    ]

    // Create the key reference
    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateWithData(privateKeyData as CFData, keyAttributes as CFDictionary, &error) else {
        if let errorDescription = error?.takeRetainedValue() as? NSError {
            print("Error creating private key: \(errorDescription)")
        }
        throw CryptoError.failedToCreatePrivateKey
    }

    return privateKey
}



}
enum CryptoError: Error {
    case invalidPrivateKey
    case failedToCreatePrivateKey
}

