//
//  MobileWebViewModel.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/11/21.
//

import Foundation
import UIKit

// Observale View Model for all views
class MobileWebViewModel : ObservableObject {
    @Published var urls = ["","","",""]
    @Published var bookmarks : [String] = [String]()
    @Published var updateFlag = false
    @Published var histories = [History]()
    
    init() {
        guard let historyUrls = UserDefaults.standard.array(forKey: "historyUrls") as? [String] else { print("urls"); return }
        guard let historyImages = UserDefaults.standard.array(forKey: "historyImages") as? [Data] else { print("images"); return }
        for i in 0..<historyUrls.count {
            let image = UIImage(data: historyImages[i])
            let history = History(url: historyUrls[i], shot: image!)
            self.histories.append(history)
        }
    }
    
    func hasBookmark(index: Int) -> Bool {
        guard let bookmarks = UserDefaults.standard.array(forKey: "bookmarks") else {   return false }
        let burls = bookmarks as! [String]
        return burls.contains(self.urls[index])
    }
    func addBookmark(index: Int) -> Void {
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
        var index : Int?
        var i = 0
        for hist in self.histories {
            if hist.url == url {
                index = i
                break
            }
            i += 1
        }
        if let ind = index {
            let hist = self.histories[ind]
            self.histories.remove(at: ind)
            self.histories.insert(hist, at: 0)
        }
        else {
            let hist = History(url: url, shot: shot)
            self.histories.insert(hist, at: 0)
        }
        self.saveHistory()
    }
    
    private func saveHistory() {
        var urls = [String]()
        var images = [Data]()
        self.histories.forEach { hist in
            urls.append(hist.url)
            images.append(hist.shot.jpegData(compressionQuality: 1)!)
            print(images)
        }
        UserDefaults.standard.set(urls, forKey: "historyUrls")
        UserDefaults.standard.set(images, forKey: "historyImages")
    }
}


