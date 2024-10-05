# SawitPRO Technical Test

## Demo
WIP

## Overview
This project is built using the MVVM-C (Model-View-ViewModel-Coordinator) architecture, integrating Firebase as a core backend service. The project demonstrates a simple yet scalable implementation that balances separation of concerns, testability, and maintainability.

## Setup Instructions
To get the project running locally, follow these steps:

- Resolve Firebase dependency using Swift Package Manager (SPM):

Open the project in Xcode.
Go to File > Add Packages...
Enter the following URL for the Firebase SPM:
https://github.com/firebase/firebase-ios-sdk
Select the required Firebase modules (e.g., Firestore).
Run the project:

Select the main scheme in Xcode.
Build and run the project on your simulator or device.
You're all set!

## Architecture Overview
This project follows the MVVM-C architecture, which consists of:

Coordinator: Manages the app's flow and transitions between different screens. Each major screen or feature has a dedicated coordinator that handles view controller creation and navigation logic.

View: The primary UI layer, which is responsible for rendering the views (UIKit or SwiftUI). It binds directly to the ViewModel.

ViewModel: The middle layer that holds the business logic and communicates between the View and Model layers. The ViewModel handles all data preparation for the View and receives data updates from the repository.

Repository: Acts as an abstraction layer that provides access to various data sources (e.g., Firebase, CoreData). It centralizes the logic of fetching and storing data.

Manager: A service layer that connects the repository to external systems (e.g., networking, CoreData). The manager ensures that all data manipulation and service access are decoupled from the business logic.

## Key Design Decisions
Why MVVM-C?
MVVM-C was chosen because it fits well with this project's simple structure, providing a clean and modular architecture. A more complex architecture like VIPER would be overkill for this scale. With MVVM-C, we achieve separation of concerns, allowing the business logic to remain testable, while the coordinator pattern simplifies view transitions and navigation.

Separation of Logic:
By using MVVM-C, each component of the application has a distinct responsibility:

The Coordinator handles transitions and navigation.
The ViewModel holds business logic and handles view updates.
The Repository provides data access, while Manager abstracts the complexity of dealing with Firebase, networking, and other services.

## Known Limitations & Future Improvements
- ViewModel Dependency on Firebase:

Currently, some ViewModel classes directly depend on Firebase data types, which violates the principle of keeping third-party dependencies outside of core logic.
Improvement: We plan to introduce a layer of abstraction where Firebase-related models are converted into project-specific data types in the Manager. These types will then be passed down to the ViewModel, avoiding tight coupling with Firebase.

- Dependency Injection (DI):

There is basic DI implemented, but it is minimal. Future improvements include enhancing DI initialization to better manage object lifecycles and caching, especially for services that require persistence, like database or network clients.
UI Code Reusability:

- Layout:

While the UI is functional, there's room for improvement in reusability.
Improvement: Introduce more ViewModifiers, common UI components, and style definitions to standardize and accelerate the development of new views.

- Environment Object Utilization:

In SwiftUI, EnvironmentObject could be better utilized to streamline state management across different views. Although not heavily used in this project, it can be leveraged in future updates.

- Caching and Performance:

Explore caching solutions for frequent data access.

- Remove Unused Firebase Packages:

As the project evolves, some Firebase packages may no longer be necessary, adding unnecessary bloat to the codebase. Remove unused Firebase modules to streamline dependencies and reduce app size.