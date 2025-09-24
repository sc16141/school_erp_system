import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/mainNotification.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // Sample notification data
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Assignment Due Tomorrow',
      message: 'Mathematics homework is due tomorrow at 11:59 PM',
      time: '2 hours ago',
      icon: Icons.assignment,
      isRead: false,
    ),
    NotificationItem(
      title: 'Parent-Teacher Meeting',
      message: 'Scheduled for March 15th at 3:00 PM in classroom 101',
      time: '1 day ago',
      icon: Icons.event,
      isRead: true,
    ),
    NotificationItem(
      title: 'School Holiday Notice',
      message: 'School will be closed on March 20th for maintenance',
      time: '3 days ago',
      icon: Icons.info,
      isRead: true,
    ),
    NotificationItem(
      title: 'Exam Schedule Released',
      message: 'Final examination timetable has been published on the student portal',
      time: '5 days ago',
      icon: Icons.schedule,
      isRead: false,
    ),
    NotificationItem(
      title: 'Library Book Return',
      message: 'Please return your borrowed books by March 25th to avoid late fees',
      time: '1 week ago',
      icon: Icons.library_books,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context),

            // Notifications List
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState(context)
                  : _buildNotificationsList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
      ),
      child: Row(
        children: [
          // Notification Icon
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getInputBorderRadius(context),
              ),
            ),
            child: Icon(
              Icons.notifications,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),

          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

          // Title
          Expanded(
            child: Text(
              'Notifications',
              style: AppThemeResponsiveness.getSectionTitleStyle(context),
            ),
          ),

          // Mark all as read button
          Container(
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in notifications) {
                    notification.isRead = true;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All notifications marked as read'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppThemeColor.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
              ),
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: AppThemeColor.white,
                  fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
          vertical: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(context, notifications[index], index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Card(
        elevation: notification.isRead
            ? AppThemeResponsiveness.getCardElevation(context) * 0.5
            : AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
          },
          child: Container(
            padding: AppThemeResponsiveness.getCardPadding(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getCardBorderRadius(context),
              ),
              color: notification.isRead
                  ? Colors.white
                  : AppThemeColor.blue50,
              border: notification.isRead
                  ? null
                  : Border.all(
                color: AppThemeColor.blue200,
                width: AppThemeResponsiveness.getFocusedBorderWidth(context) * 0.5,
              ),
            ),
            child: _buildNotificationContent(context, notification, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context, NotificationItem notification, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon Container
        Container(
          padding: EdgeInsets.all(
            AppThemeResponsiveness.getActivityIconPadding(context),
          ),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppThemeColor.greyl
                : AppThemeColor.blue100,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
          ),
          child: Icon(
            notification.icon,
            color: notification.isRead
                ? Colors.grey.shade600
                : AppThemeColor.primaryBlue600,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),

        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

        // Content Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row with Read Indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getHeadingStyle(context).fontSize,
                        fontWeight: notification.isRead
                            ? FontWeight.w600
                            : FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  if (!notification.isRead) ...[
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                    Container(
                      width: AppThemeResponsiveness.isSmallPhone(context) ? 6 : 8,
                      height: AppThemeResponsiveness.isSmallPhone(context) ? 6 : 8,
                      decoration: BoxDecoration(
                        color: AppThemeColor.primaryBlue600,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),

              // Message
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: AppThemeResponsiveness.isSmallPhone(context) ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

              // Time Chip
              Container(
                padding: AppThemeResponsiveness.getTimeChipPadding(context),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? AppThemeColor.greyl
                      : AppThemeColor.blue100,
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context) * 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: AppThemeResponsiveness.getTimeChipIconSize(context),
                      color: notification.isRead
                          ? Colors.grey.shade500
                          : AppThemeColor.primaryBlue600,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                        color: notification.isRead
                            ? Colors.grey.shade500
                            : AppThemeColor.primaryBlue600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // More Options Menu
        _buildMoreOptionsMenu(context, notification, index),
      ],
    );
  }

  Widget _buildMoreOptionsMenu(BuildContext context, NotificationItem notification, int index) {
    return Container(
      margin: EdgeInsets.only(left: AppThemeResponsiveness.getSmallSpacing(context)),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context) * 0.6,
            ),
          ),
          child: Icon(
            Icons.more_vert,
            color: Colors.grey.shade600,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'mark_read',
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: Row(
              children: [
                Icon(
                  notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  notification.isRead ? 'Mark as unread' : 'Mark as read',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  color: Colors.red.shade600,
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'mark_read') {
            setState(() {
              notification.isRead = !notification.isRead;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  notification.isRead
                      ? 'Marked as read'
                      : 'Marked as unread',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (value == 'delete') {
            _showDeleteConfirmation(context, index);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Text(
            'Delete Notification',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: Text(
            'Are you sure you want to delete this notification?',
            style: AppThemeResponsiveness.getSubHeadingStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notifications.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notification deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.8,
        ),
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getExtraLargeSpacing(context),
              ),
              decoration: BoxDecoration(
                color: AppThemeColor.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off,
                size: AppThemeResponsiveness.getLogoSize(context) * 1.5,
                color: AppThemeColor.white.withOpacity(0.8),
              ),
            ),

            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

            Text(
              'No notifications yet',
              style: TextStyle(
                color: AppThemeColor.white,
                fontSize: AppThemeResponsiveness.getSectionTitleStyle(context).fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            Text(
              'You\'ll see notifications here when they arrive',
              style: TextStyle(
                color: AppThemeColor.white.withOpacity(0.8),
                fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

