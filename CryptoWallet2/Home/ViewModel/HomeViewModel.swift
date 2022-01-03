import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$coins
            .sink { coins in
                self.allCoins = coins
            }
            .store(in: &cancellables)
    }
}
