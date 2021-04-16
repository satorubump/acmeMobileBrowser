//
//  MobileWebViewModel.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/11/21.
//

import Foundation
import UIKit

class MobileWebViewModel : ObservableObject {
    @Published var urls = ["","","",""]
    @Published var bookmarks : [String] = [String]()
    @Published var updateFlag = false
    @Published var history = [History]()
    
    init() {
        print("viewModel init")
        guard let historyUrls = UserDefaults.standard.array(forKey: "historyUrls") as? [String] else { print("urls"); return }
        guard let historyImages = UserDefaults.standard.array(forKey: "historyImages") as? [Data] else { print("images"); return }
        for i in 0..<historyUrls.count {
            let image = UIImage(data: historyImages[i])
            let history = History(url: historyUrls[i], shot: image!)
            self.history.append(history)
        }
        print("viewModel init 2")
    }
    
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
        print("updateHistory 1")
        let url = self.urls[index]
        var index : Int?
        var i = 0
        for hist in self.history {
            if hist.url == url {
                index = i
                break
            }
            i += 1
        }
        if let ind = index {
            print("updateHistory index \(shot)")
            let hist = self.history[ind]
            self.history.remove(at: ind)
            self.history.insert(hist, at: 0)
        }
        else {
            print("updateHistory else \(shot)")

            let hist = History(url: url, shot: shot)
            self.history.insert(hist, at: 0)
        }
        self.saveHistory()
        print("updateHistory 2 \(self.history.count)")
    }
    
    private func saveHistory() {
        print("saveHistory 1")
        var urls = [String]()
        var images = [Data]()
        self.history.forEach { hist in
            urls.append(hist.url)
            images.append(hist.shot.jpegData(compressionQuality: 1)!)
            print(images)
        }
        UserDefaults.standard.set(urls, forKey: "historyUrls")
        UserDefaults.standard.set(images, forKey: "historyImages")
        print("saveHistory 2")
    }
}

struct History : Hashable {
    let url : String
    let shot : UIImage
}
