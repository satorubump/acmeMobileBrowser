# ACME Mobile Browser

## Functions

### Mobile Web Browser with WKWebView
![Neeva](images/Neeva.png "Web Browsing") 


### Multiple pages on tab view
![Nasa](images/Nasa2.png "Tab Bar")

### Bookmark function
- bookmarks pages and display the list.
![Bookmarks](images/Bookmarks.png "Bookmark")

### History function with Thumbnails
![History](images/History.png "History list with thumbnails")
- Remaining user browsing history and display the list with thumbnails.

## Implementation
- Design and implementation has an MVVM Model with SwiftUI.
- Using UIViewControllerRepresentable for connect to WKWebView of UIKit.
- Using SwiftUI for user interface and the update data with observed object.

## Source Files

### View
- <b>AppTabView.swift</b> - 
Manage the tab views for all views
- <b>MobileWebView.swift</b> - 
Main web browser with WKWebView
- <b>WebVCRepresantable.swift</b> - 
Interface and connect to WKWebView on UIKit and has a delegate for WKWebView.
- <b>EmbeddedWebViewController.swift</b> - 
UIKit View Controller for managing WKWebView
- <b>BookmarkView.swift</b> - 
Display bookmark list with web links.
- <b>ThumbnailsHistoriesView.swift</b> - 
Display user's browsing history list with thumbnail images and the links.

### ViewModel
- <b>MobileWebViewModel.swift</b> -
Manage and updating for the present  and saving view data. 
Their data are the urls, the bookmarks and the view histories.

### Model
- <b>HistoryModel.swift</b> -
History data model.

### Helpers
- <b>ConstantsTable.swift</b> - Define constants table

