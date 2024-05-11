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

  void _showEditToDoListForm(BuildContext context, ToDoList todo) {
    final TextEditingController _titleController =
    TextEditingController(text: todo.title);
    final TextEditingController _descriptionController =
    TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la tâche'),
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
                  tasksCollection
                      .doc(todo.id)
                      .update({
                    'title': title,
                    'description': description,
                  })
                      .then((value) {
                    print('Tâche modifiée avec succès!');
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    print('Erreur lors de la modification de la tâche: $error');
                  });
                }
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _deleteToDoList(ToDoList todo) {
    tasksCollection
        .doc(todo.id)
        .delete()
        .then((value) => print('Tâche supprimée avec succès!'))
        .catchError((error) =>
        print('Erreur lors de la suppression de la tâche: $error'));
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
        stream: tasksCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

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
          }).where((element) => element != null).toList().cast<ToDoList>();

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              ToDoList todo = todoList[index];
              return Card(
                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditToDoListForm(context, todo);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteToDoList(todo);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
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