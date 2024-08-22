//
//  MainViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

final class MainViewController: UIViewController {

    var presenter: MainViewPresenterProtocol?
    let photoVideoControl = CustomSegmentedControl(firstTitle: "Фото", secondTitle: "Видео")
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "Video")
        
        return collectionView
    }()
    private var videoCellSize: CGSize?
    private var photoCellSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        customizeNavigationBar()
        
        photoVideoControl.firstItem.addTarget(self, action: #selector(firstSegmentTappedAction(_:)), for: .touchDown)
        photoVideoControl.secondItem.addTarget(self, action: #selector(secondSegmentTappedAction(_:)), for: .touchDown)
        
        view.addSubview(photoVideoControl)
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        if photoCellSize == nil {
            let width = Int((view.bounds.width - 4) / 2.0)
            photoCellSize = CGSize(width: width, height: width)
        }
        if videoCellSize == nil {
            videoCellSize = CGSize(width: view.bounds.width, height: 210)
        }
    }
}

//MARK: Private functions
extension MainViewController {
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        photoVideoControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoVideoControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            photoVideoControl.heightAnchor.constraint(equalToConstant: 32),
            photoVideoControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoVideoControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: photoVideoControl.bottomAnchor, constant: 8)
        ])
    }
    
    private func customizeNavigationBar() {
        navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.title = "MobileUp Gallery"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain,
                                                            target: self, action: #selector(exitButtonAction(_:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

//MARK: Actions
extension MainViewController {
    @objc func firstSegmentTappedAction(_ sender: UIButton) {
        photoVideoControl.selectSegment(at: 0)
        collectionView.reloadData()
    }
    
    @objc func secondSegmentTappedAction(_ sender: UIButton) {
        photoVideoControl.selectSegment(at: 1)
        collectionView.reloadData()
    }
    
    @objc func exitButtonAction(_ sender: UIButton) {
        presenter?.returnToAuthScreen()
    }
}

//MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if photoVideoControl.selectedSegment == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath)
            as? PhotoCollectionViewCell ?? PhotoCollectionViewCell()
            
            cell.backgroundColor = .green
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Video", for: indexPath)
        as? VideoCollectionViewCell ?? VideoCollectionViewCell()
        cell.backgroundColor = .blue
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.4
        UIView.animate(withDuration: 0.5) {
            cell?.alpha = 1
        }
        
        switch photoVideoControl.selectedSegment {
        case 0:
            presenter?.showPhotoScreen()
        case 1:
            presenter?.showVideoScreen()
            
        default: break
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch photoVideoControl.selectedSegment {
        case 0:
            return photoCellSize ?? CGSizeZero
        case 1:
            return videoCellSize ?? CGSizeZero
            
        default: break
        }
        
        return CGSizeZero
    }
}

//MARK: MainViewProtocol
extension MainViewController: MainViewProtocol {
    
}

