//
//  MediaDetailsViewConstants.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 10/09/24.
//

import Foundation

struct MediaDetailsViewConstants {
    struct Dimensions {
        static let imageOpacity: CGFloat = 0.7
        static let blurRadius: CGFloat = 1
        static let imagePadding: CGFloat = -200
        static let backgroundImageHeight: CGFloat = 400
        static let verticalStackSpacing: CGFloat = 15
        static let foregroundImageWidth: CGFloat = 119
        static let foregroundImageHeight: CGFloat = 180
        static let cornerRadius: CGFloat = 7
        static let padding15: CGFloat = 15
        static let playImageSize: CGFloat = 17
        static let buttonSize: CGFloat = 40
        static let buttonCorners: CGFloat = 3
        static let padding20: CGFloat = 20
        static let downloadImageSize: CGFloat = 20
        static let buttonDownloadOpacity: CGFloat = 0.4
        static let buttonDownloadBlur: CGFloat = 0.8
        static let padding9: CGFloat = 9
    }

    /// Strings for localizaition
    struct Strings {
        static let play = "Play"
        static let download = "Download"
    }

    struct Assets {
        static let playImage = "play.fill"
        static let downloadImage = "square.and.arrow.down"
        static let closeImage = "xmark"
    }
}
