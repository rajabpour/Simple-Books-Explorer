//
//  DetailViewController.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import UIKit

class DetailViewController: BaseViewController {
    let indicator = UIActivityIndicatorView(style: .large)
    var book: Book
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "DetailView"
        setupUI()
    }
    
    fileprivate func hideImageLoading() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "\(book.title)"
        titleLabel.numberOfLines = 0
        titleLabel.accessibilityIdentifier = "BookTitleLabel"
        
        let authorLabel = UILabel()
        authorLabel.text = "Author: \(book.authorName?.joined(separator: ", ") ?? "N/A")"
        authorLabel.numberOfLines = 0
        
        let yearLabel = UILabel()
        yearLabel.text = "First Published: \(book.firstPublishYear ?? 0)"
        
        indicator.startAnimating()

        let coverImageView = UIImageView()
        if let coverId = book.coverId {
            let urlString = "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg"
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.hideImageLoading()
                            coverImageView.image = UIImage(data: data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.hideImageLoading()
                            coverImageView.image = UIImage(systemName: "photo")?.withTintColor(.lightGray, renderingMode: .alwaysTemplate)
                        }
                    }
                }
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, yearLabel, indicator, coverImageView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
