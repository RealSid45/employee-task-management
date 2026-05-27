import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _priority;
  late String _status;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? 'Medium';
    _status = widget.task?.status ?? 'Pending';
    _dueDate = widget.task?.dueDate;
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      final task = TaskModel(
        id: widget.task?.id ?? 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        status: _status,
        dueDate: _dueDate,
        userId: widget.task?.userId ?? 0,
      );

      bool success;
      if (widget.task == null) {
        success = await taskProvider.addTask(task);
      } else {
        success = await taskProvider.updateTask(task);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFFF5252),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text('Failed to save task'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("General Info"),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _titleController,
                label: 'Task title',
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                label: 'Add notes...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle("Configuration"),
              const SizedBox(height: 16),
              _buildInfoTile(
                "Due date",
                _dueDate != null ? DateFormat('MMMM dd, yyyy').format(_dueDate!) : "Set deadline",
                Icons.calendar_today_rounded,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            surface: Color(0xFF1C1C1E),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) setState(() => _dueDate = date);
                },
              ),
              const SizedBox(height: 20),
              _buildPrioritySelector(),
              const SizedBox(height: 20),
              _buildStatusSelector(),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Task'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white54, size: 18),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: ['Pending', 'In Progress', 'Completed'].map((s) {
          final isSelected = _status == s;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _status = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    s,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white38,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: ['Low', 'Medium', 'High'].map((p) {
          final isSelected = _priority == p;
          Color pColor;
          if (p == 'High') {
            pColor = const Color(0xFFFF5252);
          } else if (p == 'Medium') {
            pColor = const Color(0xFFFFD740);
          } else {
            pColor = const Color(0xFF69F0AE);
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? pColor.withValues(alpha: 0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    p,
                    style: TextStyle(
                      color: isSelected ? pColor : Colors.white38,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
