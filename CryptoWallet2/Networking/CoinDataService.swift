import Combine
import Foundation

class CoinDataService {
        
    @Published var coins = [Coin]()
    var cancellable = Set<AnyCancellable>()
    
    struct Constants {
        static let url =  "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    }
    
    init() {
        getCoins()
    }
    
        
    private func getCoins() {
        guard let url = URL(string: Constants.url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { completion in
                //
            } receiveValue: { value in
                self.coins = value
            }
            .store(in: &cancellable)

    }
}
