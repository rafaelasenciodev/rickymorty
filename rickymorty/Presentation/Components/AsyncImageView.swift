//
//  AsyncImageView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 24/4/24.
//

import SwiftUI

struct AsyncImageView: View {
    
    let url: URL
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .tint(.blue)
            }
        }
        .onAppear {
            Task {
                image = try? await downloadImage(url: url)
            }
        }
    }
    
    private func downloadImage(url: URL) async throws -> UIImage {
        let cache = NSCacheStorage<String, UIImage>()
        
        if let cachedImage = cache[url.absoluteString] {
            return cachedImage
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache[url.absoluteString] = image
                return image
            }
        } catch{
            throw ImageError.downloadFailed
        }
        
        throw ImageError.downloadFailed
    }
    
    enum ImageError: Error {
        case downloadFailed
    }
}
