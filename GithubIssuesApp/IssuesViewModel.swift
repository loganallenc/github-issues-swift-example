//
//  ViewModel.swift
//  GithubIssuesApp
//
//  Created by Logan Allen on 9/16/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya_ObjectMapper

class IssuesViewModel: ViewModelType {

    fileprivate let issueSubject = PublishSubject<[IssueModel]>()

    struct Input {
        let search: Observable<String>
    }

    struct Output {
        let issues: Driver<[IssueModel]>
    }

    init() {}

    func transform(input: Input) -> Output {

        _ = input.search.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { repositoryPath in
                self.fetchIssues(repositoryPath: repositoryPath)
            })


        let issues = issueSubject.asObservable()
            .asDriver(onErrorJustReturn: [])



        return Output(issues: issues)
    }

    func fetchIssues(repositoryPath: String) {
        GithubProvider.request(.issues(repositoryPath), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let issues: [IssueModel]? = try response.mapArray(IssueModel.self)
                    if (issues != nil) {
                        self.issueSubject.onNext(issues!)
                    }
                } catch {}
            case .failure(_): break
            }
        })
    }

}
