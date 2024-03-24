import Foundation

//შევქმნათ Class Book.
//Properties: bookID(უნიკალური იდენტიფიკატორი Int), String title, String author, Bool isBorrowed.
//Designated Init.
//Method რომელიც ნიშნავს წიგნს როგორც borrowed-ს.
//Method რომელიც ნიშნავს წიგნს როგორც დაბრუნებულს.

class Book {
    var bookID: Int
    var title: String
    var author: String
    var isBorrowed: Bool
    
    
    init(title: String, author: String, isBorrowed: Bool) {
        self.bookID = UUID().hashValue
        self.title = title
        self.author = author
        self.isBorrowed = isBorrowed
    }
    
    
    func markAsBorrowed() {
        if !self.isBorrowed {
            self.isBorrowed = true
        }
    }
    
    func markAsReturned() {
        if self.isBorrowed {
            self.isBorrowed = false
        }
    }
    
}


//შევქმნათ Class Owner
//
//Properties: ownerId(უნიკალური იდენტიფიკატორი Int), String name, Books Array სახელით borrowedBooks.
//Designated Init.
//Method რომელიც აძლევს უფლებას რომ აიღოს წიგნი ბიბლიოთეკიდან.
//Method რომელიც აძლევს უფლებას რომ დააბრუნოს წაღებული წიგნი.

class Owner {
    var ownerId: Int
    var name: String
    private var borrowedBooks: [Book] //private იყოს გარედან წვდომა რომარ შეგვეძლოს და გეთერით ვნახოთ მხოლოდ
    
    init(name: String, borrowedBooks: [Book] = []) {
        self.ownerId = UUID().hashValue
        self.name = name
        self.borrowedBooks = borrowedBooks
    }
    
    func getBorrowedBooks() -> [Book] {
        return borrowedBooks
    }
    
    //Method რომელიც აძლევს უფლებას რომ აიღოს წიგნი ბიბლიოთეკიდან.
    
    func borrowBooks(book: Book)  {
        if !borrowedBooks.contains(where: { myBook in //უკვე გატანილი წიგნი მეორედ რო ვერ გაიტანოს
            book.bookID == myBook.bookID
        }) {
            borrowedBooks.append(book)
        }
    }
    
    //Method რომელიც აძლევს უფლებას რომ დააბრუნოს წაღებული წიგნი.
    
    func returnBook(book: Book) {
        
        if borrowedBooks.contains(where: { myBook in
            book.bookID == myBook.bookID
        }) {
            if let index = borrowedBooks.firstIndex(
                where: { $0.bookID == book.bookID }
            ) {
                borrowedBooks.remove(at: index)
            }
        } else {
            print("ეს წიგნი არ გქონდათ წაღებული") //Just in case ისეთი წიგნი რომ ვერ დააბრუნოს რაც არც წაუღია
        }
        
    }
    
    
}

//შევქმნათ Class Library
//
//Properties: Books Array, Owners Array.
//Designated Init.
//Method წიგნის დამატება, რათა ჩვენი ბიბლიოთეკა შევავსოთ წიგნებით.
//Method რომელიც ბიბლიოთეკაში ამატებს Owner-ს.
//Method რომელიც პოულობს და აბრუნებს ყველა ხელმისაწვდომ წიგნს.
//Method რომელიც პოულობს და აბრუნებს ყველა წაღებულ წიგნს.
//Method რომელიც ეძებს Owner-ს თავისი აიდით თუ ეგეთი არსებობს.
//Method რომელიც ეძებს წაღებულ წიგნებს კონკრეტული Owner-ის მიერ.
//Method რომელიც აძლევს უფლებას Owner-ს წააღებინოს წიგნი თუ ის თავისუფალია.

class Library {
    private var booksArray: [Book]
    private var ownersArray: [Owner]
    
    
    init(booksArray: [Book] = [], ownersArray: [Owner] = []) {
        self.booksArray = booksArray
        self.ownersArray = ownersArray
    }
    
    
    func getLibrarysBooks() -> [Book] { //გეთერი წიგნების ერეისთვის, ფრაივეთი იყოს ერეი ჯობია რომ გარედან არ შეიცვალოს პირდაპირ რამე
        return booksArray
    }
    
    func getOwners() -> [Owner]{ //ბარემ იყოს owner-ების ერეის გეთერიც
        return ownersArray
    }
    
    //Method წიგნის დამატება, რათა ჩვენი ბიბლიოთეკა შევავსოთ წიგნებით.
    
    func addBook(book: Book) {
        booksArray.append(book)
        //print("წიგნი '\(book.title)' დამატებულია ბიბლიოთეკაში")
    }
    
    func addOwner(owner: Owner) {
        ownersArray.append(owner)
    }
    
    //Method რომელიც პოულობს და აბრუნებს ყველა ხელმისაწვდომ წიგნს.
    
    func findAvailableBooks() -> [Book] {
        return booksArray.filter { book in
            !book.isBorrowed
        }
    }
    
    ///Method რომელიც პოულობს და აბრუნებს ყველა წაღებულ წიგნს.
    
    func findBorrowedBooks() -> [Book] {
        return booksArray.filter { book in
            book.isBorrowed
        }
    }
    
    //Method რომელიც ეძებს Owner-ს თავისი აიდით თუ ეგეთი არსებობს.
    
    func findOwner(id: Int) -> Owner? {
        for owner in ownersArray {
            if id == owner.ownerId {
                return owner
            }
        }
        
        return nil
    }
    
    //Method რომელიც ეძებს წაღებულ წიგნებს კონკრეტული Owner-ის მიერ.
    
    func borrowedBooksBy(owner: Owner) -> [Book] {
        return owner.getBorrowedBooks()
    }
    
    
    //Method რომელიც აძლევს უფლებას Owner-ს წააღებინოს წიგნი თუ ის თავისუფალია.
    
    //ვთქვათ მაქვს წიგნის ინსტანსი მაგრამ ეს წიგნი არ დავამატე ბიბლიოთეკაში, ამ შემთხვევაში ვერ წაიღებენ და გამოვიტან შეტყობინებას
    //რომ ეს წიგნი არაა ბიბლიოთეკაში.
    
    func borrowBookIfItsAvailable(book: Book, owner: Owner) {
        var isBookInOurLibrary = booksArray.contains(where: { myBook in
            book.bookID == myBook.bookID && !book.isBorrowed
        })
        
        if isBookInOurLibrary  {
            owner.borrowBooks(book: book)
            if let index = booksArray.firstIndex(
                where: { $0.bookID == book.bookID }
            ) {
                book.markAsBorrowed()
            }
            print("\(owner.name)მ გაიტანა წიგნი '\(book.title)'")
            
        }
        
        else {
            print("'\(book.title)' არ არის ჩვენს ბიბლიოთეკაში")
        }
    }
    
    func returnBookFromOwner(book: Book, owner: Owner) {
        
        var ownerHasBook = owner.getBorrowedBooks().contains(where: { myBook in
            book.bookID == myBook.bookID
        })
        
        if ownerHasBook && book.isBorrowed == true {
            owner.returnBook(book: book)
            book.markAsReturned()
            print("\(owner.name)მ '\(book.title)' დააბრუნა ბიბლიოთეკაში")
        }
        
        else {
            print("ეს წიგნი ჯერ არ არის გატანილი ") //თავიდან რომ ავიცილოთ ისეთი წიგნის "დაბრუნება" რაც რეალურად არც წაუღია ჯერ არავის
        }
    }
    
    
    
    
    
}




//შევქმნათ რამოდენიმე წიგნი და რამოდენიმე Owner-ი, შევქმნათ ბიბლიოთეკა.
//დავამატოთ წიგნები და Owner-ები ბიბლიოთეკაში
//წავაღებინოთ Owner-ებს წიგნები და დავაბრუნებინოთ რაღაც ნაწილი.
//დავბეჭდოთ ინფორმაცია ბიბლიოთეკიდან წაღებულ წიგნებზე, ხელმისაწვდომ წიგნებზე და გამოვიტანოთ წაღებული წიგნები კონკრეტულად ერთი Owner-ის მიერ.

var foundation = Book(title: "დასაბამი და იმპერია", author: "აიზეკ აზიმოვი", isBorrowed: false)
var ziddhartha = Book(title: "ზიდჰარტა", author: "ჰერმან ჰესე", isBorrowed: false)
var fahrenheit451 = Book(title: "451 ფარენჰეიტით", author: "რეი ბრედბერი", isBorrowed: false)
var cubanDeathLift = Book(title: "Cuban Death-lift", author: "Randy Wayne White", isBorrowed: false)
var doAndroidsDreamOfElectricSheep = Book(title: "ოცნებობენ ანდროიდები ელექტრულ ცხვრებზე?", author: "ფილიპ დიკი", isBorrowed: false)
var theBacchae = Book(title: "The Bacchae", author: "Euripides", isBorrowed: false)

var whiteNights = Book(title: "White Nights", author: "Fyodor Dostoevsky", isBorrowed: false) //ერთი ისეთი წიგნი რომელსაც არ დავამატებ ბიბლიოთეკაში

var tamo = Owner(name: "თამო")
var nino = Owner(name: "ნინო")
var library = Library()

library.addBook(book: foundation)
library.addBook(book: ziddhartha)
library.addBook(book: fahrenheit451)
library.addBook(book: cubanDeathLift)
library.addBook(book: doAndroidsDreamOfElectricSheep)
library.addBook(book: theBacchae)

print("ბიბლიოთეკის წიგნები: ",library.getLibrarysBooks().map({ book in
    book.title
}))

library.addOwner(owner: tamo)
library.addOwner(owner: nino)

print("მომხმარებლები: ",library.getOwners().map({ owner in
    owner.name
}))



library.borrowBookIfItsAvailable(book: foundation, owner: tamo)
library.borrowBookIfItsAvailable(book: doAndroidsDreamOfElectricSheep, owner: tamo)
library.borrowBookIfItsAvailable(book: theBacchae, owner: nino)

library.returnBookFromOwner(book: doAndroidsDreamOfElectricSheep, owner: tamo)

library.borrowBookIfItsAvailable(book: whiteNights, owner: tamo) //ისეთ წიგნს ვერ გავიტანთ რაც ბიბლიოთეკაში არ გვაქვს


print("ხელმისაწვდომია შემდეგი წიგნები:", library.findAvailableBooks().map({ book in
    book.title
}))

print("გატანილია შემდეგი წიგნები:", library.findBorrowedBooks().map({ book in
    book.title
}))


print("თამოს გატანილი წიგნებია:", library.borrowedBooksBy(owner: tamo).map({ book in
    book.title
}))
