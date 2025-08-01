//
//  PracticeView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 25/01/25.
//

import SwiftUI

struct PracticeView: View {
    @State private var showPodList: Bool = true
    
    var body: some View {

        VStack {
            Header
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation {
                        showPodList.toggle()
                    }
                }
            
            if showPodList {
                Spacer().frame(height: 16)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(0..<20) { _ in
                            PodView
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

private var Header: some View {
    HStack {
        Image("profile.image")
            .resizable()
            .clipShape(Circle())
            .frame(width: 32, height: 32)
            .padding(2)
            .overlay {
                Circle()
                    .stroke(Color(uiColor: .secondaryLabel), lineWidth: 1)
            }
        
        Text("John Doe")
            .font(.headline)
        
        Spacer()
    }
    .padding()
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 24))
}

private var PodView: some View {
    VStack(alignment: .leading) {
        HStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.red)
            
            Text("John Doe")
                .font(.caption)
                .bold()
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "square.and.arrow.up")
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        
        Spacer().frame(height: 12)
        
        TabView {
            ForEach(0..<3) { index in
                Image("image.image")
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(uiColor: .systemBrown))
        .cornerRadius(20)
        .padding()
        
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum.")
            .font(.caption)
            .bold()
            .foregroundColor(.gray)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .padding(.bottom)
        
        BottomView
        
    }
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 24))
}

private var BottomView: some View {
    HStack {
        HStack (spacing: 12.0){
            Image(systemName: "heart")
            Image(systemName: "bubble")
        }
        
        
        Spacer()
        
        Image(systemName: "arrow.left.arrow.right")
        
        Spacer()
        
        Image(systemName: "bookmark")
    }
    .padding(.horizontal)
    .padding(.vertical)
}

#Preview {
    PracticeView()
}
