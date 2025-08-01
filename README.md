# Insurance Policies Management System

## Project Overview

A Ruby on Rails application to manage insurance policies with role-based access control. Three user roles determine what each user can do:

- **Admin**: Full CRUD access to all policies.
- **Operator**: Can create and view all policies.
- **Client**: Can view only their own policies.

Each policy includes:
- A **12-digit**, unique policy number (auto-generated).
- A **client** (user) association.
- **Start** and **end** dates (with validation that end ≥ start).
- A **status** (`active`, `pending`, `expired`, `canceled`).

## Features

- **Authentication** with Devise  
- **Authorization** with CanCanCan  
- **Auto-generated** 12-digit policy numbers (via `before_create` callback)  
- **Enum** for status values  
- **Validated** policy dates and formats  
- **Tailwind CSS** for styling  
- **RSpec** test suite (model, controller, request specs)  
- **RuboCop** for linting and style  

## Tech Stack

- **Ruby** 3.2.1  
- **Rails** 7.x  
- **Database**: PostgreSQL (or any supported relational DB)  
- **Styling**: Tailwind CSS (via `tailwindcss-rails`)  
- **Auth**: Devise  
- **Permissions**: CanCanCan  
- **Testing**: RSpec + FactoryBot + Shoulda Matchers  
- **Linting**: RuboCop (+ `rubocop-rails`, `rubocop-performance`)  

## Setup & Installation

1. **Clone the repo**  
   ```bash
   git clone git@github.com:yourusername/insurance-policies.git
   cd insurance-policies
   ```
2. **Install gems**  
   ```bash
   bundle install
   ```
3. **Install Tailwind**  
   ```bash
   rails tailwindcss:install
   ```
4. **Set up the database**  
   ```bash
   rails db:create db:migrate
   ```
5. **Start the server**  
   ```bash
   rails server
   ```
6. **Seed users** (optional)  
   You can create Admin/Operator/Client users via the Rails console or a seed file:
   ```ruby
   User.create!(email: "admin@example.com", password: "password", role: :admin)
   ```

## Usage

- Visit `http://localhost:3000`  
- Sign up or sign in with seeded accounts.  
- Navigate to **Policies** to list, view, create, edit, or delete, depending on your role.

## Running Tests & Lint

- **Lint**:  
  ```bash
  bundle exec rubocop
  ```
- **Auto-correct**:  
  ```bash
  bundle exec rubocop -A
  ```
- **Run specs**:  
  ```bash
  bundle exec rspec
  ```

## Contributing

1. Fork the repository  
2. Create a feature branch (`git checkout -b my-feature`)  
3. Commit your changes (`git commit -m "Add new feature"`)  
4. Push to your branch (`git push origin my-feature`)  
5. Open a Pull Request  

Please run `bundle exec rubocop` and `bundle exec rspec` before opening a PR.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.
