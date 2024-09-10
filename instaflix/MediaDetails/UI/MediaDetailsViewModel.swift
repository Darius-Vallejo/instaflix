//
//  MediaDetailsViewModel.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import SwiftUI

class MediaDetailsViewModel: ObservableObject {
    @Binding var media: Media?

    init(media: Binding<Media?>) {
        self._media = media
    }
}
