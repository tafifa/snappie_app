import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../modules/explore/controllers/explore_controller.dart';

class CreateReviewDialog extends StatefulWidget {
  final int placeId;
  
  const CreateReviewDialog({
    super.key,
    required this.placeId,
  });

  @override
  State<CreateReviewDialog> createState() => _CreateReviewDialogState();
}

class _CreateReviewDialogState extends State<CreateReviewDialog> {
  final _contentController = TextEditingController();
  int _rating = 5;
  
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating
          Row(
            children: [
              const Text('Rating: '),
              ...List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Review Content',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              final controller = Get.find<ExploreController>();
              controller.createReview(
                placeId: widget.placeId,
                vote: _rating,
                content: _contentController.text,
              );
              Get.back();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
