//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by EtialMoon, Minsup on 2023/08/08.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movieDetailView = MovieDetailView()
    private var boxOfficeItem: BoxOfficeItem
    
    init(boxOfficeItem: BoxOfficeItem) {
        self.boxOfficeItem = boxOfficeItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = false
    }
    
    private func fetchData() {
        Task {
            movieDetailView.indicatorView.startAnimating()
            
            do {
                async let movieInformation = fetchMovieInformation(movieCode: boxOfficeItem.movieCode)
                async let posterImage = fetchPosterImage(movieName: boxOfficeItem.movieName)
                
                movieDetailView.setMovieInformation(
                    keys: makeKeyTexts(),
                    values: prettyMovieInformation(try await movieInformation)
                )
                
                movieDetailView.setPosterImage(try await posterImage)
            } catch {
                let alert = AlertBuilder()
                    .setTitle("에러")
                    .setMessage("\(error.localizedDescription)")
                    .addAction(title: "재시도", style: .default) { [weak self] _ in
                        self?.fetchData()
                    }
                    .addAction(title: "확인", style: .default) { [weak self] _ in
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    .build()
                
                present(alert, animated: true, completion: nil)
            }
            
            movieDetailView.indicatorView.stopAnimating()
        }
    }
    
    private func fetchMovieInformation(movieCode: String) async throws -> MovieInformation? {
        let movieInformationAPI = MovieInformationAPI(movieCode: movieCode)
        let movieData = try await NetworkManager.fetchData(api: movieInformationAPI)
        let movie = try JSONDecoder().decode(Movie.self, from: movieData)
        
        return movie.movieResult.movieInformation
    }
    
    private func fetchPosterImage(movieName: String) async throws -> UIImage? {
        guard let daumImageAPI = DaumImageAPI(movieName: movieName) else {
            throw NetworkError.notFoundAPIKey
        }
        
        let daumImageData = try await NetworkManager.fetchData(api: daumImageAPI)
        let imageDTO = try JSONDecoder().decode(Image.self, from: daumImageData)
        
        guard let urlString = imageDTO.imageDocuments.first?.imageURL else {
            throw NetworkError.invalidURL
        }
        
        let url = JustURL(url: urlString)
        let imageData = try await NetworkManager.fetchData(api: url)
        
        return UIImage(data: imageData)
    }
    
    private func makeKeyTexts() -> [String] {
        return ["감독", "제작년도", "개봉일", "상영시간", "관람등급", "제작국가", "장르","배우"]
    }
    
    private func prettyMovieInformation(_ movieInformation: MovieInformation?) -> [String] {
        guard let movieInformation = movieInformation else { return [] }
        
        let directors = movieInformation.directors.map(\.peopleName).joined(separator: ", ")
        let productionYear = movieInformation.productionYear
        let openDate = movieInformation.openDate.dateFormat
        let runningTime = movieInformation.runningTime
        let watchGrade = movieInformation.audits.first?.watchGrade ?? ""
        let nations = movieInformation.nations.map(\.nationName).joined(separator: ", ")
        let genres = movieInformation.genres.map(\.genreName).joined(separator: ", ")
        let actors = movieInformation.actors.map(\.peopleName).joined(separator: ", ")
        
        return [directors, productionYear, openDate, runningTime, watchGrade, nations, genres, actors]
    }
}

// MARK: - Configure UI

extension MovieDetailViewController {
    private func setUpNavigationItems() {
        self.navigationItem.title = boxOfficeItem.movieName
    }
}
