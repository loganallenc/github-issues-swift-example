//
//  ViewController.swift
//  GithubIssuesApp
//
//  Created by Logan Allen on 9/16/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import UIKit
import RxSwift

class RootViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!

    var latestRepositoryName : Observable<String>{
        return self.searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler : MainScheduler.instance)
            .distinctUntilChanged()
    }

    fileprivate var viewModel: IssuesViewModel!
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }


    func setup() {
        configureTableView()
        bindViewModel()
    }

    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func bindViewModel() {
        viewModel = IssuesViewModel()

        let input = IssuesViewModel.Input(search: latestRepositoryName)
        let output = viewModel.transform(input: input)

        output.issues.drive(tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
            cell.textLabel?.text = element.title
            cell.detailTextLabel?.text = element.body
        }.addDisposableTo(disposeBag)
    }
}

