import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String _statusFilter = 'All';

  String get statusFilter => _statusFilter;
  String get searchQuery => _searchQuery;

  // Cache filtered results to avoid recalculating on every build
  List<TaskModel>? _cachedFilteredTasks;

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _cachedFilteredTasks = null;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    if (_statusFilter == filter) return;
    _statusFilter = filter;
    _cachedFilteredTasks = null;
    notifyListeners();
  }

  List<TaskModel> get filteredTasks {
    if (_cachedFilteredTasks != null) return _cachedFilteredTasks!;
    
    _cachedFilteredTasks = _tasks.where((task) {
      final matchesSearch = _searchQuery.isEmpty || 
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStatus = _statusFilter == 'All' || task.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
    
    return _cachedFilteredTasks!;
  }

  Future<void> fetchTasks() async {
    if (_isLoading) return; // Prevent double fetching
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getTasks();
      final List data = response.data;
      _tasks = data.map((json) => TaskModel.fromJson(json)).toList();
      _cachedFilteredTasks = null;
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(TaskModel task) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final optimisticTask = TaskModel(
      id: tempId,
      title: task.title,
      description: task.description,
      priority: task.priority,
      dueDate: task.dueDate,
      status: task.status,
      userId: 0,
    );
    _tasks.insert(0, optimisticTask);
    _cachedFilteredTasks = null;
    notifyListeners();

    try {
      final response = await _apiService.createTask(task.toJson());
      final realTask = TaskModel.fromJson(response.data);
      final index = _tasks.indexWhere((t) => t.id == tempId);
      if (index != -1) _tasks[index] = realTask;
      _cachedFilteredTasks = null;
      notifyListeners();
      return true;
    } catch (e) {
      _tasks.removeWhere((t) => t.id == tempId);
      _cachedFilteredTasks = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return false;
    
    final oldTask = _tasks[index];
    _tasks[index] = task;
    _cachedFilteredTasks = null;
    notifyListeners();

    try {
      await _apiService.updateTask(task.id, task.toJson());
      return true;
    } catch (e) {
      _tasks[index] = oldTask;
      _cachedFilteredTasks = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleTaskStatus(int taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final oldTask = _tasks[index];
    final newStatus = oldTask.status == 'Completed' ? 'Pending' : 'Completed';
    
    final newTask = TaskModel(
      id: oldTask.id,
      title: oldTask.title,
      description: oldTask.description,
      priority: oldTask.priority,
      dueDate: oldTask.dueDate,
      status: newStatus,
      userId: oldTask.userId,
    );

    _tasks[index] = newTask;
    _cachedFilteredTasks = null;
    notifyListeners();

    try {
      await _apiService.updateTask(taskId, {'status': newStatus});
    } catch (e) {
      _tasks[index] = oldTask;
      _cachedFilteredTasks = null;
      notifyListeners();
    }
  }

  Future<bool> deleteTask(int taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final deletedTask = _tasks[index];
    _tasks.removeAt(index);
    _cachedFilteredTasks = null;
    notifyListeners();

    try {
      await _apiService.deleteTask(taskId);
      return true;
    } catch (e) {
      _tasks.insert(index, deletedTask);
      _cachedFilteredTasks = null;
      notifyListeners();
      return false;
    }
  }
}
