import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
import '../task/add_edit_task_screen.dart';
import '../task/task_details_screen.dart';
import '../auth/login_screen.dart';
import '../../core/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: AppTheme.cardColor,
        onRefresh: () => context.read<TaskProvider>().fetchTasks(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              floating: true,
              pinned: true,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                title: const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1A1A), Colors.black],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                  onPressed: () {
                    context.read<AuthProvider>().logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Text(
                  'Your daily productivity\nstarts here',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterHeaderDelegate(),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 16)),
            Consumer<TaskProvider>(
              builder: (context, taskProvider, _) {
                if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Colors.white)),
                  );
                }
                final tasks = taskProvider.filteredTasks;
                if (tasks.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome_outlined, size: 64, color: Colors.white10),
                          SizedBox(height: 16),
                          Text(
                            'All caught up!',
                            style: TextStyle(color: Colors.white24, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TaskCard(
                          key: ValueKey(tasks[index].id),
                          task: tasks[index],
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => TaskDetailsScreen(task: tasks[index]),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: tasks.length,
                    ),
                  ),
                );
              },
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        label: const Text('Add Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded, color: Colors.black),
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            return Row(
              children: ['All', 'Pending', 'In Progress', 'Completed'].map((status) {
                final isSelected = provider.statusFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (_) => provider.setStatusFilter(status),
                    backgroundColor: AppTheme.cardColor,
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    showCheckmark: false,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
