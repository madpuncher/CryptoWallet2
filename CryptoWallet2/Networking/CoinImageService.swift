import Combine
import UIKit

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    var imageCancellable = Set<AnyCancellable>()
    
    init(urlImage: String) {
        getCoinImage(urlString: urlImage)
    }
    
    private func getCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        NetworkingManager.download(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] value in
                self?.image = value
            })
            .store(in: &imageCancellable)
    }
}
