//
//  HomeView.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import SwiftUI

struct HomeView: View {

    typealias Dimens = HomeViewConstans.Dimensions
    typealias Strings = HomeViewConstans.Strings

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        if viewModel.isLoading {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                Spacer()
            }
            .task {
                await viewModel.fetchAll()
            }
        } else if viewModel.loadingError {
            VStack(alignment: .center) {
                Spacer()
                Text(Strings.errorMessage)
                    .foregroundStyle(Color.red.opacity(Dimens.errorOpacity))
                    .font(.headline)
                Spacer()
            }.refreshable {
                await viewModel.fetchAll()
            }
        } else {
            content()
        }
    }

    private func content() -> some View {
        ScrollView {
            LazyVStack(spacing: Dimens.spacing18) {
                ForEach(viewModel.sections, id: \.id) { section in
                    horizontalScroll(section: section)
                }
            }
        }
        .sheet(item: $viewModel.selectedMedia) { _ in
            MediaDetailsView(viewModel: .init(media: $viewModel.selectedMedia))
        }
        .refreshable {
            await viewModel.fetchAll()
        }
    }

    private func horizontalScroll(section: MediaSection) -> some View {
        VStack(alignment: .leading, spacing: Dimens.zero) {
            Text("\(section.title) \(section.type == .movie ? Strings.movies : Strings.series)")
                .font(.system(.title3))
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Dimens.horizontalSpacing) {
                    ForEach(section.list,
                            id: \.id) { media in
                        Button {
                            viewModel.selectedMedia = media
                        } label: {
                            CacheAsyncImage(urlString: media.posterPath.relativeURL, 
                                            placeholder: media.title)
                                .frame(width: Dimens.imageWidth,
                                       height: Dimens.imageHeight)
                        }
                    }
                }
                .padding(.top, Dimens.spacing18)
            }
        }
        .padding(.leading, Dimens.leadingPadding)
    }
}

#Preview {
    HomeView(viewModel: .init(genreUseCase: FindGenreUseCase(moviesRepo: MediaRepositoryMock(),
                                                             series: MediaRepositoryMock()),
                              filterByUserCase: FindByFilterContentUseCase(moviesRepo: MediaRepositoryMock(), series: MediaRepositoryMock())))
}
