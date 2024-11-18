# Recipe App

## Overview

The Recipe App is a SwiftUI-based iOS application that provides users with an organized collection of recipes. Built with native iOS frameworks, the app focuses on delivering a clean, efficient, and user-friendly recipe browsing experience.

----------

## Steps to Run the App

1.  Clone the repository:
    
    ```bash 
    git clone https://github.com/slinny/Recipe
    ```

2.  Open the project in Xcode:
    
    ```bash
    cd <project_directory>
    open RecipeApp.xcodeproj 
    ```
    
3.  Ensure the correct simulator or device is selected.
    
4.  Build and run the app by pressing  **Cmd + R**  or selecting  **Run**  from the Xcode toolbar.

----------

## Focus Areas

### Key Areas of Focus

1.  **Architecure**:
    -   Implemented the MVVM architecture and adhered to the S.O.L.I.D. design principles to ensure a clean, maintainable, and scalable codebase.
2. **User Interface**:
    -   Prioritized an intuitive, visually appealing design for `RecipeListView` using SwiftUI. This includes recipe thumbnails, titles, and brief descriptions for each recipe.
3.  **Image Caching**:
    -   Utilized NSCache and File Manager for efficient image caching to enhance app performance and improve the user experience by reducing load times.
4.  **Code Organization and Architecture**:
    -   Used the MVVM pattern to separate business logic from UI code, allowing for easier maintenance and improved testability.
5.  **Testing**:
    -   Created comprehensive unit tests to verify feature functionality and ensure code reliability.

----------

## Time Spent

-   **Total Time**: Approximately 10 hours.
-   **Time Allocation**:
    -   **UI Design and SwiftUI Layout**: ~1 hours
    -   **Architecture and ViewModel**: ~1 hours
    -   **Data Fetching and Cacheing**: ~2 hours
    -   **Testing**: ~3 hours
    -   **Debugging and Fine-Tuning**: ~3 hours

----------

## Trade-offs and Decisions

1. **Native Dependencies Only**:
    -   Chose to use only native frameworks to minimize external dependencies
    -   Resulted in more manual implementation but better long-term maintenance
2. **Testing Strategy**:
    -   Emphasized unit testing for core functionality
    -   Used mock objects for network testing    

----------

## Weakest Part of the Project

The recipe detail view currently has limited interactivity. Features like ingredient filtering or user ratings were not included to keep the focus on core functionality. These additions would enhance the user experience but were deferred due to time constraints.

----------

## External Code and Dependencies

-   No external dependencies used

----------

## Additional Information

-   **Potential Enhancements**:
    -   Implementing caching for recipe data and sorting options to improve user experience.
    -   Adding user authentication for saving personal favorite recipes could be a future enhancement.
-   **Constraints**:
    -   The project targets iOS 16, so compatibility should be reviewed if running on earlier versions.
