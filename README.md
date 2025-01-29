# Payment Reminder App

A simple Rails 7.2.2 application to manage payment reminders. Users can create, update, and delete reminders, and due reminders are displayed at the top of every page.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Server](#running-the-server)
- [Usage](#usage)
- [Features](#features)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Requirements
- Ruby `3.2.2`
- Rails `7.2.2`
- PostgreSQL `>= 12`
- Bundler

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rohinirao/remind_pay
   cd remind_pay
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

## Running the Server

Start the Rails server:
```bash
rails server
```

By default, the application runs on `http://localhost:3000/`. You can visit:

- `http://localhost:3000/` - Home page
- `http://localhost:3000/reminders` - Manage reminders (Create, Update, Delete)

## Usage
- Users can **create, update, and delete reminders**.
- **Due reminders** (past reminders) are **displayed at the top of every page**.

## Features
✅ Add, edit, and delete reminders  
✅ Displays all reminders in order of due date  
✅ Past due reminders appear on every page  
✅ Uses **Active Job & ActionCable** for real-time notifications  

## Testing

Run tests using:
```bash
rspec
```

## License
This project is licensed under the MIT License.