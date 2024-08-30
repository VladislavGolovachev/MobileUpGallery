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
        collectionView.prefetchDataSource = self
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "Video")
        
        return collectionView
    }()
    private var videoCellSize: CGSize?
    private var photoCellSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedBackground),
                       name: UIApplication.willResignActiveNotification, object: nil)
        nc.addObserver(self, selector: #selector(appMovedForeground),
                       name: UIApplication.willEnterForegroundNotification, object: nil)
        
        presenter?.prefetchPhotos(for: 0)
        view.backgroundColor = .white
        customizeNavigationBar()
        
        photoVideoControl.firstItem.addTarget(self, 
                                              action: #selector(firstSegmentTappedAction(_:)), for: .touchDown)
        photoVideoControl.secondItem.addTarget(self, 
                                               action: #selector(secondSegmentTappedAction(_:)), for: .touchDown)
        
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
        navigationItem.title = "MobileUp Gallery"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                                                                   .foregroundColor: UIColor.black]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain,
                                                            target: self, action: #selector(exitButtonAction(_:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

//MARK: Actions
extension MainViewController {
    @objc func appMovedBackground() {
        presenter?.stopDownloading()
        collectionView.contentOffset = CGPointZero
        presenter?.emptyPhotoCache()
        presenter?.emptyVideoCache()
    }
    
    @objc func appMovedForeground() {
        if photoVideoControl.selectedSegment == 0 {
            presenter?.prefetchPhotos(for: 0)
        } else {
            presenter?.prefetchVideos(for: 0)
        }
    }
    
    @objc func firstSegmentTappedAction(_ sender: UIButton) {
        presenter?.stopDownloading()
        
        collectionView.contentOffset = CGPointZero
        presenter?.emptyVideoCache()
        presenter?.prefetchPhotos(for: 0)
        
        collectionView.reloadData()
        photoVideoControl.selectSegment(at: 0)
    }
    
    @objc func secondSegmentTappedAction(_ sender: UIButton) {
        presenter?.stopDownloading()
        
        collectionView.contentOffset = CGPointZero
        presenter?.emptyPhotoCache()
        presenter?.prefetchVideos(for: 0)
        
        collectionView.reloadData()
        photoVideoControl.selectSegment(at: 1)
    }
    
    @objc func exitButtonAction(_ sender: UIButton) {
        presenter?.popToAuthScreen()
    }
}

//MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoVideoControl.selectedSegment == 0 {
            print(presenter?.photosAmount)
            return presenter?.photosAmount ?? 0
        }
        return presenter?.videosAmount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if photoVideoControl.selectedSegment == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath)
            as? PhotoCollectionViewCell ?? PhotoCollectionViewCell()
            if let photo = presenter?.photo(at: indexPath.row) {
                cell.imageView.image = photo
            } else {
                cell.backgroundColor = .systemGray5
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Video", for: indexPath)
        as? VideoCollectionViewCell ?? VideoCollectionViewCell()
        cell.imageView.image = presenter?.video(at: indexPath.row)
        cell.label.text = presenter?.videoTitle(at: indexPath.row)
        cell.backgroundColor = .systemGray5
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell as? PhotoCollectionViewCell, cell.imageView.image == nil {
            return
        }
        
        cell?.alpha = 0.4
        UIView.animate(withDuration: 0.5) {
            cell?.alpha = 1
        }
        
        switch photoVideoControl.selectedSegment {
        case 0:
            presenter?.showPhotoScreen(photoID: indexPath.row)
        case 1:
            presenter?.showVideoScreen(videoID: indexPath.row)
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = collectionView.numberOfItems(inSection: 0)
        if index - 1 != indexPath.row {
            return
        }
        
        if photoVideoControl.selectedSegment == 0 {
            presenter?.prefetchPhotos(for: index)
        } else {
            presenter?.prefetchVideos(for: index)
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

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxIndexPath = indexPaths.max {$0.row > $1.row}
        guard let maxRow = maxIndexPath?.row else {return}
        
        let index = collectionView.numberOfItems(inSection: 0)
        if index - 1 != maxRow {
            return
        }
        
        if photoVideoControl.selectedSegment == 0 {
            presenter?.prefetchPhotos(for: index)
        } else {
            presenter?.prefetchVideos(for: index)
        }
    }
}

//MARK: MainViewProtocol
extension MainViewController: MainViewProtocol {
    func reloadList() {
        print("reload begins")
        collectionView.reloadData()
        print("reload finished")
    }
    
    func reloadItem(at row: Int) {
        print("reloadItem at \(row) begins")
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.reloadItems(at: [indexPath])
        print("reloadItem at \(row) finished")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Возникла ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        self.present(alert, animated: true)
    }
}

