//
//  IssuesModel.swift
//  GithubIssuesApp
//
//  Created by Logan Allen on 9/17/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import Foundation
import ObjectMapper

struct IssueModel: Mappable {
    var title: String?
    var body: String?

    // MARK: JSON
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        title <- map["title"]
        body <- map["body"]
    }
}
