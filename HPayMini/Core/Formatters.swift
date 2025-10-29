//
//  Formatters.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation
import SwiftUI

enum Money {
    static let decimal: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "US")   // Arabic (Saudi)
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static func format(_ value: Decimal) -> String {
        let ns = NSDecimalNumber(decimal: value)
        return decimal.string(from: ns) ?? ns.stringValue
    }
}
let size = UIScreen.main.bounds


struct RiyalAmountView: View {
    let amount: Decimal
    var symbolImageName: String = "sar" // put your image in Assets
    var color: Color = Color(red: 0.38, green: 0.27, blue: 0.23) // brown-ish

    var body: some View {
        HStack(spacing: 6) {
            Image(symbolImageName)
                .resizable()
                .renderingMode(.template)     // ensure template at runtime
                   .foregroundStyle(color)
                .frame(width: 16, height: 16)
                // align the icon with text baseline
                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                .baselineOffset(1)

            Text(Money.format(amount))
                .font(.system(size: 18, weight: .semibold))
                .monospacedDigit()
        }
        .foregroundStyle(color)
        // keep the order (icon then number) even in RTL UIs:
        .environment(\.layoutDirection, .leftToRight)
    }
}


extension DateFormatter {
    static let tx: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()
}
