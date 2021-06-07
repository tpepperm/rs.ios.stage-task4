import Foundation

public extension Int {
    
    var roman: String? {
        guard self > 0 && self < 4000 else { return nil }
        var integer = self
        var string = ""
        let romanNumbers: [Int: String] = [
            1000: "M",
            900: "CM",
            500: "D",
            400: "CD",
            100: "C",
            90: "XC",
            50: "L",
            40: "XL",
            10: "X",
            9: "IX",
            5: "V",
            4: "IV",
            1: "I"
        ]
        for number in romanNumbers.sorted(by: { $0.key > $1.key }) {
            while (integer >= number.key) {
                integer -= number.key
                string += romanNumbers[number.key] ?? ""
            }
        }
        return string
    }
}
