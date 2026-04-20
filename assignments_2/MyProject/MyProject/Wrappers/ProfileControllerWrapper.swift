//
//  ProfileControllerWrapper.swift
//  MyProject
//
//  Created by Анастасия
//

import SwiftUI

struct ProfileControllerWrapper: UIViewControllerRepresentable {
    let user: User
    
    func makeUIViewController(context: Context) -> ProfileViewController {
        ProfileViewController(user: user)
    }
    
    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
    }
}
