//
//  ArticleView.swift
//  truscoop
//
//  Created by Peter Bidoshi on 11/19/23.
//

import SwiftUI

struct ScoopView: View {
    
    @State var scoop: Scoop
    @State var selectedRating: Float = -1
    
    var body: some View {
        // Header
        ZStack {
            headerImage

            headerText
            
            article
        }
    }
    
    private func findSimilarScoops(rating: Float) -> ArraySlice<Scoop> {
        var sorted = articles.sorted { abs(rating - $0.user_rating) < abs(rating - $1.user_rating) }
        sorted = sorted.filter { $0.name != scoop.name}
        return sorted[0..<5]
    }
    
    private func ratingToColor(rating: String) -> String {
        if rating == "very liberal" {
            return "0F7FBC"
        }
        else if rating == "liberal" {
            return "5AB0EE"
        }
        else if rating == "conservative" {
            return "E86868"
        }
        else if rating == "very conservative" {
            return "BC5050"
        }
        return "909090"
    }
    
    private func userRating(ratingAsFloat: Float) -> String {
        if ratingAsFloat < 0.5 {
            return "very liberal"
        }
        else if ratingAsFloat < 1.5 {
            return "liberal"
        }
        else if ratingAsFloat < 2.5 {
            return "neutral"
        }
        else if ratingAsFloat < 3.5 {
            return "conservative"
        }
        else {
            return "very conservative"
        }
    }
    
    private func userInButton(color: String, value: Float) -> some View {
        Button {
            print("selected rating set to \(value)")
            selectedRating = value
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(hex: color)!)
                .stroke(selectedRating == value ? .black: .clear, lineWidth: 3)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)

        }.disabled(value == selectedRating)
    }
    
    private var headerImage: some View {
        VStack {
            ZStack {
                GeometryReader {geometry in
                    
                    (scoop.top_img != "null" ?
                     AnyView(
                        AsyncImage(url: URL(string: scoop.top_img)) { image in
                            image.resizable()
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } placeholder: {
                            AngularGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.26, green: 0.26, blue: 0.26), location: 1.00),
                                ],
                                center: UnitPoint(x: 0.85, y: 0.30),
                                angle: Angle(degrees: -165)
                            )
                        }
                     ):
                        AnyView(
                            AngularGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.26, green: 0.26, blue: 0.26), location: 1.00),
                                ],
                                center: UnitPoint(x: 0.85, y: 0.30),
                                angle: Angle(degrees: -165)
                            )
                        )
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                }
                Rectangle()
                    .opacity(0.7)
            }
            
            Spacer()
            
        }.edgesIgnoringSafeArea(.top)
    }
    
    private var headerText: some View {
        VStack (alignment: .leading, spacing: 5) {
            // trurating
            HStack(spacing: 0) {
                Text("tru")
                    .font(.system(size: 22, weight: .bold))
                    .bold()
                    .foregroundColor(.white)
                Text("rating").font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
            }
            // Rating
            Text(" \(scoop.ai_rating.lowercased()) ")
                .font(.system(size: 18, weight: .bold))
                .background(Color(hex: ratingToColor(rating: scoop.ai_rating)))
                .foregroundStyle(.black)
                .font(.headline)
            // User Racing
            HStack(spacing: 3) {
                Text("User")
                    .font(.system(size: 22, weight: .bold))
                    .bold()
                    .foregroundColor(.white)
                Text("Rating").font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
                Spacer()
            }
            // Rating
            Text(" \(String(userRating(ratingAsFloat: scoop.user_rating))) ")
                .font(.system(size: 18, weight: .bold))
                .background(Color(hex: ratingToColor(rating: userRating(ratingAsFloat: scoop.user_rating))))
                .foregroundStyle(.black)
                .font(.headline)
            
            Text(scoop.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                .lineLimit(2)
            
            Text(scoop.date.formatted(.dateTime.day().month().year()))
                .font(.system(size: 12))
                .foregroundColor(.white)
            
            Rectangle()
                .fill(.white)
                .frame(width: 60, height: 8)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 15, leading: 25, bottom: 0, trailing: 15))
    }
    
    private var article: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                Rectangle()
                    .fill(Color(hex: "F3F3F3")!)
                    .cornerRadius(30)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.67, alignment: .center)
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                
                        ScrollView(.vertical) {
                            Text(scoop.summary)
                                .font(.custom("Futura", size: 15))
                        }
                        .lineLimit(15)
                        
                        // Your Rating
                        VStack {
                            HStack(spacing: 3) {
                                Text("Your")
                                    .font(.custom("Futura Bold", size: 18))
                                    .foregroundColor(.black)
                                Text("Rating")
                                    .font(.custom("Futura", size: 18))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack(spacing: 10) {
                                userInButton(color: "0F7FBC", value: 0)
                                userInButton(color: "5AB0EE", value: 1)
                                userInButton(color: "909090", value: 2)
                                userInButton(color: "E86868", value: 3)
                                userInButton(color: "BC5050", value: 4)
                            }
                            .frame(height: 30)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        // Button to webview
                        NavigationLink {
                            SwiftUIWebView(url: URL(string: scoop.url))
                                .navigationTitle("Truscoop Article Viewer")
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Color.init(hex: "E1E1E1")!)
                                    .cornerRadius(20)
                                    .frame(height: 44)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                                
                                Text("Read this Article")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // related scoops
                        Text("Related Scoops")
                            .font(.custom("Futura Bold", size: 18))
                            .foregroundColor(.black)
                        
                        
                        similarScoops.padding(5)
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                .frame(width: geometry.size.width, height: geometry.size.height * 0.67, alignment: .center)
                
            }
            .offset(y: geometry.size.height * 0.37)
            .safeAreaPadding(.bottom)
        }
    }
    
    private var similarScoops: some View {
        VStack(spacing: 30) {
            ForEach(findSimilarScoops(rating: scoop.user_rating), id:\.self) { simScoop in
                ZStack {
                    ScoopRow(article: simScoop)
                        .listRowSeparator(.hidden)
                    NavigationLink {
                        ScoopView(scoop: scoop)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
            }
        }
    }
}

#Preview {
    ScoopView(scoop: articles[0])
}
