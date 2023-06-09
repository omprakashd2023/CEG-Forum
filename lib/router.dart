import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//Pages
import './features/auth/pages/auth_page.dart';
import './features/home/pages/home_page.dart';
import './features/community/pages/create_community_page.dart';
import './features/community/pages/community_page.dart';
import './features/community/pages/mod_tools_page.dart';
import './features/community/pages/edit_community_page.dart';
import './features/community/pages/add_moderator_page.dart';
import './features/user_profile/pages/user_profile_page.dart';
import './features/user_profile/pages/edit_profile_page.dart';
import './features/posts/pages/add_post_type.dart';
import './features/posts/pages/comment_page.dart';

// loggedIn Routes
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityPage()),
  '/ceg/:name': (route) => MaterialPage(
        child: CommunityPage(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (route) => MaterialPage(
        child: ModToolsPage(
          name: route.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (route) => MaterialPage(
        child: EditCommunityPage(
          name: route.pathParameters['name']!,
        ),
      ),
  '/add-moderator/:name': (route) => MaterialPage(
        child: AddModeratorPage(
          name: route.pathParameters['name']!,
        ),
      ),
  '/user/:uid': (route) => MaterialPage(
        child: UserProfilePage(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (route) => MaterialPage(
        child: EditProfilePage(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (route) => MaterialPage(
        child: AddPostTypePage(
          type: route.pathParameters['type']!,
        ),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentPage(
          postId: route.pathParameters['postId']!,
        ),
      ),
});

// loggedOut Routes
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: AuthPage()),
});
