import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/screen/login_screen.dart';
import 'package:reddit_tutorial/features/community/screens/create_community_screen.dart';
import 'package:reddit_tutorial/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/create-community': (_) => const MaterialPage(
          child: CreateCommunityScreen(),
        ),
  },
);
