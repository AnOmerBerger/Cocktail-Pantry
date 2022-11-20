//
//  TipViewV2.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/14/22.
//

import SwiftUI


struct DoubleSidedCoin: View {
    @State var frontDegree: Double = 0.0
    @State var backDegree: Double = -90
    @State var startFlip: Bool = false
    
    
    let durationAndDelay: CGFloat = 0.13
    
    var body: some View {
        ZStack {
            CoinFront(degrees: $frontDegree)
            CoinBack(degrees: $backDegree)
        }
        .onTapGesture {
            flipCoin()
            frontDegree = 0
            backDegree = -90
        }
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
                    VStack(spacing: 40) {
                        Text("tip your bartender?").bold()
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.green.opacity(0.65))
                                .frame(width: UIScreen.main.bounds.size.width/3 - 10, height: 50)
                                .overlay {
                                    Text("thanks!")
                            }
                            Text("Next time").font(.caption).italic()
                        }
                    }
                }
        }
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
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
            DoubleSidedCoin()
        }
    }
}
