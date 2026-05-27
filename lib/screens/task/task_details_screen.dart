import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import 'add_edit_task_screen.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = const Color(0xFFFF5252);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFFFD740);
        break;
      case 'Low':
        priorityColor = const Color(0xFF69F0AE);
        break;
      default:
        priorityColor = Colors.blueAccent;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      priorityColor.withValues(alpha: 0.2),
                      Colors.black,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: priorityColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      task.priority,
                      style: TextStyle(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white70, size: 28),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFFF5252), size: 28),
                onPressed: () => _showDeleteDialog(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),
                  _buildDetailRow(context, Icons.calendar_today_rounded, "Due Date", 
                      task.dueDate != null ? DateFormat('MMMM dd, yyyy').format(task.dueDate!) : 'Not set'),
                  const SizedBox(height: 20),
                  _buildDetailRow(context, Icons.donut_large_rounded, "Status", task.status),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Divider(color: Colors.white12, thickness: 1),
                  ),
                  Text(
                    "Notes",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    task.description != null && task.description!.isNotEmpty 
                        ? task.description! 
                        : "No notes added for this task.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white38, size: 20),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Delete Task', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: Colors.white,
              minimumSize: const Size(100, 45),
            ),
            onPressed: () async {
              final success = await context.read<TaskProvider>().deleteTask(task.id);
              if (success && context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
