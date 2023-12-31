//
//  AddScoopView.swift
//  truscoop
//
//  Created by Peter Bidoshi on 11/19/23.
//

import SwiftUI

struct AddScoopView: View {
    
    @State var url: String = ""
    
    @State private var failedToAddScoop: Bool = false
    @State private var errorMsg: String = ""
    
    @State var showAlreadyThereModal: Bool = false
    
    @State var alreadyThereScoop: Scoop = articles[0]
    
    @State var pushActive: Bool = false
    
    
    @EnvironmentObject var network: NetworkWrapper
    
    var body: some View {
        ZStack {
            
            headerImage
            
            headerText
            
            newScoop
            
            (network.loading ?
                AnyView(
                    ZStack {
                        Rectangle()
                            .opacity(0.6)
                            .ignoresSafeArea()
                        ActionIndicator()
                    }
                )
                :
                AnyView(
                    EmptyView()
                )
            )
            
            (showAlreadyThereModal ?
                AnyView(
                    GeometryReader {geometry in
                        ZStack {
                            Rectangle()
                                .opacity(0.6)
                                .ignoresSafeArea()
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                Rectangle()
                                    .fill(Color(hex: "F3F3F3")!)
                                    .cornerRadius(15)
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3, alignment: .center)
                                VStack(alignment: .center, spacing: 20) {
                                    Text("Article already found")
                                        .font(.system(size: 24, weight: .bold))
                                    Text("This article already exists in our database. Would you like to open it now?")
                                        .font(.system(size: 14))
                                    VStack(spacing: 15) {
                                        NavigationLink {
                                            ScoopView(scoop: alreadyThereScoop)
                                        } label: {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.init(hex: "CFCFCF")!)
                                                    .cornerRadius(20)
                                                    .frame(height: 44)
                                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                                                Text("Open Now")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        
                                        Button {
                                            showAlreadyThereModal = false
                                        } label: {
                                            Text("No thanks")
                                                .font(.system(size: 12))
                                                .foregroundColor(.red)
                                        }
                                    }
                                }.padding(20)
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3, alignment: .center)
                            }
                        }
                    }
                )
             :
                AnyView(
                    EmptyView()
                )
            )
        }
        .navigationDestination(isPresented: $pushActive) {
            ScoopView(scoop: alreadyThereScoop)
        }
    }
    
    private var headerImage: some View {
        VStack {
            ZStack {
                GeometryReader {geometry in
                    AngularGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.26, green: 0.26, blue: 0.26), location: 1.00),
                        ],
                        center: UnitPoint(x: 0.85, y: 0.30),
                        angle: Angle(degrees: -165)
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
        VStack (alignment: .leading, spacing: 20) {
            // trurating
            VStack (alignment: .leading, spacing: 0){
                HStack(spacing: 0) {
                    Text("tru")
                        .font(.system(size: 36, weight: .bold))
                        .bold()
                        .foregroundColor(.white)
                    Text("review").font(.system(size: 36, weight: .regular))
                        .foregroundColor(.white)
                }
                
                Rectangle()
                    .fill(.white)
                    .frame(height: 3)
            }
            
            VStack (alignment: .leading, spacing: 5) {
                
                Text("Find the political bias of a news article fast, with accurate and up-to-date predictions using Artificial Intelligence. Paste the link below to get started.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "E0E0E0"))
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 60, height: 5)
                    .background(Color(red: 0.65, green: 0.65, blue: 0.65))
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
    }
    
    private var newScoop: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                Rectangle()
                    .fill(Color(hex: "F3F3F3")!)
                    .cornerRadius(30)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.67, alignment: .center)
                VStack(spacing: 30) {
                    VStack {
                        TextField("paste url here", text: $url)
                            .font(
                                Font.custom("Inter", size: 16)
                                    .weight(.medium)
                            )
                            .padding(11)
                            .kerning(0.24)
                            .background(
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                                
                                    .cornerRadius(2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color(red: 0.7, green: 0.7, blue: 0.7).opacity(0.8), lineWidth: 1.5)
                                    )
                            )
                        
                        (
                            failedToAddScoop ?
                            AnyView(
                                Text(errorMsg)
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                )
                            :
                                AnyView(EmptyView())
                        )
                    }
                    
                    Button {
                        network.addArticle(url: url, completion: { updated in
                            DispatchQueue.main.async {
                                guard let newScoop = updated else {
                                    failedToAddScoop = true
                                    network.loading = false
                                    
                                    // check and see if it already exists
                                    network.scoops.forEach { val in
                                        if url == val.url {
                                            alreadyThereScoop = val
                                            showAlreadyThereModal = true
                                            errorMsg = "Please enter a url that is not in our database"
                                            return
                                        }
                                    }
                                    if !showAlreadyThereModal {
                                        errorMsg = "Please enter a valid url"
                                    }
                                    return
                                }
                                network.scoops.insert(newScoop, at: 0)
                                network.filtered.insert(newScoop, at: 0)
                                network.loading = false
                                failedToAddScoop = false
                                alreadyThereScoop = newScoop
                                pushActive = true
                            }
                            
                        })
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color.init(hex: "E1E1E1")!)
                                .cornerRadius(20)
                                .frame(height: 44)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                            
                            Text("Submit")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0.76, green: 0.76, blue: 0.76), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                            )
                        VStack(alignment: .leading) {
                            Text("Recently Added Scoops")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            ScrollView(.vertical) {
                                VStack(spacing: 30) {
                                    ForEach(Array(network.scoops.prefix(5)), id:\.self) { simScoop in
                                        ZStack {
                                            NavigationLink {
                                                ScoopView(scoop: simScoop)
                                            } label: {
                                                ScoopRow(article: simScoop)
                                                    .listRowSeparator(.hidden)
                                            }.background(.clear)
                                                .buttonStyle(.plain)
                                        }
                                    }
                                }.padding(5)
                            }
                        }.padding()
                    }
                    .frame(height: geometry.size.height * 0.4)
                }.padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
            }
            .offset(y: geometry.size.height * 0.37)
            .safeAreaPadding(.bottom)
        }
    }
}

#Preview {
    AddScoopView()
}
