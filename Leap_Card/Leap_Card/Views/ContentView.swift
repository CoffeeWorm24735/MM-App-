//
//  ContentView.swift
//  Leap_Card
//
//  Created by Charlie Brady on 15/07/2021.
//
//10, 166, 39
import SwiftUI
import UIKit
import CoreNFC


struct ContentView: View{
   

    let x = NfcActionGroup()
    var boarder = bounds()
    @State var menuOpen = false
    @State var Menu = true
    @State var ShareOpen = false
    let ImageShare = Image(systemName: "square.and.arrow.up").resizable()
    var body: some View {
        // Add ZStack for backgroud color
        
        
        
        ZStack{
            // BAckground
         
            LinearGradient(gradient: Gradient(colors: [Color("GraStart"), Color("GraEnd")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if menuOpen{
            MenuView.SideMenu(
                        width: 125,
                isOpen: self.menuOpen
                
            )
                
            }
            VStack(alignment: .leading) {
           
            
            HStack{
               
            Button(action: {
                self.menuOpen.toggle()
                self.Menu.toggle()
                print(menuOpen)

                        
                    }, label: {
                            Image("menu")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .topLeading)
                                .animation(.linear)
                                .rotationEffect(.degrees( 90))
                                

                        Spacer()
                        
                    })
            .frame(width: 60, height: 40, alignment: .leading)
            Spacer()
                
            }
            if Menu{
                Spacer()
               .frame(height: 50)
                HStack{
               Spacer()
                        .frame(width: boarder.w - 350)
                    Image("logo")
                    .resizable()
                    .frame(width: boarder.w - 120, height: boarder.w - 120, alignment: .center)
                }
                Text("To add your first LeapCard tap the button below to  begin the scan")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("HomeText"))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(width: boarder.w, alignment: .center)
                    
           
               Spacer()
                .frame( height: 50)
            
          
            
           
            AddButtonView()
                // Add offset so they appear in the center of the screen
                .offset(y: 20)
        
            Spacer()
              
            // Add Version to bottom of screen 
                HStack{
                Spacer()
                        .frame(width: boarder.w-300)
                    Text("Beta V0.2")
                .frame(height: 20)
                .offset(x: -50)
                .foregroundColor(.black)
                   
             Spacer()
                    .frame(width: boarder.w - 250)
                       
                // Share Button
                ImageShare.onTapGesture{
                    self.ShareOpen = true
            
                }
                .frame(width: 35, height: 43, alignment: .trailing).foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                
            
      
            
                }
                // Open Share menu
                .sheet(isPresented: $ShareOpen) {
                   ShareSheet(activityItems: ["Hello World"])
        }
        
           
           
            }
          
            if Menu == false{
                Spacer()
                    .frame(height: boarder.h - 130)
            }


        
            }
            .padding(.top)
       
   
    }
    
    }
        
  

}
   


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }

}
