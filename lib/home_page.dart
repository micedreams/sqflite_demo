import 'package:flutter/material.dart';

import 'data/person.dart';
import 'database_helper.dart';

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
