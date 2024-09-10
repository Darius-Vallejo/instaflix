#  Instaflix

- This project is ussing SPM so please resolve the packages dependencies (Alamofire and AlamofireImage)
- Then you can run the project 

# iOS App Architecture

The architecture used is **MVVM** and **Clean Architecture**. Within Clean Architecture, I have integrated two design patterns:

1. **Repository Pattern**: Widely used to handle services and act as an entry point for data connection managers.
2. **Mediator Pattern**: Encapsulates the behavior between multiple objects.

## Mediator Pattern

The **Mediator Pattern** implements a `Repository` interface, with the purpose of delivering data based on the following logic:

- The app must fetch movies and series.
- Data is retrieved based on the internet connection status.
- The **Mediator** directs requests to either the **REST API Repository** (for online) or the **Local Repository** (for offline), which connects to a **CoreData** database.

## Use Cases

**Use Cases** are used to manage the business logic for movies and series, filtering results by genre or other categories, such as language or rating.

## Architecture Layers

To comply with the **Single Responsibility Principle**, each layer has one distinct responsibility:

- **HomeBuilder**: A factory responsible for building instances of the `HomeView`.
- **View**: Manages the entire user interface (UI).
- **ViewModel**: Holds the state logic and knows when to change states based on the available use cases.
- **UseCases**: Contain the business logic.
- **Repository**: Handles fetching all the necessary data.
- **SynchronizationMediator**: Encapsulates the behavior of the `RestRepositories`, `LocalRepositories`, and the `NetworkMonitor`. ([Mediator Pattern](https://refactoring.guru/design-patterns/mediator))
- **RestRepositories**: Fetch data from API services.
- **LocalRepositories**: Retrieve data from the local database.
- **Entities**: Represent the Domain entities.
- **DTOs (Data Transfer Objects)**: Handle the data transfer from individual Repositories to the corresponding Domain Entities. ([Data Transfer Object](https://en.wikipedia.org/wiki/Data_transfer_object))

## Note

There are auxiliary layers that serve as interface adapters for external frameworks.
