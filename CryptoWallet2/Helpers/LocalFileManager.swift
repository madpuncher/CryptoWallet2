import Foundation
import SwiftUI

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    private init() {}
    
    public func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(name: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
            }
        return UIImage(contentsOfFile: url.path)
    }
    
    public func saveImage(image: UIImage, imageName: String, folderName: String) {
        //CreateFolder
        createFolderIfNeeded(folderName: folderName)
        
        //Get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(name: imageName, folderName: folderName) else {
                return
            }
        
        //Save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image to FM: \(error) \nImage name: \(imageName)")
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(name: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory for FM: \(error)")
            }
        }
    }
    
    private func getURLForFolder(name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(name)
    }
    
    private func getURLForImage(name: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(name: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(name + ".png")
    }
}
