import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/notification/notification_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listscreen.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationListViewmodel viewModel;
  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<NotificationListViewmodel>(context);
    return FocusDetector(
      onFocusGained: () async {
        await viewModel.fetchNotifications();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: _buildAppBar(),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          itemCount: viewModel.isInitialLoading
              ? 9
              : viewModel.notifications.isEmpty
              ? 1
              : viewModel.notifications.length,

          itemBuilder: (context, index) {
            if (viewModel.isInitialLoading) {
              return const ShimmerUserCard();
            }

            if (viewModel.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 280),
                  child: Text(
                    "No notifications available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: font,
                    ),
                  ),
                ),
              );
            }

            return notificationCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.notification,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget notificationCard(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xff008031), Color(0xff00B050)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            notificationListCard(index),
          ],
        ),
      ),
    );
  }

  Widget notificationIcon() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Color(0xffE6F4EC),
      child: Icon(Icons.notifications, color: Color(0xff008031)),
    );
  }

  Widget roundedBackground() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  Widget notificationListCard(int index) {
    return GestureDetector(
      onTap: () {
        if (!viewModel.notifications[index].isRead!) {
          viewModel.markAsRead(viewModel.notifications[index].id!);
        }
      },
      child: Expanded(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Stack(children: [notificationIcon(), roundedBackground()]),
          title: Text(
            viewModel.notifications[index].title ?? "Temple Update",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: font,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              viewModel.notifications[index].body ??
                  "Your booking has been confirmed successfully.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontFamily: font,
              ),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                viewModel.notifications[index].createdAt ?? "2h ago",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontFamily: font,
                ),
              ),
              const SizedBox(height: 6),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
