import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Classe modèle pour une tâche
class ToDoList {
  String id; // Identifiant de la tâche
  String title; // Titre de la tâche
  String description; // Description de la tâche
  DateTime date; // Date de la tâche
  TimeOfDay time; // Heure de la tâche
  String category; // Catégorie de la tâche
  bool isDone; // Indique si la tâche est terminée

  // Constructeur de la classe ToDoList
  ToDoList({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.isDone,
  });
}

// Classe de l'écran de la liste des tâches
class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

// État de l'écran de la liste des tâches
class _ToDoListScreenState extends State<ToDoListScreen> {
  final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks_db');

  // Contrôleurs de texte et variables de sélection pour le formulaire
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = 'Work';

  // Méthode pour obtenir la couleur de la tâche en fonction de sa catégorie
  Color _getTaskColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.deepPurpleAccent;
      case 'Personal':
        return Colors.deepPurple.shade200;
      case 'Shopping':
        return Colors.deepPurple.shade100;
      default:
        return Colors.deepPurple.shade50;
    }
  }

  // Méthode pour sélectionner la date de la tâche
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Méthode pour sélectionner l'heure de la tâche
  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Méthode pour afficher le formulaire d'ajout de tâche
  void _showAddToDoListForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une tâche'),
          content: SingleChildScrollView(
            child: Column(
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
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  items: ['Work', 'Personal', 'Shopping'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                GestureDetector(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Add space between date and description
                GestureDetector(
                  onTap: _selectTime,
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text(
                        'Heure: ${_selectedTime.hour}:${_selectedTime.minute}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  DateTime selectedDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );

                  tasksCollection.add({
                    'title': title,
                    'description': description,
                    'date': selectedDateTime,
                    'category': _selectedCategory,
                  }).then((value) {
                    print('Tâche ajoutée avec succès!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Erreur lors de l\'ajout de la tâche: $error');
                  });
                }
              },
              child: Text('Ajouter'), // Texte du bouton
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher le formulaire de modification de tâche
  void _showEditToDoListForm(BuildContext context, ToDoList todo) {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _selectedCategory = todo.category;
    _selectedDate = todo.date;
    _selectedTime = todo.time;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la tâche'),
          content: SingleChildScrollView(
            child: Column(
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
                GestureDetector(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Add space between date and description
                GestureDetector(
                  onTap: _selectTime,
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text(
                        'Heure: ${_selectedTime.hour}:${_selectedTime.minute}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  DateTime selectedDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );

                  tasksCollection.doc(todo.id).update({
                    'title': title,
                    'description': description,
                    'date': selectedDateTime,
                    'category': _selectedCategory,
                  }).then((value) {
                    print('Tâche modifiée avec succès!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Erreur lors de la modification de la tâche: $error');
                  });
                }
              },
              child: Text('Modifier'), // Texte du bouton
            ),
          ],
        );
      },
    );
  }

  // Méthode pour supprimer une tâche
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
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fleur.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
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
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

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
                category: data['category'] ?? '',
                isDone: false, // Provide a value for isDone
              );
            })
                .where((element) => element != null)
                .toList()
                .cast<ToDoList>();

            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                ToDoList todo = todoList[index];
                Color taskColor = _getTaskColor(todo.category); // Get color based on category
                return Card(
                  color: taskColor,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.title),
                        SizedBox(height: 5),
                        Text('${todo.description}'),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 5),
                            Text(
                              '${todo.date.day}/${todo.date.month}/${todo.date.year}',
                            ),
                            SizedBox(width: 20),
                            Icon(Icons.access_time),
                            SizedBox(width: 5),
                            Text('${todo.time.hour}:${todo.time.minute}'),
                          ],
                        ),
                      ],
                    ),
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
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(), // Placeholder widget to maintain spacing
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showAddToDoListForm(context);
              },
              backgroundColor: Colors.pink,
            ),
            SizedBox(), // Placeholder widget to maintain spacing
          ],
        ),
      ),
    );
  }
}
