import SwiftUI

struct CalculatorView: View {
  @State private var display = "0"
  @State private var currentNumber: Double = 0
  @State private var previousNumber: Double = 0
  @State private var operation: String? = nil

  let buttons: [[String]] = [
    ["x!", "x^y", "log", "√"],
    ["rad", "sin", "cos", "tan"],
    ["±", "π", "e", "ln"],
    ["(", ")", "C", "÷"],
    ["7", "8", "9", "×"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "+"],
    ["0", ".", "="],
  ]

  var body: some View {
    VStack {
      Spacer()
      Text(display)
        .font(.largeTitle)
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color(hex: "#282828"))

      ForEach(buttons, id: \.self) { row in
        HStack {
          ForEach(row, id: \.self) { button in
            Button(action: {
              self.buttonTapped(button)
            }) {
              Text(button)
                .font(.title)
                .frame(width: button == "0" ? 150 : 70, height: 70)
                .background(Color(hex: "#565656"))
                .foregroundColor(.white)
                .cornerRadius(0)
                .padding(5)
            }
          }
        }
      }
    }
    .padding()
    .background(Color(hex: "#282828"))
  }

  func buttonTapped(_ button: String) {
    switch button {
    case "0" ... "9":
      if display == "0" {
        display = button
      } else {
        display += button
      }
      currentNumber = Double(display) ?? 0
    case ".":
      if !display.contains(".") {
        display += button
      }
    case "÷", "×", "-", "+":
      operation = button
      previousNumber = currentNumber
      display = "0"
    case "=":
      if let operation = operation {
        switch operation {
        case "÷":
          currentNumber = previousNumber / currentNumber
        case "×":
          currentNumber = previousNumber * currentNumber
        case "-":
          currentNumber = previousNumber - currentNumber
        case "+":
          currentNumber = previousNumber + currentNumber
        case "^":
          currentNumber = pow(previousNumber, currentNumber)
        default:
          break
        }
        display = currentNumber.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(currentNumber))" : "\(currentNumber)"
        self.operation = nil
      }
    case "C":
      display = "0"
      currentNumber = 0
      previousNumber = 0
      operation = nil
    case "(", ")":
      // 괄호 기능은 현재 구현되지 않음
      break
    case "±":
      currentNumber = -currentNumber
      display = "\(currentNumber)"
    case "x^y":
      operation = "^"
      previousNumber = currentNumber
      display = "0"
    case "log":
      currentNumber = log10(currentNumber)
      display = "\(currentNumber)"
    case "ln":
      currentNumber = log(currentNumber)
      display = "\(currentNumber)"
    case "√":
      currentNumber = sqrt(currentNumber)
      display = "\(currentNumber)"
    case "x!":
      currentNumber = factorial(currentNumber)
      display = "\(currentNumber)"
    case "sin":
      currentNumber = sin(currentNumber)
      display = "\(currentNumber)"
    case "cos":
      currentNumber = cos(currentNumber)
      display = "\(currentNumber)"
    case "tan":
      currentNumber = tan(currentNumber)
      display = "\(currentNumber)"
    case "e":
      currentNumber = M_E
      display = "\(currentNumber)"
    case "π":
      currentNumber = Double.pi
      display = "\(currentNumber)"
    case "rad":
      currentNumber = currentNumber * Double.pi / 180
      display = "\(currentNumber)"
    default:
      break
    }
  }

  func factorial(_ n: Double) -> Double {
    if n == 0 {
      return 1
    }
    return n * factorial(n - 1)
  }
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 1
    var rgbValue: UInt64 = 0
    scanner.scanHexInt64(&rgbValue)
    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0
    self.init(red: red, green: green, blue: blue)
  }
}

#Preview {
  CalculatorView()
}
