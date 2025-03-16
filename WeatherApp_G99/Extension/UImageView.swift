//
//  ImageViewExtension.swift
//  WeatherApp_G99
//
//  Created by Ali Mousavi Roozbahani  on 2025-03-15.
//

import UIKit

fileprivate let sharedImageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    /// Loads an image from a URL string with caching support using `URLSession`.
    func setImage(from urlString: String) {
        self.image = nil
        
        // Check cache
        if let cachedImage = sharedImageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Download image
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Image download error:", error.localizedDescription)
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("Invalid image data for URL:", urlString)
                return
            }
            
            // Cache and set the image
            sharedImageCache.setObject(downloadedImage, forKey: urlString as NSString)
            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
    
    /// Loads image from URL using simple `Data(contentsOf:)` and async dispatching, with caching.
    func setImageFast(from urlString: String) {
        self.image = nil
        
        if let cachedImage = sharedImageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                print("Failed to load image from:", urlString)
                return
            }
            
            sharedImageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
