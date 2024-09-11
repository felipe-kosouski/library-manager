# Library Management System

## Objective
Develop a web application to manage a library's book inventory and user borrowings.

## Features
### Authentication and Authorization
- Users can register, log in, and log out.
- Two types of users: Librarian and Member.
- Only Librarian users can add, edit, or delete books.

### Book Management
- Add a new book with details like title, author, genre, ISBN, and total copies.
- Edit and delete book details.
- Search for a book by title, author, or genre.

### Borrowing and Returning
- Member users can borrow a book if it's available. They can't borrow the same book multiple times.
- The system tracks when a book was borrowed and when it's due (2 weeks from the borrowing date).
- Librarian users can mark a book as returned.

### Dashboard
- **Librarian**: A dashboard showing total books, total borrowed books, books due today, and a list of members with overdue books.
- **Member**: A dashboard showing books they've borrowed, their due dates, and any overdue books.

### API Endpoints
- API endpoints are under `/api/v1`
- API endpoints were implemented for the following actions: 

#### Book

| Method   | URL                                                                  | Description                                                          |
|----------|----------------------------------------------------------------------|----------------------------------------------------------------------|
| `GET`    | `/api/v1/books`                                                      | Retrieve all books.                                                  |
| `GET`    | `/api/v1/books?title=book_title&author=author_name&genre=book_genre` | Search for books using title, author or genre.                       |
| `GET`    | `/api/v1/books/:id`                                                  | Retrieve a book by id.                                               |
| `POST`   | `/api/v1/books`                                                      | Create a new book.                                                   |
| `PATCH`  | `/api/v1/books/:id`                                                  | Update data for a given book.                                        |
| `DELETE` | `/api/v1/books/:id`                                                  | Delete a given book.                                                 |

#### Borrowing

| Method   | URL                             | Description                        |
|----------|---------------------------------|------------------------------------|
| `GET`    | `/api/v1/borrowings`            | Retrieve all borrowings.           |
| `GET`    | `/api/v1/borrowings/:id`        | Retrieve a borrowing by id.        |
| `POST`   | `/api/v1/borrowings`            | Create a new borrowing.            |
| `PATCH`  | `/api/v1/borrowings/:id`        | Update data for a given borrowing. |
| `PATCH`  | `/api/v1/borrowings/:id/return` | Return a borrowed book.            |
| `DELETE` | `/api/v1/borrowings/:id`        | Delete a given borrowing.          |


### Frontend
- There's a branch that I started that adds Vue.JS to the project. The main idea was to try to bring VueJS to the main RoR application without having a separate frontend application. The code is not finished and it's not merged to the main branch.
- [`vue-integration`](https://github.com/felipe-kosouski/library-manager/tree/add-vue-frontend)


## Setup Instructions

---

## Local

### Ruby Version
- Ensure you have Ruby installed. This project uses Ruby version specified in the `Gemfile`.

### System Dependencies
- Install dependencies using Bundler and Yarn:
  ```sh
  bundle install
  yarn install
  ```

### Database Creation
- The database used for this application is postgresql. Ensure you have postgresql installed and running.
- Update the `config/database.yml` file with your database credentials.
- Create the database:
  ```sh
  rails db:create
  ```

### Database Initialization
- Run migrations and seed the database:
  ```sh
  rails db:migrate
  rails db:seed

---
## Docker
- Build the images using docker compose:
    ```sh
    docker-compose build
    ```
  
### Setup the database and seeds
- Run the following commands to setup the database and seed data:
    ```sh
    docker-compose run web rails db:setup
    ```
  
---

### How to Run the Test Suite
- Run RSPEC tests:
  ```sh
  bundle exec rspec
  ```

## Seed Data
- The application includes seeded data for demo purposes.

## Thought Process 
- I started by defining the models and their relationships based on the requirements.
- I then implemented the basic model unit tests.
- Implemented the Book and Borrowing controllers.
- Implemented request tests for the Book and Borrowing controllers.
- Implemented Authentication with Devise.
- Implemented the dashboard for Librarian and Member users.
- Implemented API endpoints for Books and Borrowings.
- Implemented the authorization logic using Cancancan.
- Implemented and fixed more tests.

## Future Improvements
- Implement frontend using Vue.
- Add more features like pagination, and sorting.
- Add more tests for edge cases.
- Extract some of the code for borrowing and retuning a book to service objects (left some comments about this in the code).
- Implement JWT authentication for the API.