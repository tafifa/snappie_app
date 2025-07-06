import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.errorMessage}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentUserSection(),
                const SizedBox(height: 24),
                _buildUsersSection(),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildCurrentUserSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current User',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.currentUser != null) ...[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: controller.currentUser!.avatar != null
                      ? NetworkImage(controller.currentUser!.avatar!)
                      : null,
                  child: controller.currentUser!.avatar == null
                      ? Text(controller.currentUser!.name[0].toUpperCase())
                      : null,
                ),
                title: Text(controller.currentUser!.name),
                subtitle: Text(controller.currentUser!.email),
                trailing: Icon(
                  controller.currentUser!.isActive
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: controller.currentUser!.isActive
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ] else ...[
              const Text('No user data available'),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildUsersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.users.isNotEmpty) ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.users.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatar != null
                          ? NetworkImage(user.avatar!)
                          : null,
                      child: user.avatar == null
                          ? Text(user.name[0].toUpperCase())
                          : null,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Icon(
                      user.isActive ? Icons.check_circle : Icons.cancel,
                      color: user.isActive ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ] else ...[
              const Text('No users available'),
            ],
          ],
        ),
      ),
    );
  }
}
