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
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.merchantCapabilities = .capability3DS
        request.paymentSummaryItems = paymentSummeryItems()
        request.shippingMethods = shippingMethods()
        request.requiredShippingAddressFields = [.email, .phone]
        
        return request
    }
    
    func paymentSummeryItems(shipAmount: Double = 0.0)->[PKPaymentSummaryItem] {
        let subtotal = PKPaymentSummaryItem(label: "Sub Total", amount: NSDecimalNumber(value: 20.0))
        let servTax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(value: -5))
        
        let shippingAmount = PKPaymentSummaryItem(label: "Shipping Charge", amount: NSDecimalNumber(value: shipAmount))
        
        let totalAmount = subtotal.amount.adding(servTax.amount).adding(shippingAmount.amount)
        let total = PKPaymentSummaryItem(label: "Total Amounts", amount: totalAmount)
        
        return [subtotal, servTax, shippingAmount, total]
    }
    
    func shippingMethods()-> [PKShippingMethod] {
        let twoDaysDelivery = PKShippingMethod(label: "Super Fast Shipping.", amount: NSDecimalNumber(value: 15))
        twoDaysDelivery.identifier = "s_fast_shipping"
        twoDaysDelivery.detail = "Shipping withing 2 days"
        
        let normalDelevery = PKShippingMethod(label: "Fast Shipping", amount: NSDecimalNumber(value: 10))
        normalDelevery.identifier = "fast_shipping"
        normalDelevery.detail = "Shipping withing 4-5 days"

        let free = PKShippingMethod(label: "Free Shipping", amount: NSDecimalNumber(value: 0))
        free.identifier = "free_shipping"
        free.detail = "Shipping withing 7-8 days"

        return [free, twoDaysDelivery, normalDelevery]
    }
    
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(.success, paymentSummeryItems(shipAmount: Double(shippingMethod.amount)))
    }
}

