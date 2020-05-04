//
//  DetailPageViewController.swift
//  MovieStore
//
//  Created by Shawn Li on 5/3/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController
{

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieName: UITextField!
    
    @IBOutlet weak var movieType: UITextField!
    
    @IBOutlet weak var movieDetail: UITextView!
    
    var delegate: ManageMovieDelegate?
    
    var name: String?
    
    var type: MovieType?
    
    var detail: String?
    
    var image: UIImage?
    
    let imagePickerCtrl = UIImagePickerController()
    
    let typePickerView = UIPickerView()
    
    let typeList = MovieType.allCases
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        setupGestureAndImagePickerForImage()
        setupPickerViewAndTextFieldForMovieTypeAndName()
        setupMovieDetailTextView()
    }
    
    func setupUI()
    {
        movieName.text = name
        movieDetail.text = detail
        movieType.text = type?.rawValue
        movieImage.image = image
        
        if name != nil
        {
            navigationItem.title = "Edit Movie"
        }
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem)
    {
        
        if let name = movieName.text, let type = movieType.text, let image = movieImage.image, let detail = movieDetail.text, !name.isEmpty
        {
            var movieType: MovieType
            
            switch type
            {
                case MovieType.Action.rawValue:
                    movieType = .Action
                case MovieType.Comedy.rawValue:
                    movieType = .Comedy
                case MovieType.Horror.rawValue:
                    movieType = .Horror
                case MovieType.ScienceFiction.rawValue:
                    movieType = .ScienceFiction
                default:
                    movieType = .Others
            }
            
            if self.name != nil
            {
                delegate?.editMovie(movieName: name, movieType: movieType, movieDetail: detail, movieImage: image)
            }
            else
            {
                delegate?.addMovie(movieName: name, movieType: movieType, movieDetail: detail, movieImage: image)
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Image Picker and Guesture

extension DetailPageViewController: UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func setupGestureAndImagePickerForImage()
    {
        imagePickerCtrl.allowsEditing = true
        movieImage.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        tapRecognizer.delegate = self
        movieImage.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap()
    {
        imagePickerCtrl.delegate = self
        imagePickerCtrl.sourceType = .photoLibrary
        self.present(imagePickerCtrl, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        movieImage.image = image
        imagePickerCtrl.delegate = nil
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Picker View and TextField Configuration

extension DetailPageViewController: UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate
{
    func setupPickerViewAndTextFieldForMovieTypeAndName()
    {
        typePickerView.delegate = self
        typePickerView.dataSource = self
        typePickerView.isHidden = true
        movieType.delegate = self
        movieName.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return MovieType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return typeList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        movieType.text = typeList[row].rawValue
        typePickerView.isHidden = true
        movieType.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == movieType
        {
            movieType.inputView = typePickerView
            typePickerView.isHidden = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        movieName.resignFirstResponder()
        
        return true
    }
    
}

// MARK: - Text View Configuration

extension DetailPageViewController: UITextViewDelegate
{
    func setupMovieDetailTextView()
    {
        movieDetail.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            movieDetail.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}
