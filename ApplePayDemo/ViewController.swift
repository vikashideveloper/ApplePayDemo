//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Vikash Kumar on 16/06/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setApplePayButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Set Payment Button
    func setApplePayButton() {
        let payBtn = PKPaymentButton(type: .buy, style: .black)
        payBtn.center = self.view.center
        payBtn.addTarget(self, action: #selector(self.applePay_btnClicked), for: .touchUpInside)
        self.view.addSubview(payBtn)
    }

    func applePay_btnClicked() {
        let paymentNetwroks: [PKPaymentNetwork] = [.visa, .amex, .masterCard]
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentNetwroks) {
            let paymentRequest = createPaymentRequest()
            paymentRequest.supportedNetworks = paymentNetwroks
            let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationVC.delegate = self
            self.present(paymentAuthorizationVC, animated: true, completion: nil)
        }
    }
    
    func createPaymentRequest()-> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.applepay.vikash"
        request.countryCode = "IN"
        request.currencyCode = "INR"
        request.merchantCapabilities = .capability3DS
        request.paymentSummaryItems = paymentSummeryItems()
        return request
    }
    
    func paymentSummeryItems()->[PKPaymentSummaryItem] {
        let subtotal = PKPaymentSummaryItem(label: "Sub Total", amount: NSDecimalNumber(value: 20.0))
        let servTax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(value: -5))
        
        let total = subtotal.amount.doubleValue + servTax.amount.doubleValue
        let totalItem = PKPaymentSummaryItem(label: "Total Amounts", amount: NSDecimalNumber(value: total))
        
        return [subtotal, servTax, totalItem]
    }
    
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(.success)
    }
}

