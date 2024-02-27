//
//  ObstacleRow.swift
//  NinjaFit
//
//  Created by Laura Erickson on 10/1/23.
//

import SwiftUI

struct ObstacleRow: View {
    @Binding var obstacle: Obstacle
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(obstacle.name).fontWeight(.bold).font(.system(size: 17))
                    Spacer()
                }
                if (obstacle.hasHalfway) {
                    HStack {
                        Text(String("Halfway:")).padding(.bottom, 1)
                        Text(obstacle.halfwayDescription ?? "")
                        Spacer()
                    }.font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    ObstacleRow(obstacle: .constant(Obstacle.obstacle1))
}
