//
//  SectionView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 24/4/24.
//

import SwiftUI

struct SectionView: View {
    
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
         
            Text(description)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
