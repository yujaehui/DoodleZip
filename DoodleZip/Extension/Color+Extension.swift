//
//  Color+Extension.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/19/25.
//

import SwiftUI

extension Color {
    func toHex() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        
        let r = Int((components[0] * 255).rounded())
        let g = Int((components[1] * 255).rounded())
        let b = Int((components[2] * 255).rounded())
        
        if components.count >= 4 {
            let a = Int((components[3] * 255).rounded())
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
    
    init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if hexSanitized.hasPrefix("#") {
                hexSanitized.remove(at: hexSanitized.startIndex)
            }
            
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let r, g, b, a: Double
            
            switch hexSanitized.count {
            case 6:
                r = Double((rgb >> 16) & 0xFF) / 255.0
                g = Double((rgb >> 8) & 0xFF) / 255.0
                b = Double(rgb & 0xFF) / 255.0
                a = 1.0
            case 8:
                r = Double((rgb >> 24) & 0xFF) / 255.0
                g = Double((rgb >> 16) & 0xFF) / 255.0
                b = Double((rgb >> 8) & 0xFF) / 255.0
                a = Double(rgb & 0xFF) / 255.0
            default:
                r = 0
                g = 0
                b = 0
                a = 1.0
            }
            
            self.init(red: r, green: g, blue: b, opacity: a)
        }
}
