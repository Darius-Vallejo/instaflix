//
//  HomeViewModel.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var genreUseCase: FindGenreUseCaseProtocol
    var filterByUserCase: FindByFilterContentUseCaseProtocol
    @Published var sections: [MediaSection] = []
    @Published var isLoading: Bool = true
    @Published var loadingError: Bool = false
    @Published var selectedMedia: Media?

    init(genreUseCase: FindGenreUseCaseProtocol, filterByUserCase: FindByFilterContentUseCaseProtocol) {
        self.genreUseCase = genreUseCase
        self.filterByUserCase = filterByUserCase
    }

    @MainActor
    func fetchAll() async {
        sections = []
        await fetchGenders()
        await fetchManyCategories()
    }

    @MainActor
    private func fetchGenders() async {
        do {
            let newGenders = try await genreUseCase.execute()
            setSections(newSections: newGenders + sections)
            isLoading = false
        } catch {
            loadingError = true
            isLoading = false
            print("error VM \(error)")
        }
    }

    @MainActor
    private func fetchManyCategories() async {
        do {
            let additionalCategories = try await filterByUserCase.execute(category: CustomFilterCategory.language(.en), CustomFilterCategory.language(.fr), CustomFilterCategory.minVote(7))

            setSections(newSections: additionalCategories + sections)
            isLoading = false
        } catch {
            loadingError = true
            isLoading = false
            print("error VM \(error)")
        }
    }

    private func setSections(newSections: [MediaSection]) {
        let uniqueSectionsDict = Dictionary((sections + newSections).map { ($0.id, $0) },
                                            uniquingKeysWith: { (first, _) in first })
        let uniqueSections = Array(uniqueSectionsDict.values)
        sections = uniqueSections.sorted(by: {
            $0.id < $1.id
        })
    }

}
