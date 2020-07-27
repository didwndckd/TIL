//
//  ViewController.swift
//  ItunesPlayer
//
//  Created by 양중창 on 2020/02/28.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var indicaterView: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let player = AVPlayer()
    private let searchController = UISearchController(searchResultsController: nil)
    private let scopeButtonTitles = ["Search", "Swift", "IU", "Twice"]
        
    private let serviceManager = ServiceManager()
    private var medias: [Media] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        
        //iOS 13 미만
        definesPresentationContext = true
        // 서치바를 클릭했을 때 기존의 화면 처리 부분
        
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchBar.tintColor = .red
        
//        searchController.obscuresBackgroundDuringPresentation = false
        // 서치 컨트롤러를 클릭 했을때
        
        searchController.searchBar.showsCancelButton = false
        // 취소 버튼 안보임
        
        searchController.searchBar.placeholder = "Search Songs"
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.scopeButtonTitles = scopeButtonTitles
//        searchController.searchBar.delegate = self
        
//        test()
        
        
    }
    
    private func request(query: String) {
        indicaterView.startAnimating()
        
        serviceManager.request(query: query, complitionHandler: {
            [weak self] (response) in
            switch response {
            case .success(let medias):
                self?.medias = medias.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }

            self?.indicaterView.stopAnimating()
        })
    }


}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         print(searchBar.text ?? "")
               guard let text = searchBar.text,
               var term = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               else { return }
               
               term = term.trimmingCharacters(in: .whitespacesAndNewlines)
               print(term)
               request(query: term)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let term = scopeButtonTitles[selectedScope]
        guard let query = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), selectedScope != 0 else { return }
        request(query: query)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let media = medias[indexPath.row]
        cell.textLabel?.text = media.trackName
        cell.detailTextLabel?.text = media.artistName
        
        let task = serviceManager.fetchArtWorl(url: media.artworkUrl100, completionHandler: { result in
            cell.imageView?.image = UIImage(data: try! result.get() )
            self.serviceManager.artWorkRequest[indexPath.row] = nil
        })
        serviceManager.artWorkRequest[indexPath.row] = task
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    serviceManager.artWorkRequest[indexPath.row]?.cancel()
    serviceManager.artWorkRequest[indexPath.row] = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = medias[indexPath.row]
        guard let url = URL(string: song.previewUrl) else { return }
        player.pause()
        
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
}


