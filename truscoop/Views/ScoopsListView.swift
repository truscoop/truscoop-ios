import SwiftUI

struct ScoopsListView: View {
    
    var filter: String
    @EnvironmentObject var network: NetworkWrapper
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .top)) {
            VStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.1), .clear]),
                        startPoint: .init(x: 0.50, y: 0.00),
                        endPoint: .init(x: 0.50, y: 1.00)
                    ))
                    .stroke(.clear)
                    .frame(height: 7)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                Spacer()
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.2)]),
                        startPoint: .init(x: 0.50, y: 0.00),
                        endPoint: .init(x: 0.50, y: 1.00)
                    ))
                    .stroke(.clear)
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .zIndex(10)
            List(filter == "all" ? network.filtered : network.filtered.filter({ $0.aiRating == filter }), id: \.self) { scoop in
                ZStack {
                    ScoopRow(article: scoop)
                    NavigationLink {
                        ScoopView(scoop: scoop)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white)
                .listStyle(.plain)
            }
            .listRowSpacing(10)
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

// Taken from https://stackoverflow.com/questions/56496359/swiftui-view-viewdidload
struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }

}
