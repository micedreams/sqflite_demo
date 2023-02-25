# sqflite_demo
A new Flutter project to demonstrate how to use SQLite in a flutter app.

## What is Sqflite? What can it do for us?
1. SQFlite is a plugin that helps to integrate SQLite in a flutter app.
2. SQLite is a database engine written in the C programming language used to  store data locally on the system. In our case our mobile device.
3. It can do crud operations like Create, Read, Update and Delete.


## Getting Started

## Part 1: Prerequisites.

### Step 1: Add a data model.

1. Create a class with the required properties and a method to map the data before inserting it into the database.
2. This class is used to show the data structure of the object, we want to manipulate inside the database.

    *Note: I am using [freezed](https://pub.dev/packages/freezed), [freezed_annotation](https://pub.dev/packages/freezed_annotation) to keep the data model immutable and [json_serializable](https://pub.dev/packages/json_serializable) to write the toJson method but we can always write this manually.*


#### Step 2: Add the dependencies.

  Add the *[sqflite](https://pub.dev/packages/sqflite)* and *[path_provider](https://pub.dev/packages/path_provider)* packages into the ***pubspec.yaml*** file in the project.

  1. sqflite: The SQLite package to integrate SQLite database functions. *[Note: Do not misspell the word ‘sqflite’]*

  2. path_provider: The package to specify the path of the database.


  ```
  dependencies:
    path_provider: ^2.0.13
    sqflite: ^2.2.4+1
  ```

## Part 2: Setup - CRUD with Flutter and SQLite
  Create a class called DBPHelper that will be responsible for creating the database, the database table, and the database operations like create, insert, update and delete the data.

  *Note: We will use the **Singleton pattern** to create this class.*

### Step 3: Create a database.
   1. Under the lib folder, create a new file called ***database_helper.dart***.
   2. Add the required imports to this file.
   3. Create a new class called ***DBPHelper***.
   4. Create a Database object and instantiate it if not initialized.
   5. If the database is not initialized, create a database and also the database table.(in our case, contacts.db and the Contacts table) [initDB function]
   
### Step 4: C in CRUD - Add an entry to the database. [addEntry function]
Create a function to get the data model, convert it into a map and insert data into the database using insert() helper method.

### Step 5: R in CRUD - Read the entries from the database. [readTable function]
Using sqflite we can query data in many ways by using arguments such as where, groupBy, having, orderBy and columns inside query() helper.

### Step 6: U in CRUD - Update an entry from the database. [updateEntry function]
Use update() helper to update any record in the database. To update specific records, use the where argument.

### Step 7: D in CRUD - Delete an entry from the database. [deleteEntry function]
Use the where argument in delete() helper to delete specific rows from the table.

## Part 3 - Usage
  Finally fix our view class to do the CRUD. and there we have it a simple.

