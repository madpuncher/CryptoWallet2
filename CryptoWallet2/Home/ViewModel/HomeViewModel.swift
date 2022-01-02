import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
        
    }
}
