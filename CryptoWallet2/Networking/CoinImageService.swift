import Combine
import UIKit

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    var imageCancellable = Set<AnyCancellable>()
    
    private let fileManager = LocalFileManager.shared
    private let folderName = "coin_images"
    private let coin: Coin
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImageFromFM()
    }
    
    private func getCoinImageFromFM() {
        if let savedImage = fileManager.getImage(imageName: coin.id,
                                            folderName: folderName) {
            image = savedImage
        } else {
            getCoinImage(urlString: coin.image)
        }
    }
    
    private func getCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        NetworkingManager.download(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] value in
                guard
                    let self = self,
                    let downloadedImage = value else { return }
                self.image = value
                self.fileManager.saveImage(image: downloadedImage,
                                            imageName: self.imageName,
                                            folderName: self.folderName)
            })
            .store(in: &imageCancellable)
    }
}
