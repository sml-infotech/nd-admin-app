import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_kn.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/list_blogs/blog_details_screen.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/list_blogs/list_blogs.dart';
import 'package:nammadaiva_dashboard/Screens/bookings/booking_screen.dart';
import 'package:nammadaiva_dashboard/Screens/contact_us/contact_us_screen.dart';
import 'package:nammadaiva_dashboard/Screens/create_event/create_event.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_userscreen.dart';
import 'package:nammadaiva_dashboard/Screens/dashboard/dashboard_screen.dart';
import 'package:nammadaiva_dashboard/Screens/event_list_screen/event_list_screen.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/create_festival.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/festival_list.dart';
import 'package:nammadaiva_dashboard/Screens/festivals/festival_list_detail.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_password.dart';
import 'package:nammadaiva_dashboard/Screens/highlight_upload_screen/add_highlight_kn.dart';
import 'package:nammadaiva_dashboard/Screens/highlight_upload_screen/highlight_screen.dart';
import 'package:nammadaiva_dashboard/Screens/login/login_screen.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/create_mantra.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/create_mantra_kn.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/mantra_list.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/create_master_temple.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/create_master_temple_kn.dart';
import 'package:nammadaiva_dashboard/Screens/master_temple/master_temple_list.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/puja_list.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_kn.dart';
import 'package:nammadaiva_dashboard/Screens/pujabook/puja_booking_screen.dart';
import 'package:nammadaiva_dashboard/Screens/resetpassword/reset_password_screen.dart';
import 'package:nammadaiva_dashboard/Screens/temple/temple_listscreen.dart';
import 'package:nammadaiva_dashboard/Screens/temple_details/temple_details_screen.dart';
import 'package:nammadaiva_dashboard/Screens/update_requests/update_requests_screen.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_kn.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_screen.dart';
import 'package:nammadaiva_dashboard/Screens/userlist/user_listscreen.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/arguments/blogs_argument.dart';
import 'package:nammadaiva_dashboard/arguments/festival_argument.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:nammadaiva_dashboard/arguments/puja_arguments.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/arguments/update_mantra.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/event_list_modal/event_list_response.dart';
import 'package:provider/provider.dart';

import '../Screens/create_event/create_event_kn.dart';
import '../Screens/festivals/create_festival_kn.dart';

class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    switch (settings.name) {
      case StringsRoute.login:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(),
        );
      case StringsRoute.otpScreen:
        OtpArguments args = settings.arguments as OtpArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OtpScreen(arguments: args),
        );
      case StringsRoute.dashboard:
        return MaterialPageRoute(
          builder: (context) =>
              Builder(builder: (localContext) => DashboardScreen()),
        );

      case StringsRoute.templeDetail:
        TempleDetailsArguments args =
            settings.arguments as TempleDetailsArguments;

        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleDetailsScreen(arguments: args),
        );

      case StringsRoute.createUser:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateUserScreen(),
        );
      case StringsRoute.forgotPassword:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ForgotPasswordScreen(),
        );
      case StringsRoute.resetPassword:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ResetPasswordScreen(),
        );

      case StringsRoute.userDetails:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserListScreen(),
        );
      case StringsRoute.templeScreen:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleScreen(),
        );
      case StringsRoute.addTempleScreen:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => AddTempleScreen(),
        );
      case StringsRoute.addPuja:
        PujaArguments args = settings.arguments as PujaArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PujaBookingScreen(pujaArgumrnts: args),
        );

      case StringsRoute.pujaList:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PujaList(),
        );
      case StringsRoute.updateRequestsUrl:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UpdateRequests(),
        );
      case StringsRoute.createEvent:
        EventItem? args = settings.arguments as EventItem?;

        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateEvent(event: args),
        );
      case StringsRoute.eventListScreen:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => EventListScreen(),
        );
      case StringsRoute.updateTempleDetails:
        TempleDetailsArguments args =
            settings.arguments as TempleDetailsArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => TempleUpdateScreen(arguments: args),
        );
      case StringsRoute.bookings:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => BookingScreen(),
        );
      case StringsRoute.contactUs:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ContactScreen(),
        );
      case StringsRoute.create_master_temple:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateMasterTemple(),
        );
      case StringsRoute.master_temple_list:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MasterTempleList(),
        );
      case StringsRoute.mantraList:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MantraList(),
        );
      case StringsRoute.createMantra:
        UpdateMantraArguments args =
            settings.arguments as UpdateMantraArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateMantraScreen(updateMantra: args),
        );
      case StringsRoute.highlightUpload:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => HighLightsUploaderScreen(),
        );
      case StringsRoute.festivalList:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => FestivalListScreen(),
        );

      case StringsRoute.createFestival:
        FestivalArgument? args = settings.arguments as FestivalArgument?;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateFestival(arguments: args),
        );
      case StringsRoute.festivalDetailsScreen:
        FestivalArgument args = settings.arguments as FestivalArgument;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => FestivalDetailsScreen(arguments: args),
        );
      case StringsRoute.addTempleScreeninKannadam:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => AddTempleScreenInKannadam(),
        );
      case StringsRoute.updateTempleKn:
        TempleDetailsArguments args =
            settings.arguments as TempleDetailsArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UpdateTempleKn(arguments: args),
        );
      case StringsRoute.addPujaInkn:
        PujaArguments args = settings.arguments as PujaArguments;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PujaBookingKn(pujaArgumrnts: args),
        );
      case StringsRoute.createMantrainKn:
        UpdateMantraArguments args =
            settings.arguments as UpdateMantraArguments;
      case StringsRoute.createEventInKn:
        final EventItem? args = settings.arguments as EventItem?;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateEventKn(event: args),
        );
      case StringsRoute.createFestivalKn:
        final FestivalArgument? args = settings.arguments as FestivalArgument?;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateFestivalKn(arguments: args),
        );

        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateMantraInKannadam(updateMantra: args),
        );
      case StringsRoute.highlightUploadinKn:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => AddHighlightInKannadam(),
        );

      case StringsRoute.create_master_temple_in_kn:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateMasterTempleKn(),
        );

      case StringsRoute.create_blog:
        BlogDetails? args = settings.arguments as BlogDetails?;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreateBlogScreen( blogs: args,),
        );

      case StringsRoute.blog_list:
        return CupertinoPageRoute(builder: (_) => ListBlogs());

      case StringsRoute.blog_details:
        BlogsArgument args = settings.arguments as BlogsArgument;
        return CupertinoPageRoute(
          builder: (_) => BlogDetailsScreen(slug_name: args),
        );
      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}
