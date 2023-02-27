# sqflite_demo
A new Flutter project to demonstrate how to use SQLite in a flutter app.

https://user-images.githubusercontent.com/8918999/221352915-7c93c4bd-dc3b-4d3a-b584-8cf4af61c00c.mov

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
   5. If the database is not initialized, create a database and also the database table.
   (in our case, contacts.db and the Contacts table) [initDB function]

  ```
  /// Create the database and the Contacts table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'contacts.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Contacts('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'city TEXT'
          ')');
    });
  }
  ```
   
### Step 4: C in CRUD - Add an entry to the database.
   1. Create a function to add an entry to the database. Lets call this **addNewContact()**.
   2. This function takes an entry object as argument. in our case the Person object.
   3. Inside this function call ***db.insert()*** method to add the object to the database.
   4. The *insert* method accepts 2 positinal parameters, the table name and the entry object in its json form(in that order), 2 optional parameters and returns the id of the entry. 

  ```
  /// Insert a contact to the database
  addNewContact(Person contact, {bool onRefresh = false}) async {
    final db = await database;

    await db?.insert(
      'Contacts',
      contact.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  ```

### Step 5: R in CRUD - Read the entries from the database.
With sqflite we can query data in many ways by using arguments such as where, groupBy, having, orderBy and columns inside query() helper. Here we are only using *select*.
   1. Create a function to read all the entrries from the database. Lets call this **getAllContacts()**.
   2. Inside this function call ***db.rawQuery()*** method to fetch all the entries of our table.
   3. The *rawQuery* method accpets an sql query, and returns the result in the form of a **JSON**.

  ```
  /// Read all Contacts from the database.
  Future<List<Person>> getAllContacts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM Contacts");

    List<Person> list = null == res || res.isEmpty
        ? []
        : res.map((c) => Person.fromJson(c)).toList();

    return list;
  }
  ```

### Step 6: U in CRUD - Update an entry from the database.
   1. Create a function to update an entry in the database. Lets call this **updateContact()**.
   2. This function takes an entry object as argument. in our case the Person object.
   3. Inside this function call ***db.update()*** method to update the object in the database.
   4. The *update* method just like *insert*, we need to give 2 positinal parameters, the table name and the entry object in its json form (in that order) but in addition to that we need to also give values to *where* and *whereArgs* while updating.
   5. If where is not given a value, the app will through the 'UNIQUE constraint failed' exception
   6. If  whereArgs is not given a value, the whole row will be updated with null value.
   7. Just like the *insert* method, the *update* method also returns an id. 
   8. In this case it is the id of the updated entry.

  ```
  /// Update a contact to the database
  updateContact(Person contact) async {
    final db = await database;

    await db?.update(
      "Contacts", //table name
      contact.toJson(), // updated contact
      where: "id = ?",
      whereArgs: [contact.id],
    );
  }
  ```

### Step 7: D in CRUD - Delete an entry from the database. [deleteEntry function]
   1. Create a function to delete an entry in the database. Lets call this **deleteContact()**.
   2. This function takes an id as argument. in our case the id of the Person object we want to delete.
   3. Inside this function call ***db.delete()*** method to delete the object from the database.
   4. The *delete* method accepts 1 positinal parameters, the table name, but just like the *update* method it accepts *where* and *whereArgs* as named parameters.
   5. Just like the *insert* and *update* methods, the *delete* method returns the id on an entry that was just deleted.

  ```
  /// Delete a contact from the database
  deleteContact(int id) async {
    final db = await database;

    await db?.delete(
      "Contacts",
      where: "id = ?",
      whereArgs: [id],
    );
  }
  ```

## Part 3 - Usage
  Finally fix the view class to use DBPHelper and there we have it, our very own flutter app with SQLite itegration.
  
```
  
  class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final allContactsNotifier = ValueNotifier(<Person>[]);

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sqflite Demo - Contacts'),
        ),
        body: ValueListenableBuilder(
            valueListenable: allContactsNotifier,
            builder: (context, snapshot, _) => true == snapshot.isEmpty
                ? const Center(child: Text('No Contacts!!'))
                : ListView.separated(
                    itemCount: snapshot.length,
                    itemBuilder: (context, i) => ListTile(
                      onTap: () => showContactDialogue(snapshot[i]),
                      onLongPress: () => updateContactDialogue(snapshot[i]),
                      leading: Text('${snapshot[i].id}.'),
                      title: Text('${snapshot[i].name}'),
                      subtitle: Text('${snapshot[i].city}'),
                      trailing: IconButton(
                        onPressed: () => deleteContact(snapshot[i].id),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    separatorBuilder: (context, i) => const Divider(),
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: addContactDialogue,
          tooltip: 'Add contact',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> addContact() async {
    final name = nameController.text.trim();
    final city = cityController.text.trim();

    final lastPersonId = allContactsNotifier.value.isEmpty
        ? 0
        : allContactsNotifier.value.last.id;

    final newContact = Person(
      id: lastPersonId + 1,
      name: name,
      city: city,
    );

    await DBHelper.db.addNewContact(newContact);
    nameController.clear();
    cityController.clear();

    getContacts();
    Navigator.pop(context);
  }

  Future<void> getContacts() async {
    allContactsNotifier.value = await DBHelper.db.getAllContacts();
  }

  Future<void> updateContact(Person contact) async {
    final name = nameController.text.trim();
    final city = cityController.text.trim();

    final updatedContact = contact.copyWith(
      name: name,
      city: city,
    );

    await DBHelper.db.updateContact(updatedContact);
    getContacts();

    nameController.clear();
    cityController.clear();
    Navigator.pop(context);
  }

  Future<void> deleteContact(int id) async {
    await DBHelper.db.deleteContact(id);
    getContacts();
  }

  void addContactDialogue() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController),
              TextField(controller: cityController),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: addContact,
              child: const Text('OK'),
            )
          ],
        ),
      );

  void showContactDialogue(Person contact) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Show details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name ?? ''),
              Text(contact.city ?? ''),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  void updateContactDialogue(Person contact) {
    nameController.text = contact.name ?? '';
    cityController.text = contact.city ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            TextField(controller: cityController),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => updateContact(contact),
          ),
        ],
      ),
    );
  }
}
```

