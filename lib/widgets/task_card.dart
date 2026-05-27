import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

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

    final isCompleted = task.status == 'Completed';

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.cardColor,
                    AppTheme.cardColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isCompleted 
                      ? Colors.white.withValues(alpha: 0.1) 
                      : priorityColor.withValues(alpha: 0.1), 
                  width: 1
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.read<TaskProvider>().toggleTaskStatus(task.id),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.greenAccent : Colors.transparent,
                            border: Border.all(
                              color: isCompleted ? Colors.greenAccent : Colors.white24,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: isCompleted 
                              ? const Icon(Icons.check, size: 16, color: Colors.black) 
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: priorityColor.withValues(alpha: 0.4), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        task.priority.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        isCompleted ? "DONE" : "IN PROGRESS",
                        style: TextStyle(
                          color: isCompleted ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.white24,
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? Colors.white38 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white24),
                      const SizedBox(width: 8),
                      Text(
                        task.dueDate != null ? DateFormat('EEE, MMM dd').format(task.dueDate!) : 'No deadline',
                        style: const TextStyle(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
