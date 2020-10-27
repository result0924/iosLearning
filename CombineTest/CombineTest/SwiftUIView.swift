//
//  SwiftUIView.swift
//  CombineTest
//
//  Created by jlai on 2020/10/27.
//

import UIKit
import SwiftUI

struct SwiftUIView: View {
    
    @ObservedObject var viewModel = MovieViewModel()
    
    var body: some View {
        List(viewModel.movies) { movie in
            HStack {
                VStack(alignment: .leading) {
                    Text(movie.title).font(.headline)
                    Text(movie.originalTitle).font(.subheadline)
                }
            }
        }
    }
}

class ChildHostingController: UIHostingController<SwiftUIView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: SwiftUIView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
