# sqflite_demo
A new Flutter project to demonstrate how to use SQLite in a flutter app.

## What is Sqflite? What can it do for us?
1. SQFlite is a plugin that helps to integrate SQLite in a flutter app.
2. SQLite is a database engine written in the C programming language used to  store data locally on the system. In our case our mobile device.
3. It can do crud operations like Create, Read, Update and Delete.


## Getting Started

### Step 1: Add a data model.

1. Create a class with the required properties and a method to map the data before inserting into the database.
2. This class is used to show the data structure of the object, we want to manipulate inside the database.

    *Note: I am using [freezed](https://pub.dev/packages/freezed), [freezed_annotation](https://pub.dev/packages/freezed_annotation) to keep the data model immutable and [json_serializable](https://pub.dev/packages/json_serializable) to write the toJson method but we can always write this manually.*

