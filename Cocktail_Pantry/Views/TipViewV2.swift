//
//  TipViewV2.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/14/22.
//

import SwiftUI
import StoreKit


struct DoubleSidedCoin: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showTipView: Bool
    @State var frontDegree: Double = 0.0
    @State var backDegree: Double = -90
    @State var startFlip: Bool = false
    
    
    let durationAndDelay: CGFloat = 0.13
    
    var body: some View {
        ZStack {
            CoinBack(degrees: $backDegree)
            CoinFront(showTipView: $showTipView, degrees: $frontDegree).environmentObject(viewModel)
        }
        .opacity(showTipView ? 1 : 0)
    }
    
    
    
    
    func flipCoin() {
        startFlip = true
        if startFlip == true {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*2)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*3)) {
                frontDegree = 180
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*4)) {
                frontDegree = 270
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*5)) {
                backDegree = 180
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*6)) {
                backDegree = 270
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay*7)) {
                frontDegree = 360
            }
        }
    }
    
}



struct CoinFront: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showTipView: Bool
    @Binding var degrees: Double
    @State var selectedAmount: Product? = nil
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(.blue.opacity(0.5))
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: UIScreen.main.bounds.size.width - 30)
                .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
                .overlay {
                    VStack(spacing: 20) {
                        Text("tip your bartender?").bold()
                        HStack {
                            ForEach(viewModel.tipOptions, id: \.id) { product in
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(selectedAmount == product ? .green.opacity(0.65) : .white.opacity(0.4))
                                    .frame(width: UIScreen.main.bounds.size.width/4 - 15, height: 50)
                                    .overlay {
                                        Text(product.displayPrice)
                                    }
                                    .onTapGesture { selectedAmount = product }
                            }
                        }
                        VStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor((selectedAmount != nil) ? .green.opacity(0.65) : .gray.opacity(0.7))
                                .frame(width: UIScreen.main.bounds.size.width/3 - 10, height: 50)
                                .overlay {
                                    Text("Send Tip")
                                }
                                .onTapGesture {
                                    if selectedAmount != nil {
                                        Task {
                                            await tip(amount: selectedAmount!)
                                        }
                                    }
                                }
                            
                            Text("Next time").font(.caption).italic().underline()
                                .onTapGesture { showTipView = false }
                        }
                    }
                }
        }
        .onDisappear { selectedAmount = nil }
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
    }
    
    @MainActor
    func tip(amount: Product) async {
        if ((await viewModel.tip(amount: amount)) != nil) {
            showTipView = false
        }
    }
}

struct CoinBack: View {
    @Binding var degrees: Double

    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(.blue.opacity(0.5))
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: UIScreen.main.bounds.size.width - 30)
                .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
                .overlay {
                    VStack {
                        Text("Cocktail Pantry").font(.headline).bold()
                        Text("in association with").font(.caption).italic()
                        Image("The Educated Barfly Logo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width - 160, height: UIScreen.main.bounds.size.width - 310)
                    }
            }
        }
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
    }
}


struct Coin_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DoubleSidedCoin(showTipView: Binding.constant(true)).environmentObject(ViewModel())
        }
    }
}
