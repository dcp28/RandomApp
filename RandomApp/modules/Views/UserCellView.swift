//
//  UserCellView.swift
//  RandomApp
//
//  Created by Random Inc. on 3/4/22.
//

import SwiftUI

struct UserCellView: View {
    private let user: User

    init(user: User) {
        self.user = user
    }

    private var emailLabel: String {
        String(localized: "Email")
    }

    private var phoneLabel: String {
        String(localized: "Phone")
    }

    var body: some View {
        HStack {
            user.picture
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading) {
                Text(user.fullName).font(.headline).padding(.top)
                Divider()
                newField(fieldName: emailLabel, value: user.email)
                newField(fieldName: phoneLabel, value: user.phone)
            }
        }
    }

    func newField(fieldName: String, value: String) -> some View {
        HStack {
            Text(fieldName + ":").bold().font(.caption)
            Spacer()
            Text(value).font(.caption)
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(user: User(fullName: "Dede pep", picture: Image("defaultUserIcon"), email: "dedepep@gmail.com", phone: "+34667599007"))
    }
}
