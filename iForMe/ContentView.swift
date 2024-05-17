import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
        Button(action: {
          if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: CalculatorView())
            window.makeKeyAndVisible()
          }
        }) {
          Text("계산기")
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .gridCellAnchor(.leading)
        .gridCellColumns(1)

        Button(action: {
          if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: MessageView())
            window.makeKeyAndVisible()
          }
        }) {
          Text("스팸번호차단")
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .gridCellAnchor(.leading)
        .gridCellColumns(1)

        ForEach(2 ..< 9) { _ in
          Button(action: {}) {
            Text("")
              .padding()
              .background(Color.gray)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
