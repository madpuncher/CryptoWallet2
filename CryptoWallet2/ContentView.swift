import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("ACCENT")
                .foregroundColor(Color.theme.accent)
            
            Text("GREEN")
                .foregroundColor(Color.theme.green)

            Text("RED")
                .foregroundColor(Color.theme.red)

            Text("SECONDARY")
                .foregroundColor(Color.theme.secondaryText)
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
