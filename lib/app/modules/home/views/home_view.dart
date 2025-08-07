import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar with User Greeting
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              backgroundColor: Colors.blue,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Hello, Marissa Ana!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[400]!,
                        Colors.blue[600]!,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => _showNotifications(),
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Post Creation Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tuliskan sesuatu...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Posts Timeline
            Obx(() {
              if (controller.isLoading && controller.posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = controller.posts[index];
                    return _buildPostCard(post);
                  },
                  childCount: controller.posts.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(PostEntity post) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    post.username[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Ikuti',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        post.placeName,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(post.createdAt),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
          
          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Post Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Post Tags
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: post.tags.map((tag) {
                  return Text(
                    tag,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Post Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Obx(() {
                  final isLiked = controller.posts
                      .firstWhere((p) => p.id == post.id)
                      .isLiked;
                  return GestureDetector(
                    onTap: () => controller.toggleLike(post.id),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.posts.firstWhere((p) => p.id == post.id).likes}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.share_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Bagikan',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _showNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNotificationItem(
              'Check-in Approved',
              'Your check-in at Cafe Mocha has been approved!',
              Icons.check_circle,
              Colors.green,
            ),
            _buildNotificationItem(
              'New Review',
              'Someone reviewed a place you checked in',
              Icons.rate_review,
              Colors.blue,
            ),
            _buildNotificationItem(
              'Achievement Unlocked',
              'You earned the "Explorer" badge!',
              Icons.emoji_events,
              Colors.amber,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      dense: true,
    );
  }
}
