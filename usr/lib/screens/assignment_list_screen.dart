import 'package:flutter/material.dart';
import '../models/assignment.dart';
import 'add_assignment_screen.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final List<Assignment> _assignments = [];

  void _addAssignment(Assignment assignment) {
    setState(() {
      _assignments.add(assignment);
      // Sort by due date
      _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      _assignments[index].isCompleted = !_assignments[index].isCompleted;
    });
  }

  void _deleteAssignment(int index) {
    setState(() {
      _assignments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assignments'),
        centerTitle: true,
      ),
      body: _assignments.isEmpty
          ? const Center(
              child: Text(
                'No assignments yet!\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _assignments.length,
              itemBuilder: (context, index) {
                final assignment = _assignments[index];
                return Dismissible(
                  key: Key(assignment.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteAssignment(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: assignment.isCompleted,
                        onChanged: (_) => _toggleCompletion(index),
                      ),
                      title: Text(
                        assignment.title,
                        style: TextStyle(
                          decoration: assignment.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: assignment.isCompleted ? Colors.grey : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assignment.subject),
                          Text(
                            'Due: ${_formatDate(assignment.dueDate)}',
                            style: TextStyle(
                              color: _isOverdue(assignment.dueDate) && !assignment.isCompleted
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAssignment = await Navigator.push<Assignment>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAssignmentScreen(),
            ),
          );

          if (newAssignment != null) {
            _addAssignment(newAssignment);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    return dueDate.isBefore(today);
  }
}
