import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoList {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;

  ToDoList({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks_db');

  void _showAddToDoListForm(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une tâche'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Ajoute une nouvelle tâche à la collection Firestore
                  tasksCollection
                      .add({
                    'title': title,
                    'description': description,
                    'date': DateTime.now(),
                  })
                      .then((value) {
                    print('Tâche ajoutée avec succès!');
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    print('Erreur lors de l\'ajout de la tâche: $error');
                  });
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Écoute les modifications de la collection Firestore
        stream: tasksCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Convertit les documents Firestore en une liste de tâches
          List<ToDoList> todoList = snapshot.data!.docs
              .map((DocumentSnapshot document) {
            Map<String, dynamic>? data =
            document.data() as Map<String, dynamic>?;

            if (data == null) {
              return null;
            }

            return ToDoList(
              id: document.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              date: data['date']?.toDate() ?? DateTime.now(),
              time: data['date'] != null
                  ? TimeOfDay.fromDateTime(data['date']!.toDate())
                  : TimeOfDay.now(),
            );
          })
              .where((element) => element != null)
              .toList()
              .cast<ToDoList>();

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              ToDoList todo = todoList[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                // ...
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddToDoListForm(context);
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }
}