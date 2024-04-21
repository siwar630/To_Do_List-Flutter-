import 'package:flutter/material.dart';

class ToDoList {
  String title;
  String description;
  DateTime date;
  TimeOfDay time;

  ToDoList({
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
  List<ToDoList> todoList = [
    ToDoList(
      title: 'Task 1',
      description: 'Description 1',
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
    ToDoList(
      title: 'Task 2',
      description: 'Description 2',
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
    ToDoList(
      title: 'Task 3',
      description: 'Description 3',
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          ToDoList todo = todoList[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  todo.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${todo.date.day}/${todo.date.month}/${todo.date.year} ${todo.time.hour}:${todo.time.minute}',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showEditToDoListForm(context, todo);
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      label: Text('Modifier'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _deleteToDoList(todo);
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                      ),
                      label: Text('Supprimer'),
                    ),
                  ],
                ),
              ],
            ),
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

  void _showAddToDoListForm(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
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
                  setState(() {
                    todoList.add(
                      ToDoList(
                        title: title,
                        description: description,
                        date: DateTime.now(),
                        time: TimeOfDay.now(),
                      ),
                    );
                  });

                  Navigator.pop(context);
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
    final TextEditingController _titleController = TextEditingController(text: todo.title);
    final TextEditingController _descriptionController = TextEditingController(text: todo.description);

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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
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
                  setState(() {
                    todo.title = title;
                    todo.description = description;
                  });

                  Navigator.pop(context);
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _deleteToDoList(ToDoList todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la tâche'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todoList.remove(todo);
                });

                Navigator.pop(context);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}