//
//  VersionInfo.swift
//  Leap_Card
//
//  Created by Charlie Brady on 02/08/2021.
//

import SwiftUI

struct VersionInfo: View {
    var boarder = bounds()
    var body: some View {
        

        ZStack{
            // Add background color gradient
            LinearGradient(gradient: Gradient(colors: [Color("NavStart"), Color("NavEnd")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack{
                // Add text that is desplayed as the version info
                Text("In this verion I have added new Styling for buttons and the backbone for the main feature of adding the card to your wallet")
                    .foregroundColor(Color.black)
                    .frame(width: boarder.w - 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
           Spacer()
            .frame(height: 50)
                Text("Beta V0.3 will come out as soon as I gain my NFC certificate from Apple which can take 2-3 weeks")
                    .foregroundColor(Color.black)
                    .frame(width: boarder.w - 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .frame(width: boarder.w - 75, alignment: .center)
        }
    }
}

struct VersionInfo_Previews: PreviewProvider {
    static var previews: some View {
        VersionInfo()
    }
}
