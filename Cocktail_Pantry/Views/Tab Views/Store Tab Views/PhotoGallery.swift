//
//  PhotoGallery.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/5/23.
//

import SwiftUI

struct PhotoGallery: View {
    let photosAndLinks: [(String, String)] = [ ("nick&nora_4pc", "https://www.amazon.com/dp/B07T93VWRN?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B07T93VWRN&asc_item-id=amzn1.ideas.310T9DMXIU8O2&ref_=aip_sf_list_spv_ons_mixed_d_asin"), ("rocks_4pc", "https://www.amazon.com/dp/B07DWY1TJX?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B07DWY1TJX&asc_item-id=amzn1.ideas.310T9DMXIU8O2&ref_=aip_sf_list_spv_ons_mixed_d_asin"), ("footed_rocks", "https://www.amazon.com/dp/B00HWQSLS8?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B00HWQSLS8&asc_item-id=amzn1.ideas.310T9DMXIU8O2&ref_=aip_sf_list_spv_ons_mixed_d_asin"), ("hawthorne_strainer", "https://www.amazon.com/dp/B07FPFD5R7?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B07FPFD5R7&asc_item-id=amzn1.ideas.34E1NF6K45O8U&ref_=aip_sf_list_spv_ons_mixed_d_asin"), ("jigger", "https://www.amazon.com/dp/B07FP9JMQT?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B07FP9JMQT&asc_item-id=amzn1.ideas.34E1NF6K45O8U&ref_=aip_sf_list_spv_ons_mixed_d_asin"), ("shaker_tins", "https://www.amazon.com/dp/B01LZAW9EM?tag=onamztheeduca-20&linkCode=ssc&creativeASIN=B01LZAW9EM&asc_item-id=amzn1.ideas.34E1NF6K45O8U&ref_=aip_sf_list_spv_ons_mixed_d_asin")]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let frame: (CGFloat, CGFloat)
    
    init(width: CGFloat, height: CGFloat) {
        self.frame = (width, height)
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(photosAndLinks, id: \.self.0) { photo, link in
                Link(destination: URL(string: link)!) {
                    Image(photo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: frame.0 / 3, height: frame.1 / 2)
                }
            }
        }
    }
}


struct PhotoGallery_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGallery(width: 200, height: 200)
    }
}
