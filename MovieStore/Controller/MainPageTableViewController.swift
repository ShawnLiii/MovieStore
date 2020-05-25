//
//  MainPageTableViewController.swift
//  MovieStore
//
//  Created by Shawn Li on 5/3/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class MainPageTableViewController: UITableViewController
{
    var movies = moviesDataScource
    var moviesWithoutSec: [MovieStoreDS]
    {
        var movieContainer = [MovieStoreDS]()
        for sectionMovies in movies
        {
            for movie in sectionMovies
            {
                movieContainer.append(movie)
            }
        }
        return movieContainer
    }
    var row = 0
    var filteredRow = 0
    var section = 0
    let searchController = UISearchController(searchResultsController: nil) //use the same view you’re searching to display the results
    var filteredMovies: [MovieStoreDS] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var trashBtnOutlet: UIBarButtonItem!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        trashBtnOutlet.isEnabled = false
        tableView.allowsMultipleSelectionDuringEditing = true
        setupSearchBar()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        if isFiltering
        {
            return 1
        }
        else
        {
            return movies.count
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering
        {
            return filteredMovies.count
        }
        else
        {
            return movies[section].count
        }
    }
    
    //MARK: - Header Setting
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UILabel()
        
        headerView.text = movies[section][0].movieType.rawValue
        headerView.font = UIFont.systemFont(ofSize: 30)
        headerView.textColor = UIColor.black
        headerView.backgroundColor = UIColor.gray.withAlphaComponent(0.33)
        headerView.sizeToFit()
        
        return headerView
    }
    
    // MARK: - Cell Configuration
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        let movieIndexPath:MovieStoreDS
        
        if isFiltering
        {
            movieIndexPath = filteredMovies[indexPath.row]
        }
        else
        {
            movieIndexPath = movies[indexPath.section][indexPath.row]
        }
        
        cell.movieName.text = movieIndexPath.movieName
        cell.movieType.text = movieIndexPath.movieType.rawValue
        cell.movieImage.image = movieIndexPath.moviePosterURL
        
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if !isEditing
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return !tableView.isEditing
    }
    
    // MARK: - Delete Operation
    
    // Left Swipe Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            if movies[indexPath.section].count > 1
            {
                movies[indexPath.section].remove(at: indexPath.row)
                tableView.reloadData()
            }
            else
            {
                alert()
            }
        }
    }
    
    // Editing Model - Edit Button
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        
        if isEditing
        {
            trashBtnOutlet.isEnabled = true
        }
        else
        {
            trashBtnOutlet.isEnabled = false
        }
    }
    
    // Batch Delete
    @IBAction func trashBtn(_ sender: UIBarButtonItem)
    {
        if let indexPaths = tableView.indexPathsForSelectedRows
        {
            for indexPath in indexPaths.reversed()
            {
                if movies[indexPath.section].count > 1
                {
                    movies[indexPath.section].remove(at: indexPath.row)
                }
                else
                {
                    alert()
                    break
                }
            }
            
            tableView.reloadData()
        }
    }
    
    //MARK: - Arrange Operation
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        if movies[fromIndexPath.section].count > 1
        {
            var movie = movies[fromIndexPath.section][fromIndexPath.row]
            
            movies[fromIndexPath.section].remove(at: fromIndexPath.row)
            
            // move from one section to another section
            if to.section != fromIndexPath.section
            {
                switch to.section
                {
                    case 0:
                        movie.movieType = .Action
                    case 1:
                        movie.movieType = .ScienceFiction
                    case 2:
                        movie.movieType = .Horror
                    case 3:
                        movie.movieType = .Comedy
                    default:
                        movie.movieType = .Others
                }
                
                movies[to.section].insert(movie, at: to.row)
                //        Update View
                tableView.reloadData()
            }
            else
            {
                movies[fromIndexPath.section].insert(movie, at: to.row)
            }
        }
        else
        {
            alert()
        }
        
        //        Update View
        tableView.reloadData()
    }
}

// MARK: - Passing Value, Add or Edit

extension MainPageTableViewController: ManageMovieDelegate
{
    // Forward Passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! DetailPageViewController

        vc.delegate = self
        
        if isFiltering
        {
            let cell = sender as! MovieTableViewCell
            filteredRow = tableView.indexPath(for: cell)!.row
            let movieIndexPath = filteredMovies[filteredRow]
            vc.name = movieIndexPath.movieName
            vc.type = movieIndexPath.movieType
            vc.image = movieIndexPath.moviePosterURL
            vc.detail = movieIndexPath.movieDetail
        }
        else
        {
            if segue.identifier == "editSegue"
            {
                let cell = sender as! MovieTableViewCell
                row = tableView.indexPath(for: cell)!.row
                section = tableView.indexPath(for: cell)!.section
                let movieIndexPath = movies[section][row]
                vc.name = movieIndexPath.movieName
                vc.type = movieIndexPath.movieType
                vc.image = movieIndexPath.moviePosterURL
                vc.detail = movieIndexPath.movieDetail
            }
        }

    }
    
    // Backward Passing
    func addMovie(movieName: String, movieType: MovieType, movieDetail: String, movieImage: UIImage)
    {
        let movie = MovieStoreDS(movieName: movieName, movieType: movieType, movieDetail: movieDetail, moviePosterURL: movieImage)
        
        var sectionToAdd = 0
        
        switch movieType
        {
            case .Action:
                sectionToAdd = 0
            case .ScienceFiction:
                sectionToAdd = 1
            case .Horror:
                sectionToAdd = 2
            case .Comedy:
                sectionToAdd = 3
            default:
                sectionToAdd = 4
        }
        
        movies[sectionToAdd].append(movie)
        tableView.reloadData()
    }
    
    func editMovie(movieName: String, movieType: MovieType, movieDetail: String, movieImage: UIImage)
    {
        //MARK: - 1. assign value doesn't work fine
//        var movieIndex = movies[section][row]
        if isFiltering
        {
        //MARK: - Unsolved Problem. 2. After Filtering, can't edit Movie. How can I fetch the index
            
        }
        else
        {
            if movies[section][row].movieType == movieType
            {
                movies[section][row].movieName = movieName
                movies[section][row].movieType = movieType
                movies[section][row].movieDetail = movieDetail
                movies[section][row].moviePosterURL = movieImage
                // Update View
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell

                cell.movieName.text = movieName
                cell.movieType.text = movieType.rawValue
                cell.movieImage.image = movieImage
            }
            else
            {
                if movies[section].count > 1
                {
                    movies[section].remove(at: row)
                    addMovie(movieName: movieName, movieType: movieType, movieDetail: movieDetail, movieImage: movieImage)
                }
                else
                {
                    alert()
                }
            }
        }
        
    }
    
    func alert()
    {
        let alertController = UIAlertController(title: "Warning", message: "Each Section has to have at least one Movie", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Search Bar Configuration

extension MainPageTableViewController: UISearchBarDelegate, UISearchResultsUpdating
{
    func setupSearchBar()
    {
        //updating the content of the searchResultsController
        searchController.searchResultsUpdater = self
        //By default, UISearchController obscures the view controller containing the information you’re searching. This is useful if you’re using another view controller for your searchResultsController. In this instance, you’ve set the current view to show the results, so you don’t want to obscure your view.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        //the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
        
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)

    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredMovies = moviesWithoutSec.filter{   (movie: MovieStoreDS) -> Bool in
            return movie.movieName.lowercased().contains(searchText.lowercased())
        }
      tableView.reloadData()
    }
   
}
