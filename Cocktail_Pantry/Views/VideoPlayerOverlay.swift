//
//  VideoPlayerOverlay.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 10/30/22.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayerOverlay: View {
    @Binding var id: String
    var youTubePlayer: YouTubePlayer  {
        YouTubePlayer(stringLiteral: "https://www.youtube.com/embed/\(id)")
    }
    @Binding var showVideoPlayerOverlay: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "x.square")
                    .imageScale(.large)
                    .foregroundColor(.white)
//                    .shadow(color: .black, radius: 15, x: -4, y: 0)
                    .onTapGesture { showVideoPlayerOverlay = false }
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
                .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height * 0.25)
                .cornerRadius(5)
                .background {
                    Color.white.opacity(0.5)
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.27)
                }
            }
            .shadow(color: .black, radius: 15, x: 0, y: 0)
        }
    }
}

struct VideoPlayerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerOverlay(id: Binding.constant("st5kh_49C1I"), showVideoPlayerOverlay: Binding.constant(true))
    }
}
