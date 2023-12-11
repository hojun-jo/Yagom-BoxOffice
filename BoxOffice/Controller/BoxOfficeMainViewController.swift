//
//  BoxOfficeCollectionView.swift
//  BoxOffice
//
//  Created by EtialMoon, Minsup on 2023/07/31.
//

import UIKit

final class BoxOfficeMainViewController: UIViewController {
    enum Layout {
        enum IconSize {
            case small
            case medium
            case large
            
            var size: CGFloat {
                switch self {
                case .small:
                    return 0.25
                case .medium:
                    return 0.5
                case .large:
                    return 1.0
                }
            }
            
            mutating func up() {
                switch self {
                case .small:
                    self = .medium
                case .medium:
                    self = .large
                case .large:
                    self = .large
                }
            }
        }
        
        case list, icon
        
        mutating func toggle() {
            switch self {
            case .icon:
                self = .list
            case .list:
                self = .icon
            }
        }
    }
    
    private let boxOfficeMainView = BoxOfficeMainView()
    private var boxOfficeItems: [BoxOfficeItem] = []
    private var task: Task<Void, Never>?
    private var selectedDate = Date.yesterday
    private var selectedLayout = Layout.list
    
    override func loadView() {
        view = boxOfficeMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxOfficeMainView.boxOfficeCollectionView.delegate = self
        boxOfficeMainView.boxOfficeCollectionView.dataSource = self
        
        configureUI()
        setUpRefreshControl()
        fetchData()
        addObservers()
    }
    
    private func fetchData() {
        Task {
            boxOfficeMainView.boxOfficeCollectionView.isHidden = true
            
            boxOfficeMainView.indicatorView.startAnimating()
            await self.fetchBoxOfficeItems()
            boxOfficeMainView.indicatorView.stopAnimating()
            
            boxOfficeMainView.boxOfficeCollectionView.isHidden = false
        }
    }
    
    private func fetchBoxOfficeItems() async {
        do {
            let boxOfficeAPI = BoxOfficeAPI(boxOfficeDate: selectedDate.networkFormat)
            let boxOfficeData = try await NetworkManager.fetchData(api: boxOfficeAPI)
            let boxOffice = try JSONDecoder().decode(BoxOffice.self, from: boxOfficeData)
            let origin = boxOfficeItems
            let new = boxOffice.boxOfficeResult.boxOfficeItems

            if !origin.isEmpty {
                let differentIndexes = zip(origin, new).enumerated().compactMap { index, pair in
                    return pair.0 != pair.1 ? index : nil
                }

                let indexPaths = differentIndexes.map { index in
                    return IndexPath(item: index, section: 0)
                }
                
                boxOfficeItems = new
                
                boxOfficeMainView.collectionViewReloadItem(indexPaths: indexPaths)
            } else {
                boxOfficeItems = new
                
                boxOfficeMainView.collectionViewReloadData()
            }
        } catch {
            let alert = AlertBuilder()
                .setTitle("에러")
                .setMessage("\(error.localizedDescription)")
                .addAction(title: "OK", style: .default)
                .build()
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpIconLayout),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setUpIconLayout),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func tapSelectDateButton() {
        let boxOfficeCalendarViewController = BoxOfficeCalendarViewController(date: selectedDate)
        boxOfficeCalendarViewController.delegate = self
        
        present(boxOfficeCalendarViewController, animated: true)
    }
    
    @objc private func tapChangeModeButton() {
        let sheet = AlertBuilder()
            .setTitle("화면모드변경")
            .setPreferredStyle(.actionSheet)
            .addAction(title: selectedLayout == .list ? "아이콘" : "리스트", style: .default) { [weak self] _ in
                self?.selectedLayout.toggle()
                switch self?.selectedLayout {
                case .list:
                    self?.setUpListLayout()
                case .icon:
                    self?.setUpIconLayout()
                default:
                    return
                }
            }
            .addAction(title: "취소", style: .cancel)
            .build()
        
        present(sheet, animated: true)
    }
}

// MARK: - Configure UI

extension BoxOfficeMainViewController {
    private func configureUI() {
        setUpNavigationItems()
        setUpToolbar()
    }
    
    private func setUpNavigationItems() {
        navigationItem.title = selectedDate.navigationFormat
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "날짜선택",
            style: .plain,
            target: self,
            action: #selector(tapSelectDateButton)
        )
    }
    
    private func setUpToolbar() {
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        
        let changeModeButton = UIBarButtonItem(
            title: "화면 모드 변경",
            style: .plain,
            target: self,
            action: #selector(tapChangeModeButton)
        )
        
        toolbarItems = [flexibleSpace, changeModeButton, flexibleSpace]
        navigationController?.isToolbarHidden = false
    }
    
    private func setUpListLayout() {
        boxOfficeMainView.configureCollectionViewListLayout()
        boxOfficeMainView.collectionViewReloadData()
    }
    
    @objc private func setUpIconLayout() {
        guard selectedLayout == .icon else { return }
        
        //iconSize 계산
        var iconSizeWidth: Layout.IconSize
        var iconSizeHeight: Layout.IconSize
        let orientation  = view.window?.windowScene?.interfaceOrientation
        let dynamicType = traitCollection.preferredContentSizeCategory
        
        if orientation == .landscapeRight || orientation == .landscapeLeft {
            iconSizeWidth = .small
            iconSizeHeight = .medium
        } else {
            iconSizeWidth = .medium
            iconSizeHeight = .small
        }
        
        if dynamicType >= .accessibilityMedium {
            iconSizeWidth.up()
            iconSizeHeight.up()
        }
        
        boxOfficeMainView.configureCollectionViewIconLayout(
            size: CGSize(
                width: iconSizeWidth.size,
                height: iconSizeHeight.size
            )
        )
        
        boxOfficeMainView.collectionViewReloadData()
    }
}

// MARK: - CollectionViewDataSource

extension BoxOfficeMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxOfficeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let boxOfficeItem = boxOfficeItems[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        let rank = boxOfficeItem.rank
        let rankVariation = getRankVariationText(boxOfficeItem: boxOfficeItem)
        let movieName = boxOfficeItem.movieName
        let audienceNumber = "오늘 \(boxOfficeItem.audienceCount.decimalFormat) / 총 \(boxOfficeItem.accumulatedAudienceCount.decimalFormat)"
        
        switch selectedLayout {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BoxOfficeCollectionViewListCell.identifier,
                for: indexPath
            ) as? BoxOfficeCollectionViewListCell else {
                return UICollectionViewCell()
            }
            
            cell.setLabelText(
                rank: rank,
                rankVariation: rankVariation,
                movieName: movieName,
                audienceNumber: audienceNumber
            )
            
            return cell
        case .icon:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BoxOfficeCollectionViewIconCell.identifier,
                for: indexPath
            ) as? BoxOfficeCollectionViewIconCell else {
                return UICollectionViewCell()
            }
            
            cell.setLabelText(
                rank: rank,
                rankVariation: rankVariation,
                movieName: movieName,
                audienceNumber: audienceNumber
            )
            
            return cell
        }
    }
    
    private func getRankVariationText(boxOfficeItem: BoxOfficeItem) -> NSMutableAttributedString? {
        let amountOfRankChange = boxOfficeItem.amountOfRankChange
        let oldAndNew = boxOfficeItem.rankOldAndNew
        
        guard let rankChange = RankChangeState(amountOfRankChange, oldAndNew) else {
            return nil
        }
        
        return rankChange.getAmountOfRankChangeString(origin: amountOfRankChange)
    }
}

// MARK: - CollectionViewDelegate

extension BoxOfficeMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let boxOfficeItem = boxOfficeItems[safe: indexPath.row] else {
            return
        }
        
        let movieDetailViewController = MovieDetailViewController(boxOfficeItem: boxOfficeItem)
        
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: - CollectionViewRefreshControl

extension BoxOfficeMainViewController {
    private func setUpRefreshControl() {
        boxOfficeMainView.boxOfficeCollectionView.refreshControl = UIRefreshControl()
        
        boxOfficeMainView.boxOfficeCollectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }
    
    @objc private func handleRefreshControl() {
        task?.cancel()
        
        task = Task {
            await fetchBoxOfficeItems()
            boxOfficeMainView.boxOfficeCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - BoxOfficeCalendarViewControllerDelegate

extension BoxOfficeMainViewController: BoxOfficeCalendarViewControllerDelegate {
    func didTapSelectedDate(_ date: Date) {
        selectedDate = date
        navigationItem.title = date.navigationFormat
        
        fetchData()
    }
}
