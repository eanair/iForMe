import SwiftUI

struct MessageView: View {
  @State private var phoneNumber: String = ""
  @State private var spamNumbers: [String] = UserDefaults.standard.stringArray(forKey: "SpamNumbers") ?? []
  @State private var selectedOption: String = "시작 번호"
  let options = ["시작 번호", "끝 번호", "포함", "포함하지 않음"]

  var body: some View {
    VStack {
      HStack {
        TextField("전화번호를 입력하세요", text: $phoneNumber)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 10)

        Button(action: {
          if !phoneNumber.isEmpty {
            spamNumbers.append(phoneNumber)
            UserDefaults.standard.set(spamNumbers, forKey: "SpamNumbers")
            phoneNumber = ""
          }
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
            .padding(.trailing, 10)
        }
      }
      .padding()

      Picker("옵션 선택", selection: $selectedOption) {
        ForEach(options, id: \.self) { option in
          Text(option)
        }
      }
      .pickerStyle(MenuPickerStyle())
      .padding(.leading, 10)

      List(spamNumbers, id: \.self) { number in
        Text("\(selectedOption) 차단: \(number)")
      }
    }
  }
}

#Preview {
  MessageView()
}
