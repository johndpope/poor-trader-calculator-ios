//
//  Calculator.swift
//  PoorTraderCalculator
//
//  Created by Maricris Esgana on 25/04/2018.
//  Copyright © 2018 Maricris Esgana. All rights reserved.
//

import Foundation

struct Calculator {
    
    static func commission(price: Double, shares: Int, commission_pct: Double = 0.0025) -> Double {
        let value = price * Double(shares)
        let com = value * commission_pct
        return com > 20.0 ? com: 20.0
    }
    
    static func buying_fees(price: Double, shares: Int, commission_pct: Double=0.0025, vat_on_commission: Double=0.12, pse_trans_fee: Double=0.00005, sccp: Double=0.0001) -> Double {
        let value = price * Double(shares)
        let com = commission(price: price, shares: shares, commission_pct: commission_pct)
        let vat_com = com * vat_on_commission
        let trans = value * pse_trans_fee
        let sccp_fee = value * sccp
        return com + vat_com + trans + sccp_fee
    }
    
    static func selling_fees(price: Double, shares: Int, sales_tax:Double=0.006) -> Double {
        let buy_fees = buying_fees(price: price, shares: shares)
        let value = price * Double(shares)
        let tax = value * sales_tax
        return buy_fees + tax
    }

    static func boardlot(price: Double) -> Int {
        let boardlot_list = [(0.0001,1000000),
                             (0.010,100000),
                             (0.050,10000),
                             (0.250,10000),
                             (0.50,1000),
                             (5.00,100),
                             (10.00,100),
                             (20.00,100),
                             (50.00,10),
                             (100.00,10),
                             (200.00,10),
                             (500.00,10),
                             (1000,5),
                             (2000,5),
                             (5000,5)]
        
        for (startPrice, bl) in boardlot_list.reversed() {
            if startPrice <= price {
                return bl
            }
        }
        return 0
    }
    
    static func suggested_shares(price: Double) -> Int {
        let lot = boardlot(price:price)
        var lot_mult = 1
        var _shares = lot
        while commission(price:price, shares:_shares) == 20 {
            lot_mult += 1
            _shares = lot_mult * lot
        }
        return _shares
    }
    
    static func CPR_output(equity: Double, price: Double, riskPct: Double, unitRiskPct: Double) -> String {
        let C = equity * riskPct
        let R = price * unitRiskPct
        let P = C/R
        let lot = boardlot(price: price)
        var lot_mult = Int(P/Double(lot))
        lot_mult = lot_mult <= 0 ? 1 : lot_mult
        let _shares = lot_mult * lot
        let total_risk = Double(_shares) * R
        let buy_value = price * Double(_shares) + buying_fees(price: price, shares: _shares)
        return "Suggested shares based on CPR: \(_shares) \nEquity: \(equity) \nBUY: \(price), \(_shares): \(buy_value) \nTOTAL RISK: \(total_risk)"
    }
    
    static func minimum_values_output(price: Double, shares: Int) -> String {
        let buy_value = price * Double(shares) + buying_fees(price:price, shares:shares)
        var sell_price = price
        var sell_value = sell_price * Double(shares) - selling_fees(price: price, shares: shares)
        var pnl = sell_value - buy_value
        while pnl < 0 {
            sell_price = sell_price + 0.0001
            sell_value = sell_price * Double(shares) - selling_fees(price: price, shares: shares)
            pnl = sell_value - buy_value
        }
        return String(format: "\n\nBUY: \(price), \(shares): %.4f \nSELL: %.4f, \(shares): %.4f PnL: %.2f", buy_value, sell_price, sell_value, pnl)
    }
    
}

