import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'task_consultation.dart';

class ToDoList {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool completed;
  int priority;
  String category;

  ToDoList({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
    required this.priority,
    required this.category,
  });
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks_db');

  int _selectedPriority = 3;
  String _selectedCategory = 'etude';

  void _editToDoList(BuildContext context, ToDoList todo) {
    final TextEditingController _titleController =
    TextEditingController(text: todo.title);
    final TextEditingController _descriptionController =
    TextEditingController(text: todo.description);

    Color _getTaskColor(String category) {
      switch (category) {
        case 'travail':
          return Colors.deepPurpleAccent;
        case 'etude':
          return Colors.deepPurple.shade200;
        case 'courses':
          return Colors.deepPurple.shade100;
        default:
          return Colors.deepPurple.shade50;
      }
    }

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
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Due Date:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText:
                        '${todo.dueDate.day}/${todo.dueDate.month}/${todo.dueDate.year}',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: todo.dueDate,
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            todo.dueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
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
                  tasksCollection.doc(todo.id).update({
                    'title': title,
                    'description': description,
                    'dueDate': todo.dueDate,
                  }).then((value) {
                    print('Tâche mise à jour avec succès!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Erreur lors de la mise à jour de la tâche: $error');
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _showAddToDoListForm(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
    TextEditingController();
    DateTime _dueDate = DateTime.now();

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
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Due Date:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText:
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: [
                  DropdownMenuItem<String>(
                    value: 'etude',
                    child: Text('Etude'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'travail',
                    child: Text('Travail'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'courses',
                    child: Text('Courses'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedPriority,
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Priorité Très Haute'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('Priorité Haute'),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text('Priorité Normale'),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text('Priorité Basse'),
                  ),
                  DropdownMenuItem<int>(
                    value: 5,
                    child: Text('Priorité Très Basse'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Priorité'),
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
                  tasksCollection.add({
                    'title': title,
                    'description': description,
                    'dueDate': _dueDate,
                    'completed': false,
                    'priority': _selectedPriority,
                    'category': _selectedCategory,
                  }).then((value) {
                    print('Tâche ajoutée avec succès!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Erreur lors de l\'ajout de la tâche: $error');
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _deleteToDoList(String taskId) {
    tasksCollection.doc(taskId).delete().then((value) {
      print('Tâche supprimée avec succès!');
    }).catchError((error) {
      print('Erreur lors de la suppression de la tâche: $error');
    });
  }

  void _toggleCompleted(String taskId, bool currentStatus, ToDoList todo) {
    // Inverse le statut "complété" de la tâche dans la collection Firestore
    tasksCollection.doc(taskId).update({'completed': !currentStatus}).then((_) {
      print('Statut de la tâche mis à jour avec succès!');
      // Met à jour l'état local
      setState(() {
        todo.completed = !currentStatus;
      });
    }).catchError((error) {
      print('Erreur lors de la mise à jour du statut de la tâche: $error');
    });
  }

  String _getStatusText(bool completed) {
    return completed ? 'Complété' : 'En cours';
  }

  Color _getStatusColor(bool completed) {
    return completed ? Colors.green : Colors.orange;
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trier par'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _sortTasksBy('dueDate');
                  Navigator.pop(context);
                },
                child: Text('Date de fin'),
              ),
              ElevatedButton(
                onPressed: () {
                  _sortTasksBy('priority');
                  Navigator.pop(context);
                },
                child: Text('Priorité'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortTasksBy(String sortBy) {
    setState(() {
      if (sortBy == 'dueDate') {
        tasksCollection.orderBy('dueDate');
      } else {
        tasksCollection.orderBy('priority');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listes des taches '),
        centerTitle: true,
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fleur.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showSortOptions(context);
              },
              child: Text('Trier par'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tasksCollection.orderBy('dueDate').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      dueDate: (data['dueDate'] as Timestamp).toDate(),
                      completed: data['completed'] ?? false,
                      priority: data['priority'] ?? 3,
                      category: data['category'] ?? 'etude',
                    );
                  })
                      .where((element) => element != null)
                      .toList()
                      .cast<ToDoList>();

                  return ListView.builder(
                    itemCount: todoList.length * 2,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return Divider(
                          color: Colors.white,
                          thickness: 0.7,
                          indent: 20,
                          endIndent: 20,
                        );
                      }

                      final todoIndex = index ~/ 2;
                      ToDoList todo = todoList[todoIndex];
                      return Dismissible(
                        key: Key(todo.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            _deleteToDoList(todo.id);
                          }
                        },
                        child: Container(
                          color: Colors.grey[300],
                          child: ListTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: todo.completed ? Colors.grey : Colors.black,
                                decoration: todo.completed ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Due Date: ${todo.dueDate.day}/${todo.dueDate.month}/${todo.dueDate.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            trailing: Checkbox(
                              value: todo.completed,
                              onChanged: (value) {
                                _toggleCompleted(todo.id, todo.completed, todo);
                              },
                              activeColor: _getStatusColor(todo.completed),
                            ),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getPriorityColor(todo.priority),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    _editToDoList(context, todo);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsPage(
                                    title: todo.title,
                                    description: todo.description,
                                    dueDate: todo.dueDate,
                                    category: todo.category,
                                    priority: todo.priority,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showAddToDoListForm(context);
              },
              backgroundColor: Colors.pink,
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
