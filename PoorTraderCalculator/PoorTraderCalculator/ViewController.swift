//
//  ViewController.swift
//  PoorTraderCalculator
//
//  Created by Maricris Esgana on 26/04/2018.
//  Copyright © 2018 Maricris Esgana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var equity:Double = 1000000.0
    var riskPct:Double = 0.02
    var unitRiskPct:Double = 0.2
    var shares:Int = 0
    var price:Double = 0.0
    
    var cprOutput = ""
    var minValuesOutput = ""
    var minSharesByPrice = ""

    @IBOutlet weak var displayTextView: UITextView!
    
    @IBOutlet weak var equityTextField: UITextField!
    
    @IBOutlet weak var totalRiskTextField: UITextField!
    
    @IBOutlet weak var unitRiskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        equityTextField.text = String(self.equity)
        totalRiskTextField.text = String(self.riskPct)
        unitRiskTextField.text = String(self.unitRiskPct)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDisplay() {
        let display = String(self.cprOutput + self.minSharesByPrice + self.minValuesOutput)
        displayTextView.text = display
        print(display)
    }
    
    func updateCPROutput() {
        if self.price > 0, self.equity > 0, self.riskPct > 0, self.unitRiskPct > 0 {
            self.cprOutput = Calculator.CPR_output(equity: self.equity, price: self.price, riskPct: self.riskPct, unitRiskPct: self.unitRiskPct)
        }
    }
    
    func updateMinValuesOutput() {
        if self.shares > 0 {
            self.minValuesOutput = Calculator.minimum_values_output(price: self.price, shares: self.shares)
        }
    }
    
    @IBAction func updateCPR(_ sender: UITextField) {
        if let _text = sender.text, let _ = Double(_text) {
            if let _equityText = equityTextField.text, let _equity = Double(_equityText), self.equity != _equity {
                self.equity = _equity
            }
            if let _totalRiskText = totalRiskTextField.text, let _riskPct = Double(_totalRiskText), self.riskPct != _riskPct {
                self.riskPct = _riskPct
            }
            if let _unitRiskText = unitRiskTextField.text, let _unitRisk = Double(_unitRiskText), self.unitRiskPct != _unitRisk {
                self.unitRiskPct = _unitRisk
            }
            updateCPROutput()
            updateDisplay()
        }
    }
    
    @IBAction func updateShares(_ sender: UITextField) {
        if let _shares = sender.text, let _shares_value = Int(_shares) {
            if _shares_value != self.shares {
                self.shares = _shares_value
                updateMinValuesOutput()
                updateDisplay()
            }
        }
    }
    
    @IBAction func updatePrice(_ sender: UITextField) {
        if let _price = sender.text, let _price_value = Double(_price) {
            if _price_value != self.price {
                self.price = _price_value
                self.minSharesByPrice = "\n\nSuggested shares based on price: \(Calculator.suggested_shares(price: self.price))\n"
                updateCPROutput()
                updateDisplay()
            }
        }
    }
}

