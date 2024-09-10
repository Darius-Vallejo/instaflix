//
//  MediaDetailsView.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import SwiftUI

struct MediaDetailsView: View {

    typealias Dimens = MediaDetailsViewConstants.Dimensions
    typealias Strings = MediaDetailsViewConstants.Strings
    typealias Assets = MediaDetailsViewConstants.Assets

    @ObservedObject var viewModel: MediaDetailsViewModel

    var body: some View {
            ZStack {
                CacheAsyncImage(urlString: viewModel.media?.backdropPath.relativeURL ?? "",
                                colorForFilling: Color.gray.opacity(Dimens.imageOpacity),
                                contentMode: .fill,
                                placeholder: "")
                .blur(radius: Dimens.blurRadius)
                .padding(.top, Dimens.imagePadding)
                .frame(height: Dimens.backgroundImageHeight)
                .frame(maxWidth: .infinity)


                VStack(alignment: .center, spacing: Dimens.verticalStackSpacing) {
                    CacheAsyncImage(urlString: viewModel.media?.posterPath.relativeURL ?? "",
                                    colorForFilling: Color.gray,
                                    placeholder: viewModel.media?.title ?? "")
                    .frame(width: Dimens.foregroundImageWidth, height: Dimens.foregroundImageHeight)
                    .customCornerRadius(radius: Dimens.cornerRadius)
                    .padding(.top, Dimens.padding15)

                    Button(action: {
                        //TODO: create playing function
                    }, label: {
                        HStack(alignment: .center, spacing: Dimens.padding15) {
                            Image(systemName: Assets.playImage)
                                .resizable()
                                .foregroundStyle(Color.black)
                                .frame(width: Dimens.playImageSize, height: Dimens.playImageSize)
                            Text(Strings.play)
                                .font(.system(.headline))
                                .foregroundStyle(Color.black)
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: Dimens.buttonSize)
                    .background(Color
                        .white
                        .customCornerRadius(radius: Dimens.buttonCorners))
                    .padding(.horizontal, Dimens.padding20)
                    .padding(.top, Dimens.padding15)

                    Button(action: {
                        //TODO: create downloading function
                    }, label: {
                        HStack(alignment: .center, spacing: Dimens.padding15) {
                            Image(systemName: Assets.downloadImage)
                                .resizable()
                                .foregroundStyle(Color.white)
                                .frame(width: Dimens.downloadImageSize, height: Dimens.downloadImageSize)
                            Text(Strings.download)
                                .font(.system(.headline))
                                .foregroundStyle(Color.white)
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: Dimens.buttonSize)
                    .background(Color
                        .white
                        .opacity(Dimens.buttonDownloadOpacity)
                        .blur(radius: Dimens.buttonDownloadBlur)
                        .customCornerRadius(radius: Dimens.buttonCorners))
                    .padding(.horizontal, Dimens.padding20)

                    VStack {
                        Text(viewModel.media?.overview ?? "")
                            .font(.system(.title3))
                            .padding()

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }
                .background(Color
                    .black
                    .opacity(Dimens.buttonDownloadBlur)
                    .blur(radius: Dimens.blurRadius))
                .clipped()

                VStack {
                    HStack(alignment: .top) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                viewModel.media = nil
                            }
                        }, label: {
                            Image(systemName: Assets.closeImage)
                                .resizable()
                                .frame(width: Dimens.downloadImageSize,
                                       height: Dimens.downloadImageSize)
                                .foregroundStyle(Color.white)
                        })
                        Spacer()
                    }
                    .padding(.horizontal, Dimens.padding9)
                    .padding(.top, Dimens.padding15)
                    Spacer()
                }
            }
            .clipped()
        }

}

struct MediaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailsView(viewModel: .init(media: .constant(Media(id: 1,
                                                                 originalLanguage: .en,
                                                                 originalTitle: "Title",
                                                                 title: "Title",
                                                                 posterPath: .init(value: ""),
                                                                 backdropPath: .init(value: ""),
                                                                 overview: "DEtails"))))
    }
}
