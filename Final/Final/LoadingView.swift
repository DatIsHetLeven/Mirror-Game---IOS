//
//  LoadingView.swift
//  Final
//
//  Created by Murat on 23/01/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.black)) // 
            
                .scaleEffect(5.0) //
                .padding(.all, 40) //

            Text("Laden...")
                .font(.headline)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.7))
    }
}




struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
