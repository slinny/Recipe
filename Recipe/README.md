//
//  Untitled.swift
//  Recipe
//
//  Created by Siran Li on 11/14/24.
//


# Recipe App

## Overview

The Recipe App is designed to provide users with an organized list of recipes, allowing them to browse recipes. The app is built with SwiftUI, SDWebImage, and utilizes a  `RecipeListView`  as the primary interface for displaying recipes.

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
    -   Utilized SDWebImage for efficient image caching to enhance app performance and improve the user experience by reducing load times.
4.  **Code Organization and Architecture**:
    -   Used the MVVM pattern to separate business logic from UI code, allowing for easier maintenance and improved testability.
5.  **Testing**:
    -   Created comprehensive unit tests to verify feature functionality and ensure code reliability, leveraging ViewInspector for SwiftUI view testing.

----------

## Time Spent

-   **Total Time**: Approximately 10 hours.
-   **Time Allocation**:
    -   **UI Design and SwiftUI Layout**: ~1 hours
    -   **Architecture and ViewModel**: ~1 hours
    -   **Data Fetching and Cacheing**: ~2 hours
    -   **Testing**: ~4 hours
    -   **Debugging and Fine-Tuning**: ~2 hours

----------

## Trade-offs and Decisions

1. **Simplified Recipe Detail View**:
    -   Limited the detail view to essential recipe information (e.g., title, ingredients, and instructions) to provide a streamlined user experience within time constraints. This focused the app on delivering core functionality efficiently.
2. **SDWebImage over FileManager**:
    -   Chose SDWebImage for image caching and handling over directly using  `FileManager`. SDWebImage provides built-in optimizations for image downloading, caching, and displaying, which leads to a smoother user experience and better performance, particularly when dealing with remote image resources.
3. **SDWebImage for Image Caching**:
    -   Chose SDWebImage for image caching over using `FileManager`. This choice provided built-in optimizations for downloading, caching, and displaying images, leading to better performance, especially with remote image data.
4. **Mocking for Testing**:
    -   Used mock data and objects to test the `RecipeViewModel` and network layer. This allowed for focused unit tests without dependencies on actual network conditions, making tests more stable and reliable.
5. **Limited Animation**:
    -   Decided against complex animations in `RecipeListView` to keep the UI responsive and lightweight, particularly on older devices.

----------

## Weakest Part of the Project

The recipe detail view currently has limited interactivity. Features like ingredient filtering or user ratings were not included to keep the focus on core functionality. These additions would enhance the user experience but were deferred due to time constraints.

----------

## External Code and Dependencies

-   **SDWebImage**: Used for image caching to improve performance when loading recipe images.
-   **ViewInspector**: Utilized for testing SwiftUI views to ensure UI components function as expected in unit tests.

----------

## Additional Information

-   **Potential Enhancements**:
     -   Implementing caching for recipe data and sorting options to improve user experience.
    -   Adding user authentication for saving personal favorite recipes could be a future enhancement.
-   **Constraints**:
    -   The project targets iOS 16, so compatibility should be reviewed if running on earlier versions.
