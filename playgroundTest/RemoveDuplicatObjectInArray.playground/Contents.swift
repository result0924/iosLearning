import UIKit

func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: string)
    return date!
}

struct Contact {
    let name: String
    let date: Date
}

let contacts = [
    [
        Contact(name: "abc", date: stringConvertDate(string: "2012-08-24 12:22:32")),
        Contact(name: "abc", date: stringConvertDate(string: "2012-08-24 12:22:32")),
        Contact(name: "bcd", date: stringConvertDate(string: "2012-08-24 12:22:32")),
        Contact(name: "abc", date: stringConvertDate(string: "2012-08-24 12:22:00")),
        Contact(name: "abc", date: stringConvertDate(string: "2012-08-24 12:22:32"))
    ],
    [
        Contact(name: "zzz", date: stringConvertDate(string: "2012-07-24 12:22:32")),
        Contact(name: "zzz", date: stringConvertDate(string: "2012-07-24 12:22:32")),
        Contact(name: "xxx", date: stringConvertDate(string: "2012-07-24 12:22:32")),
        Contact(name: "zzz", date: stringConvertDate(string: "2012-07-24 12:22:32")),
        Contact(name: "yyy", date: stringConvertDate(string: "2012-07-24 12:22:00"))
    ],
]

let filterContact: [[Contact]] = contacts.map { contactArray in
    let contactAry = contactArray.reduce([]) { (result, contact) -> [Contact] in
        guard !result.contains(where: { (c) -> Bool in
            guard c.date == contact.date else {
                return false
            }
            let sameName = c.name == contact.name
            return sameName
        }) else {
            return result
        }
        return result + [contact]
    }
    return contactAry
}

filterContact.map { contactArray in
    print("=====")
    contactArray.map { contact in
        print("name:\(contact.name)")
    }
}
