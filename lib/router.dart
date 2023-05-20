import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//Pages
import './features/auth/pages/login_page.dart';
import './features/home/pages/home_page.dart';
import './features/community/pages/create_community_page.dart';
import './features/community/pages/community_page.dart';
import './features/community/pages/mod_tools_page.dart';
import './features/community/pages/edit_community_page.dart';

// loggedIn Routes
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityPage()),
  '/r/:name': (route) => MaterialPage(
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
});

// loggedOut Routes
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
});
