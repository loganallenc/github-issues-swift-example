//
//  IssueItemViewModel.swift
//  GithubIssuesApp
//
//  Created by Logan Allen on 9/17/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import Foundation

final class IssueItemViewModel   {
    let title: String
    let description : String
    let issue: IssueModel

    init (with issue: IssueModel) {
        self.issue = issue
        self.title = (issue.title != nil) ? issue.title! : ""
        self.description = (issue.body != nil) ? issue.title! : ""
    }
}
