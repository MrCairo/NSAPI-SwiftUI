//
//  APODtextView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/13/21.
//

import SwiftUI

struct APODTextView: View {
    let text: String
    private let textStyle = UIFont.TextStyle.body

    var body: some View {
        APODUITextView(text: text, textStyle: textStyle)
    }
}

struct APODUITextView: UIViewRepresentable {
    var text: String
    var textStyle: UIFont.TextStyle

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
}


#if DEBUG
let longDescription = """
One of the brightest galaxies in planet Earth's sky is similar in size to our Milky Way Galaxy: big, beautiful Messier 81. Also known as NGC 3031 or Bode's galaxy for its 18th century discoverer, this grand spiral can be found toward the northern constellation of Ursa Major, the Great Bear. The sharp, detailed telescopic view reveals M81's bright yellow nucleus, blue spiral arms, pinkish starforming regions, and sweeping cosmic dust lanes. Some dust lanes actually run through the galactic disk (left of center), contrary to other prominent spiral features though. The errant dust lanes may be the lingering result of a close encounter between M81 and the nearby galaxy M82 lurking outside of this frame. M81's faint, dwarf irregular satellite galaxy, Holmberg IX, can be seen just below the large spiral. Scrutiny of variable stars in M81 has yielded a well-determined distance for an external galaxy -- 11.8 million light-years.
"""
struct APODTextView_Previews: PreviewProvider {
    static var previews: some View {
        APODTextView(text: longDescription)
    }
}
#endif
