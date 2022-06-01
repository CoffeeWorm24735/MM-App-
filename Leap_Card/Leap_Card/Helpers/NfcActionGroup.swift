//
//  NfcActionGroup.swift
//  Leap_Card
//
//  Created by Charlie Brady on 24/08/2021.
//

import os
import CoreNFC
import UIKit
import Foundation
import SwiftUI

class NfcActionGroup:UITableViewController, NFCTagReaderSessionDelegate {
    var readerSession: NFCTagReaderSession?
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("NFC Session became active")
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFC Session end \(error)")
    }
    

   
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("yat")
        var card: NFCTag? = nil
        
        // Validate that the card is a MiFare DesFire
        for nfcTag in tags {
            
            if case let .miFare(mifareTag) = nfcTag {
                if mifareTag.mifareFamily == .desfire {
                    card = nfcTag
                    print("MiFare")
                    break
                }
            }
        }
        
        if card == nil {
            session.invalidate(errorMessage: "No valid coupon found 1.")
            return
        }
        
        session.connect(to: card!) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
         
        }
    
    
    //Obtaian the uid
        
        
        
        
  
        if case let NFCTag.miFare(tag) = tags.first! {
            session.connect(to: tags.first!) { (error: Error?) in
              
                
                let apdu = NFCISO7816APDU(instructionClass: 0, instructionCode: 0xB0, p1Parameter: 0, p2Parameter: 0, data: Data(), expectedResponseLength: 16)
                tag.sendMiFareISO7816Command(apdu) { (apduData, sw1, sw2, error) in
                    let tagUIDData = tag.identifier
                    var byteData: [UInt8] = []
                    tagUIDData.withUnsafeBytes { byteData.append(contentsOf: $0) }
                    var uidString = ""
                    for byte in byteData {
                        let decimalNumber = String(byte, radix: 16)
                        if (Int(decimalNumber) ?? 0) < 10 { // add leading zero
                            uidString.append("0\(decimalNumber)")
                        } else {
                            uidString.append(decimalNumber)
                        }
                    }
                    debugPrint("\(byteData) converted to Tag UID: \(uidString)")
                    self.SendCommand(from: card!)
                   
                }
            }
        }
    
    
    }
// USe the SendCommand func to read ech valkue needed
    func ReadData(_ data: Data, to tag: NFCMiFareTag, _ completionHandler: @escaping (Data) -> Void){
        tag.sendMiFareCommand(commandPacket: data) { (result: Result<Data, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response)
            case .failure(let error):
                self.readerSession?.invalidate(errorMessage: "Read tag error: \(error.localizedDescription). Please try again.")
            }
        }
       // print(tag.historicalBytes as Data)
        print(tag.identifier as NSData)

        }
    
    
    
    
    
// Send read command and return value
    func SendCommand(from tag: NFCTag){
        guard case let .miFare(mifareTag) = tag else {
            return
        }
        let blockSize = 16
        // T2T Read command, returns 16 bytes in response.
        let readBlock4: [UInt8] = [0x40, 0x16]
        let magicSignature: [UInt8] = [0xFE, 0x01]
        let useCounterOffset = 2
        let lengthOffset = 3
        let headerLength = 4
        let maxCodeLength = 16
        
        ReadData(Data(readBlock4), to: mifareTag) { (responseBlock4: Data) in
            // Validate magic signature and use counter
            if !responseBlock4[0...1].elementsEqual(magicSignature) || responseBlock4[useCounterOffset] < 1 {
                print(responseBlock4 as NSData)
                self.readerSession?.invalidate(errorMessage: "No valid coupon found 2 .")
                return
            }
    }
   
    }
    

    func scanCard() {
       
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        print("Active bro")
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        readerSession?.alertMessage = "Hold your iPhone near a Leap Card ."
        readerSession?.begin()

    }
}
    

