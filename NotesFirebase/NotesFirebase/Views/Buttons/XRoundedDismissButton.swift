//
//  XRoundedDismissButton.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct XRoundedDismissButton: View {
    
    @Binding var isShowingView: Bool
    
    var body: some View {
        HStack() {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .opacity(0.6)
                
                Button {
                    isShowingView = false
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.black)
                }
            }
        }
        .padding([.top, .trailing], 5)
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XRoundedDismissButton(isShowingView: .constant(false))
    }
}
