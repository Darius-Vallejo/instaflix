//
//  MediaCoreDataRepository.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import CoreData

protocol LocalDataPersistence: MediaRepositoryProtocol  {
    func saveMovieList(_ mediaSection: MediaSection..., isGenre: Bool)
    func saveMovieList(_ mediaSection: [MediaSection], isGenre: Bool)
    func deleteMedia(bySections sections: [MediaSection]) async
}

enum CoreDataError: Error {
    case unowned
}

actor MediaCoreDataRepository: LocalDataPersistence {

    var type: MediaSection.TypeSection

    init(type: MediaSection.TypeSection) {
        self.type = type
    }

    func fetchGenres() async throws -> [MediaSection] {
        return try await fetchMediaList(isGenre: true).toDomainModel()
    }

    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection {
        let media = try await fetchMediaList(by: category)?.toDomainModel()

        guard let result = media else {
            throw CoreDataError.unowned
        }

        return result
    }

    func resetAllInfoIfNeeded() async {
        let context = CoreDataStack.shared.viewContext

        let fetchMediaSectionRequest: NSFetchRequest<MediaSectionCoreData> = MediaSectionCoreData.fetchRequest()
        let fetchMediaRequest: NSFetchRequest<MediaCoreData> = MediaCoreData.fetchRequest()

        do {
            let mediaToDelete = try await context.perform {
                try context.fetch(fetchMediaRequest)
            }

            let sectionToDelete = try await context.perform {
                try context.fetch(fetchMediaSectionRequest)
            }

            for section in sectionToDelete {
                context.delete(section)
            }

            for media in mediaToDelete {
                context.delete(media)
            }

            try await context.perform {
                if context.hasChanges {
                    try context.save()
                }
            }

            print("Successfully deleted movies.")
        } catch {
            print("Issue deleted movies.\(error)")
        }
    }

    nonisolated func saveMovieList(_ mediaSection: [MediaSection], isGenre: Bool) {
        let context = CoreDataStack.shared.viewContext
        mediaSection.forEach { mediaSec in
            _ = mediaSec.toCoreData(context: context, isGenre: isGenre)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save movie list: \(error) isGenre \(isGenre)")
        }
    }

    nonisolated func saveMovieList(_ mediaSection: MediaSection..., isGenre: Bool) {
        saveMovieList(mediaSection, isGenre: isGenre)
    }

    func deleteMedia(bySections sections: [MediaSection]) async {
        let context = CoreDataStack.shared.viewContext

        let fetchMediaRequest: NSFetchRequest<MediaSectionCoreData> = MediaSectionCoreData.fetchRequest()
        let ids = sections.map { $0.id }
        fetchMediaRequest.predicate = NSPredicate(format: "id IN %@", ids)

        do {
            let moviesToDelete = try await context.perform {
                try context.fetch(fetchMediaRequest)
            }

            for movie in moviesToDelete {
                context.delete(movie)
            }

            try await context.perform {
                if context.hasChanges {
                    try context.save()
                }
            }

            print("Successfully deleted movies.")
        } catch {
            print("Issue deleted movies.\(error)")
        }
    }


    private func fetchMediaList(by category: CustomFilterCategory) async throws -> MediaSectionCoreData? {
        let context = CoreDataStack.shared.viewContext
        let mediaId = type == .movie ? CustomFilterCategory.MediaIdType.movie.rawValue : CustomFilterCategory.MediaIdType.serie.rawValue
        let usersFetchRequest = NSFetchRequest<MediaSectionCoreData>(entityName: "MediaSectionCoreData")
        let isGenderPredicate = NSPredicate(format: "isGenre == %@", NSNumber(value: false))
        let typePredicate = NSPredicate(format: "id == %@",
                                         "\(category.idFromType(aditionalID: mediaId))")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, isGenderPredicate])

        usersFetchRequest.predicate = andPredicate
        let all = try await context.fetch(usersFetchRequest)
        return all.first
    }


    private func fetchMediaList(isGenre: Bool) async throws -> [MediaSectionCoreData] {
        let context = CoreDataStack.shared.viewContext
        let usersFetchRequest = NSFetchRequest<MediaSectionCoreData>(entityName: "MediaSectionCoreData")
        let isGenderPredicate = NSPredicate(format: "isGenre == %@", NSNumber(value: isGenre))
        let typePredicate = NSPredicate(format: "type == %@", type.rawValue)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isGenderPredicate, typePredicate])

        usersFetchRequest.predicate = andPredicate
        return try await context.fetch(usersFetchRequest)
    }

}

fileprivate extension MediaSectionCoreData {
    func toDomainModel() -> MediaSection {
        let coreDataList = (list?.allObjects) as? ([MediaCoreData]?)
        let list = (coreDataList ?? [])?.toDomainModel()
        return .init(id: Int(id),
                     title: title ?? "",
                     page: Int(page),
                     type: .init(rawValue: type ?? "") ?? .movie,
                     list: list ?? [])
    }
}

fileprivate extension Array where Element: MediaSectionCoreData {
    func toDomainModel() -> [MediaSection] {
        return map { $0.toDomainModel() }
    }
}

fileprivate extension Array where Element: MediaCoreData {
    func toDomainModel() -> [Media] {
       return map {
            return .init(id: Int($0.id),
                         originalLanguage: .init(rawValue: $0.originalLanguage ?? "") ?? .any,
                         originalTitle: $0.title ?? "",
                         title: $0.title ?? "",
                         posterPath: .init(value: $0.posterPath ?? ""),
                         backdropPath: .init(value: $0.backdropPath ?? ""),
                         overview: $0.overview ?? "")
        }
    }
}

fileprivate extension MediaSection {
    func toCoreData(context: NSManagedObjectContext, isGenre: Bool) -> MediaSectionCoreData {
        let mediaList = MediaSectionCoreData(context: context)
        mediaList.page = Int16(page)
        mediaList.id = Int64(id)
        mediaList.title = title
        mediaList.type = type.rawValue
        mediaList.isGenre = isGenre

        let mediaArray = self.list.map { mediaDomain in
            mediaDomain.toCoreData(context: context)
        }
        mediaList.addToList(NSSet(array: mediaArray))

        return mediaList
    }
}

fileprivate extension Media {
    func toCoreData(context: NSManagedObjectContext) -> MediaCoreData {
        let media = MediaCoreData(context: context)
        media.id = Int64(self.id)
        media.originalLanguage = originalLanguage.rawValue
        media.title = title
        media.posterPath = posterPath.value
        media.backdropPath = backdropPath.value
        media.overview = overview

        return media
    }
}
