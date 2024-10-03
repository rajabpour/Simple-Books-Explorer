//
//  SearchViewController.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import UIKit

class SearchViewController: BaseViewController {
    let viewModel = SearchViewModel()
    let searchBar = UISearchBar()
    let tableView = UITableView()

    private var searchTimer: Timer?
    private var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
        title = "Books Explorer"
        
        searchBar.delegate = self
        searchBar.searchTextField.accessibilityIdentifier = "Search"
        navigationItem.titleView = searchBar

        tableView.accessibilityIdentifier = "BooksTableView"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
        view.addSubview(tableView)
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    if self?.tableView.contentOffset.y == 0 {
                        self?.tableView.setContentOffset(CGPoint(x: 0, y: -((self?.tableView.refreshControl?.frame.size.height) ?? 0)), animated: true)
                    }
                    self?.tableView.refreshControl?.beginRefreshing()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        }
        
        viewModel.onBooksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    func searchAction(query: String) {
        self.query = query
        viewModel.searchBooks(query: query)
    }
    
    @objc func refreshData(){
        searchAction(query: self.query)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // اگر تایمری در حال اجرا بود، آن را متوقف کنید
        searchTimer?.invalidate()
        
        // ایجاد یک تایمر جدید با ۸۰۰ میلی‌ثانیه تأخیر
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
            self?.searchAction(query: searchText)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        searchAction(query: query)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfBooks() == 0 ? 1 : viewModel.numberOfBooks()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.numberOfBooks() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            cell.textLabel?.text = "No Item founded!\nPlease do a new search from the search bar."
            cell.textLabel?.numberOfLines = 3
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        cell.textLabel?.text = viewModel.getBook(at: indexPath.row)?.title ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = viewModel.getBook(at: indexPath.row) else {return}
        let detailVC = DetailViewController(book: book)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.numberOfBooks() == 0 {
            return 200
        }
        else {
            return UITableView.automaticDimension
        }
    }
}
