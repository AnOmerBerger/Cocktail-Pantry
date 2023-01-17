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
    var missingIngredients: [String]
    var cardColor: Color { Color(red: cocktail.backgroundColor.red/255, green: cocktail.backgroundColor.green/255, blue: cocktail.backgroundColor.blue/255) }
    @State var showHistory = false
    @State var fetchImageTimeLimitReached = false
    @State var skiptoTutorialPressed: Bool = false
    
    init(cocktail: Cocktail, missingIngredients: [String] = [String]()) {
        self.cocktail = cocktail
        self.youTubePlayer = YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=\(cocktail.videoID)")
        self.missingIngredients = missingIngredients
        
    }

    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                Text(cocktail.name.uppercased()).font(.overpass(.bold, size: 30))
                    .multilineTextAlignment(.center) // Title
                CustomCacheAsyncImage(urlString: cocktail.imageURL, withPlaceholder: false)
                    .scaledToFit()
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300,
                       maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300)
                
                VStack(spacing: 5) { // view for the ingredients
                    FlavorsForCocktailPage
                    
                    Text("*  *  *  *  *  *  *")
                    // for each ingredient creates a line with its corresponding quantity, quantity type, and name
                    ForEach(0..<cocktail.ingQuantities.count, id: \.self) { index in
                        Text("\(cocktail.ingQuantities[index].turnDoubleToStringUnlessZero()) \(cocktail.ingTypes[index].rawValue) \(cocktail.ingNames[index])")
                            .foregroundColor(missingIngredients.contains(cocktail.ingNames[index]) ? .red : .black)
                    }
                    .font(.overpass(.semiBold, size: 16))
                    Text("*  *  *  *  *  *  *")
                    GlassAndGarnishText
                }
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(0..<cocktail.instructions.count, id: \.self) { index in
                        HStack {
                            Text("\(index+1)").font(.largeTitle)
                            Text(cocktail.instructions[index])
                        }
                    }
                }
                .font(.overpass(.regular, size: 16))
                .padding(35)
                .background(cardColor.opacity(0.4), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                IceAndTimeText
                Divider()
                YouTubePlayerView(self.youTubePlayer) { state in
                            // Overlay ViewBuilder closure to place an overlay View
                            // for the current `YouTubePlayer.State`
                            switch state {
                            case .idle:
                                ProgressView()
                            case .ready:
                                EmptyView()
                            case .error(let error):
                                Text(error.localizedDescription)
                            }
                        }
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height * 0.4 : UIScreen.main.bounds.height * 0.3)
                .cornerRadius(5)
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous).stroke()
                    Text(skiptoTutorialPressed ? "start over" : "skip to tutorial").font(.overpass(.regular, size: 16)).padding(8)
                }
                .onTapGesture {
                    youTubePlayer.seek(to: Double(cocktail.tutorialStartTime), allowSeekAhead: true)
                    skiptoTutorialPressed = true
                } .frame(maxWidth: 150)
                
                Divider()
                HistorySection
            }
            .padding()
            .onAppear {
                viewModel.visitACocktailPage()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { fetchImageTimeLimitReached = true }
            }
        }
        .navigationBarItems(
            leading:
                ChevronBackButton(presentationMode: presentationMode),
            trailing:
                Image(systemName: isCocktailSaved() ? "star.fill" : "star")
            .onTapGesture { viewModel.saveOrRemoveCocktail(cocktail: self.cocktail) })
//        .navigationTitle(Text(cocktail.name)
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

// MARK: - view extensions

extension CocktailPage {
    var FlavorsForCocktailPage: some View {
        let flavorCount = cocktail.flavorProfile.count
        var halfwayPoint: Int {
            if flavorCount > 4 {
                return Int(ceil(Double(flavorCount/2)))
            } else {
                return flavorCount
            }
        }
        return VStack {
            HStack {
                ForEach(0..<halfwayPoint, id: \.self) { index in
                    NavigationLink(destination: FilteredCocktailList(title: "Flavor Profile", filteringSelection: cocktail.flavorProfile[index].rawValue).environmentObject(viewModel)) {
                        FlavorProfileView(text: cocktail.flavorProfile[index].rawValue).font(.caption)
                    }
                }
            }
            HStack {
                ForEach(halfwayPoint..<flavorCount, id: \.self) { index in
                    NavigationLink(destination: FilteredCocktailList(title: "Flavor Profile", filteringSelection: cocktail.flavorProfile[index].rawValue).environmentObject(viewModel)) {
                        FlavorProfileView(text: cocktail.flavorProfile[index].rawValue).font(.caption)
                    }
                }
            }
        }
    }
}

extension CocktailPage {
    var HistorySection: some View {
        VStack(spacing: 10) {
            if cocktail.history != nil {
                ZStack {
                    HStack {
                        Image(systemName: showHistory ? "chevron.down" : "chevron.right")
                        Spacer()
                    }
                    HStack {
                        Text("History").font(.overpass(.semiBold, size: 27))
                    }
                }
                .onTapGesture { showHistory.toggle() }
            }
            if showHistory {
                Text(cocktail.history ?? "") // Text
                    .font(.overpass(.regular, size: 16))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
            }
        }
    }
}

extension CocktailPage {
    var glassString: String {
        var string = ""
        for glass in cocktail.glassType {
            string += ("\(glass.rawValue)/")
        }
        string.removeLast(1)
        return string
    }
    var garnishString: String {
        var string = ""
        for garnish in cocktail.garnish ?? ["--"] {
            string += ("\(garnish)/")
        }
        string.removeLast(1)
        return string
    }
    var GlassAndGarnishText: some View {
        HStack {
            HStack {
                if #available(iOS 16.0, *) {
                    Image(systemName: "wineglass")
                } else {
                    Image(systemName: "cup.and.saucer")
                }
                Text(glassString)
            }
            Spacer()
            HStack {
                Image(systemName: "leaf.fill")
                Text(garnishString)
            }
        }
        .font(.overpass(.light, size: 14))
    }
    
    var shakeTimeString: String {
        var string = ""
        if cocktail.shakeOrStirTime.minTime == 0 && cocktail.shakeOrStirTime.maxTime == 0 {
            string = "--"
        } else {
            string = "\(cocktail.shakeOrStirTime.minTime)-\(cocktail.shakeOrStirTime.maxTime)"
        }
        return string
    }
    
    var IceAndTimeText: some View {
        HStack {
            HStack {
                Image(systemName: "snowflake.circle.fill")
                Text(cocktail.iceType.rawValue)
            }
            Spacer()
            HStack {
                Image(systemName: "clock")
                Text(shakeTimeString)
            }
        }
        .font(.overpass(.light, size: 14))
    }
}

struct CocktailPage_Previews: PreviewProvider {
    static var previews: some View {
        CocktailPage(cocktail: negroni).environmentObject(ViewModel())
    }
}
