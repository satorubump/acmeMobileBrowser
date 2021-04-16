//
//  HistoryModel.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/16/21.
//

import Foundation
import UIKit

/*
 *  User's browsed history data model
 */
struct History : Hashable {
    let url : String
    let shot : UIImage
}
