//
//  StartViewController.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 16.03.2025.
//

import UIKit
import Combine
import Kingfisher

class StartViewController: UIViewController {
    private var vm = StartViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        vm.checkFirstCharacter()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .yellow
        view.addSubview(imageView)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func bind() {
        vm.$characterImage
            .receive(on: RunLoop.main)
            .sink { [weak self] imageURL in
                guard let imageURL = imageURL else { return }
                self?.loadImage(with: imageURL)
            }
            .store(in: &cancellables)
        
        vm.$errorMsg
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                self?.errorLabel.isHidden = errorMessage == nil
                self?.errorLabel.text = errorMessage
            }
            .store(in: &cancellables)
        
        vm.$characters
            .receive(on: RunLoop.main)
            .filter { !$0.isEmpty }
            .delay(for: 1.5, scheduler: RunLoop.main)
            .sink { [weak self] characters in
                self?.navigateToMainScreen(with: characters)
            }
            .store(in: &cancellables)
    }
    
    private func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.5))
            ],
            completionHandler: { [weak self] result in
                switch result {
                case .success:
                    UIView.animate(withDuration: 1) {
                        self?.imageView.alpha = 1
                    }
                    self?.startAnimation()
                case .failure(let error):
                    print("err: \(error.localizedDescription)")
                }
            }
        )
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    private func navigateToMainScreen(with characters: [Character]) {
        imageView.layer.removeAllAnimations()
        imageView.transform = .identity
        guard let mainViewModel = vm.mainViewModel else { return }
        let mainViewController = MainViewController(viewModel: mainViewModel)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
