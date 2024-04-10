//
//  FileManagerController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 08.04.2024.
//

import UIKit

class FileManagerController {
    static let shared = FileManagerController()
    
    private init() {}
    
    func saveImage(_ image: UIImage, withName name: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(name, conformingTo: .jpeg)
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadImage(withName name: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(name, conformingTo: .jpeg)
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        guard let image = UIImage(data: imageData) else {
            return nil
        }
        
        return image
    }
}
