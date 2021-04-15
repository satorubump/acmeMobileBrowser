//
//  MobileWebViewModel.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/11/21.
//

import Foundation
import UIKit

class MobileWebViewModel : ObservableObject {
    @Published var urls = ["","",""]
    @Published var bookmarks : [String] = [String]()
    @Published var updateFlag = false
    @Published var history : [String : Data] = [String : Data]()
    
    func hasBookmark(index: Int) -> Bool {
        guard let bookmarks = UserDefaults.standard.array(forKey: "bookmarks") else {   return false }
        let burls = bookmarks as! [String]
        return burls.contains(self.urls[index])
    }
    func addBookmark(index: Int) -> Void {
        print("addBookmark 1")
        var bkurls : [String]
        if let bookmarks = UserDefaults.standard.array(forKey: "bookmarks") as? [String] {
            bkurls = bookmarks
            bkurls.append(self.urls[index])
        }
        else {
            bkurls = [String]()
            bkurls.append(self.urls[index])
        }
        UserDefaults.standard.set(bkurls, forKey: "bookmarks")
        self.updateFlag.toggle()
        print("addBookmark 2")
    }
    func updateBookmarkList() {
        bookmarks.removeAll()
        if let bookmarks = UserDefaults.standard.array(forKey: "bookmarks") as? [String] {
            bookmarks.forEach { bmark in
                self.bookmarks.append(bmark)
            }
        }
    }
    func updateHistory(index: Int, shot: UIImage) {
        let url = self.urls[index]
        self.history[url] = shot.pngData() //shot.jpegData(compressionQuality: 1)
    }
}
