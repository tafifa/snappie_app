import 'package:flutter/material.dart';
import '../../../domain/entities/checkin_entity.dart';

class CheckinCard extends StatelessWidget {
  final CheckinEntity checkin;
  final VoidCallback? onTap;

  const CheckinCard({
    Key? key,
    required this.checkin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with place name and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      checkin.place.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(_getCheckinStatusFromString(checkin.checkinStatus)),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Place address
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      checkin.place.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Mission status and rewards
              Row(
                children: [
                  // Mission status
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          _getMissionIcon(_getMissionStatusFromString(checkin.missionStatus)),
                          size: 16,
                          color: _getMissionColor(_getMissionStatusFromString(checkin.missionStatus)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getMissionText(_getMissionStatusFromString(checkin.missionStatus)),
                          style: TextStyle(
                            color: _getMissionColor(_getMissionStatusFromString(checkin.missionStatus)),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rewards (if approved)
                  if (_getCheckinStatusFromString(checkin.checkinStatus) == CheckinStatus.approved) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars,
                            size: 14,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${checkin.rewards.baseExp} XP',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.monetization_on,
                            size: 14,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${checkin.rewards.baseCoin}',
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Date and time
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(checkin.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CheckinStatus _getCheckinStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return CheckinStatus.approved;
      case 'pending':
        return CheckinStatus.pending;
      case 'rejected':
        return CheckinStatus.rejected;
      default:
        return CheckinStatus.pending;
    }
  }

  MissionStatus _getMissionStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return MissionStatus.completed;
      case 'pending':
        return MissionStatus.pending;
      case 'failed':
        return MissionStatus.failed;
      default:
        return MissionStatus.pending;
    }
  }

  Widget _buildStatusChip(CheckinStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case CheckinStatus.approved:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = 'Approved';
        icon = Icons.check_circle;
        break;
      case CheckinStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case CheckinStatus.rejected:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMissionIcon(MissionStatus status) {
    switch (status) {
      case MissionStatus.completed:
        return Icons.task_alt;
      case MissionStatus.pending:
        return Icons.hourglass_empty;
      case MissionStatus.failed:
        return Icons.error;
    }
  }

  Color _getMissionColor(MissionStatus status) {
    switch (status) {
      case MissionStatus.completed:
        return Colors.green[700]!;
      case MissionStatus.pending:
        return Colors.orange[700]!;
      case MissionStatus.failed:
        return Colors.red[700]!;
    }
  }

  String _getMissionText(MissionStatus status) {
    switch (status) {
      case MissionStatus.completed:
        return 'Mission Complete';
      case MissionStatus.pending:
        return 'Mission Pending';
      case MissionStatus.failed:
        return 'Mission Failed';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}