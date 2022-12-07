//
//  CocktailPage.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/24/22.
//

import SwiftUI
import YouTubePlayerKit

struct CocktailPage: View { // the cocktail page for when you select a cocktail
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: ViewModel
    var cocktail: Cocktail // loads from the previews page's click
    var youTubePlayer: YouTubePlayer
    @State var showHistory = false
    @State var fetchImageTimeLimitReached = false
    
    init(cocktail: Cocktail) {
        self.cocktail = cocktail
        self.youTubePlayer = YouTubePlayer(stringLiteral: "https://www.youtube.com/embed/\(cocktail.videoID)")
    }

    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                ZStack {
                    Text(cocktail.name.uppercased()).font(.largeTitle).bold() // Title
                }
                
                CustomAsyncImage(urlString: cocktail.imageURL, withPlaceholder: false)
                    .scaledToFit()
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300,
                       maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300)
                
                VStack(spacing: 5) { // view for the ingredients
                    Text("*  *  *  *  *  *  *")
                    // for each ingredient creates a line with its corresponding quantity, quantity type, and name
                    ForEach(0..<cocktail.ingQuantities.count, id: \.self) { index in
                        Text("\(cocktail.ingQuantities[index].turnDoubleToStringUnlessZero()) \(cocktail.ingTypes[index].rawValue) \(cocktail.ingNames[index])")
                    }
                    Text("*  *  *  *  *  *  *")
                }
                VStack(alignment: .leading) {
                    ForEach(0..<cocktail.instructions.count, id: \.self) { index in
                        HStack {
                            Text("\(index+1)").font(.largeTitle)
                            Text(cocktail.instructions[index])
                        }
                    }
                }
                Divider()
                YouTubePlayerView(self.youTubePlayer) { state in
                            // Overlay ViewBuilder closure to place an overlay View
                            // for the current `YouTubePlayer.State`
                            switch state {
                            case .idle:
                                ProgressView()
                            case .ready:
                                EmptyView()
                            case .error(_):
                                Text(verbatim: "YouTube player couldn't be loaded")
                            }
                        }
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height * 0.4 : UIScreen.main.bounds.height * 0.3)
                .cornerRadius(5)
                ZStack {
                    RoundedRectangle(cornerRadius: 25).stroke()
                    Text("skip to tutorial").padding(8)
                }
                .onTapGesture { youTubePlayer.seek(to: Double(cocktail.tutorialStartTime), allowSeekAhead: true) }
                .frame(maxWidth: 150)
                
                Divider()
                if cocktail.history != nil {
                    ZStack {
                        HStack {
                            Image(systemName: showHistory ? "chevron.down" : "chevron.right")
                            Spacer()
                        }
                        HStack {
                            Text("History").font(.title)
                        }
                    }
                    .onTapGesture { showHistory.toggle() }
                }
                if showHistory {
                    Text(cocktail.history ?? "") // Text
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .onAppear {
                viewModel.visitACocktailPage()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { fetchImageTimeLimitReached = true }
            }
        }
        .navigationBarItems(leading: Image(systemName: "chevron.left").onTapGesture { self.presentationMode.wrappedValue.dismiss() }, trailing: Image(systemName: isCocktailSaved() ? "star.fill" : "star")
            .onTapGesture { viewModel.saveOrRemoveCocktail(cocktail: self.cocktail) })
//        .navigationTitle(Text(cocktail.name))
//        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    func isCocktailSaved() -> Bool {
        for cock1 in viewModel.savedCocktails {
            if cock1.name == self.cocktail.name {
                return true
            }
        }
        return false
    }
}


//struct CocktailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CocktailPage(cocktail: oldFashioned)
//    }
//}
