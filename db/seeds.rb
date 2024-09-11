# Create Librarian Users
librarian1 = User.create!(email: 'librarian1@example.com', password: 'password', role: 'librarian')
librarian2 = User.create!(email: 'librarian2@example.com', password: 'password', role: 'librarian')

# Create Member Users
member1 = User.create!(email: 'member1@example.com', password: 'password', role: 'member')
member2 = User.create!(email: 'member2@example.com', password: 'password', role: 'member')

# Create Books
book1 = Book.create!(title: 'Book One', author: 'Author One', genre: 'Fiction', isbn: '1234567890', total_copies: 5)
book2 = Book.create!(title: 'Book Two', author: 'Author Two', genre: 'Non-Fiction', isbn: '0987654321', total_copies: 3)
book3 = Book.create!(title: 'Book Three', author: 'Author Three', genre: 'Science', isbn: '1122334455', total_copies: 2)

# Create Borrowings
Borrowing.create!(user: member1, book: book1, borrowed_on: Date.today - 10, due_on: Date.today + 4)
Borrowing.create!(user: member2, book: book2, borrowed_on: Date.today - 15, due_on: Date.today - 1, returned_on: Date.today - 1)
Borrowing.create!(user: member1, book: book3, borrowed_on: Date.today - 5, due_on: Date.today + 9)