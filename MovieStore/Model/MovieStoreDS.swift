//
//  MovieStoreDS.swift
//  MovieStore
//
//  Created by Shawn Li on 5/3/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

protocol ManageMovieDelegate
{
    func addMovie (movieName: String, movieType: MovieType, movieDetail: String, movieImage: UIImage)
    func editMovie (movieName: String, movieType: MovieType, movieDetail: String, movieImage: UIImage)
}
struct MovieStoreDS
{
    var movieName: String
    var movieType: MovieType
    var movieDetail: String
    var moviePosterURL: UIImage
}

enum MovieType: String, CaseIterable
{
    case Action = "Action"
    case ScienceFiction = "Science Fiction"
    case Horror = "Horror"
    case Comedy = "Comedy"
    case Others = "Others"
}



let moviesDataScource: [[MovieStoreDS]] =
    [
        [
            MovieStoreDS(movieName: "Extraction", movieType: .Action, movieDetail: "", moviePosterURL: UIImage(named: "EXTRACTION")!),
            MovieStoreDS(movieName: "Bad Boys For Life", movieType: .Action, movieDetail: "", moviePosterURL: UIImage(named:"BADBOYSFORLIFE")!)
        ],
        
        [
            MovieStoreDS(movieName: "DeadPool 2", movieType: .ScienceFiction, movieDetail: "", moviePosterURL: UIImage(named: "DEADPOOL2")!),
            MovieStoreDS(movieName: "The Avengers 4", movieType: .ScienceFiction, movieDetail: "",  moviePosterURL: UIImage(named:"AVENGERS4")!)
        ],
        
        [
            MovieStoreDS(movieName: "Split", movieType: .Horror, movieDetail: "", moviePosterURL: UIImage(named:"SPLIT")!),
            MovieStoreDS(movieName: "Get Out", movieType: .Horror, movieDetail: "", moviePosterURL: UIImage(named:"GETOUT")!)
        ],
        
        [
            MovieStoreDS(movieName: "Sonic", movieType: .Comedy, movieDetail: "", moviePosterURL: UIImage(named:"SONIC")!),
            MovieStoreDS(movieName: "Johnny English 3", movieType: .Comedy, movieDetail: "", moviePosterURL: UIImage(named:"JOHNNYENGLISH")!)
        ],
        
        [
            MovieStoreDS(movieName: "Hacksaw Ridge", movieType: .Others, movieDetail: "", moviePosterURL: UIImage(named:"HACKSAWRIDGE")!),
            MovieStoreDS(movieName: "12 Strong", movieType: .Others, movieDetail: "", moviePosterURL: UIImage(named:"12STRONG")!)
        ]
    ]
