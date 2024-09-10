//
//  CacheAsyncImage.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import SwiftUI
import AlamofireImage
import Alamofire

struct CacheAsyncImage: View {
    @State private var image: SwiftUI.Image? = nil
    @State private var isLoading: Bool = false
    let urlString: String
    let colorForFilling: Color
    let contentMode: ContentMode
    let placeholder: String

    init(image: SwiftUI.Image? = nil,
         urlString: String,
         colorForFilling: Color = .gray,
         contentMode: ContentMode = .fit,
         placeholder: String) {
        self.image = image
        self.urlString = urlString
        self.colorForFilling = colorForFilling
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ZStack {
                    Rectangle()
                        .fill(colorForFilling)
                    if isLoading {
                        ProgressView()
                    } else {
                        Text(placeholder)
                            .foregroundStyle(Color.white)
                            .font(.caption)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .dynamicTypeSize(.large...DynamicTypeSize.xxxLarge)

                    }
                }
                .onAppear {
                    downloadImage(from: urlString)
                }
            }
        }
    }

    func downloadImage(from url: String) {
        isLoading = true
        if let imageUrl = URL(string: url) {
            AF.request(imageUrl).responseImage { response in
                isLoading = false
                if case .success(let image) = response.result {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: image)
                    }
                } else if case .failure(let error) = response.result {
                    print("Error fetching image: \(error)")

                }
            }
        }
    }
}

