import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

final di = _MockDI();
class _MockDI { T call<T>() => throw UnimplementedError(); }

class FetchUserDataState extends Equatable {
  final Map<String, dynamic>? bannerData;
  final dynamic userEntity;
  final bool isOnline;
  final int unreadCount;
  final String? walletBalance;

  const FetchUserDataState({
    this.bannerData,
    this.userEntity,
    this.isOnline = false,
    this.unreadCount = 0,
    this.walletBalance,
  });

  @override
  List<Object?> get props =>
      [bannerData, userEntity, isOnline, unreadCount, walletBalance];
}

class FetchUserDataEvent {}
class FetchUserDataBloc extends Bloc<FetchUserDataEvent, FetchUserDataState> {
  FetchUserDataBloc() : super(const FetchUserDataState());
}

class LayoutState extends Equatable {
  final int currentIndex;
  final bool showBanner;
  const LayoutState({this.currentIndex = 0, this.showBanner = false});
  @override
  List<Object?> get props => [currentIndex, showBanner];
}

class LayoutEvent {}
class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(const LayoutState());
}

class HomeState extends Equatable {
  final int currentTabIndex;
  final List<dynamic> popularRooms;
  final List<dynamic> liveRooms;
  final List<dynamic> followRooms;
  final List<dynamic> friendsRooms;
  final List<dynamic> lastCreateRooms;
  final List<dynamic> filteredRooms;
  final List<dynamic> globalRooms;
  final int popularCurrentPage;
  final int liveCurrentPage;
  final int globalCurrentPage;
  final int followCurrentPage;
  final int friendsCurrentPage;

  const HomeState({
    this.currentTabIndex = 0,
    this.popularRooms = const [],
    this.liveRooms = const [],
    this.followRooms = const [],
    this.friendsRooms = const [],
    this.lastCreateRooms = const [],
    this.filteredRooms = const [],
    this.globalRooms = const [],
    this.popularCurrentPage = 1,
    this.liveCurrentPage = 1,
    this.globalCurrentPage = 1,
    this.followCurrentPage = 1,
    this.friendsCurrentPage = 1,
  });

  @override
  List<Object?> get props => [
        currentTabIndex, popularRooms, liveRooms, followRooms,
        friendsRooms, lastCreateRooms, filteredRooms, globalRooms,
        popularCurrentPage, liveCurrentPage, globalCurrentPage,
        followCurrentPage, friendsCurrentPage,
      ];
}

class HomeEvent {}
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState());
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class RoomPage extends StatelessWidget {
  const RoomPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});
  @override Widget build(BuildContext context) => const Placeholder();
}
class SplashBloc extends Bloc<dynamic, dynamic> { SplashBloc() : super(null); }
class ConfigAppBloc extends Bloc<dynamic, dynamic> { ConfigAppBloc() : super(null); }
class ColorsBloc extends Bloc<dynamic, dynamic> { ColorsBloc() : super(null); }
class LoginBloc extends Bloc<dynamic, dynamic> { LoginBloc() : super(null); }
class RegisterBloc extends Bloc<dynamic, dynamic> { RegisterBloc() : super(null); }
class SearchBloc extends Bloc<dynamic, dynamic> { SearchBloc() : super(null); }
class ReelsBloc extends Bloc<dynamic, dynamic> { ReelsBloc() : super(null); }
class ChatBloc extends Bloc<dynamic, dynamic> { ChatBloc() : super(null); }
class RoomBloc extends Bloc<dynamic, dynamic> { RoomBloc() : super(null); }
class ProfileBloc extends Bloc<dynamic, dynamic> { ProfileBloc() : super(null); }

class ShowSVGA extends StatelessWidget {
  final String svgaAssetPath;
  final bool isNeedToRepeat;
  final double height;
  final double width;

  const ShowSVGA({
    super.key,
    required this.svgaAssetPath,
    this.isNeedToRepeat = false,
    this.height = 35,
    this.width = 35,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width, child: const Placeholder());
  }
}

// ---------------------------------------------------------------------------
// AREA 1: Main Layout
// ---------------------------------------------------------------------------

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // issue: StreamBuilder at root — rebuilds everything on every tick
    return StreamBuilder<bool>(
      stream: Stream.periodic(const Duration(seconds: 30), (_) => true),
      builder: (context, snapshot) {
        return Stack(
          children: [
            // issue: BlocBuilder without buildWhen
            BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
              bloc: di<FetchUserDataBloc>(),
              builder: (_, state) {
                final data = state.bannerData?["gift"];
                if (data == null) return const SizedBox();
                return Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 80,
                    color: Colors.amber.withOpacity(0.9),
                    child: const Center(child: Text('Gift Banner')),
                  ),
                );
              },
            ),
            BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
              bloc: di<FetchUserDataBloc>(),
              builder: (_, state) {
                final data = state.bannerData?["game"];
                if (data == null) return const SizedBox();
                return Positioned(
                  top: 80, left: 0, right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.blue.withOpacity(0.9),
                    child: const Center(child: Text('Game Banner')),
                  ),
                );
              },
            ),
            BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
              bloc: di<FetchUserDataBloc>(),
              builder: (_, state) {
                final data = state.bannerData?["lucky"];
                if (data == null) return const SizedBox();
                return Positioned(
                  bottom: 100, left: 0, right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.green.withOpacity(0.9),
                    child: const Center(child: Text('Lucky Banner')),
                  ),
                );
              },
            ),
            BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
              bloc: di<FetchUserDataBloc>(),
              builder: (_, state) {
                if (!state.isOnline) return const SizedBox();
                return Positioned(
                  top: 10, right: 10,
                  child: Container(
                    width: 12, height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            // issue: no buildWhen — rebuilds IndexedStack on any LayoutState change
            BlocBuilder<LayoutBloc, LayoutState>(
              bloc: di<LayoutBloc>(),
              builder: (context, layoutState) {
                return IndexedStack(
                  index: layoutState.currentIndex,
                  children: [
                    _buildHomePage(),
                    const ChatPage(),
                    const ProfilePage(),
                    const SettingsPage(),
                  ],
                );
              },
            ),
            // issue: nested BlocBuilders, no buildWhen on either
            BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
              bloc: di<FetchUserDataBloc>(),
              builder: (_, userState) {
                return BlocBuilder<LayoutBloc, LayoutState>(
                  bloc: di<LayoutBloc>(),
                  builder: (_, layoutState) {
                    if (layoutState.currentIndex != 1) return const SizedBox();
                    return Positioned(
                      bottom: 70, right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${userState.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // issue: ValueNotifier created inside build — new instance on every rebuild
            ValueListenableBuilder<String>(
              valueListenable: ValueNotifier<String>('0'),
              builder: (_, value, __) {
                return Positioned(
                  top: 50, right: 10,
                  child: Text(value),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHomePage() {
    // issue: BlocBuilder wraps entire home page, no buildWhen
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: di<HomeBloc>(),
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: () {}, child: const Text('Popular')),
                TextButton(onPressed: () {}, child: const Text('Live')),
                TextButton(onPressed: () {}, child: const Text('Following')),
                TextButton(onPressed: () {}, child: const Text('Friends')),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: state.currentTabIndex,
                children: [
                  ListView.builder(
                    itemCount: state.popularRooms.length,
                    itemBuilder: (_, i) => ListTile(title: Text('Popular $i')),
                  ),
                  ListView.builder(
                    itemCount: state.liveRooms.length,
                    itemBuilder: (_, i) => ListTile(title: Text('Live $i')),
                  ),
                  ListView.builder(
                    itemCount: state.followRooms.length,
                    itemBuilder: (_, i) => ListTile(title: Text('Following $i')),
                  ),
                  ListView.builder(
                    itemCount: state.friendsRooms.length,
                    itemBuilder: (_, i) => ListTile(title: Text('Friends $i')),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// AREA 2: Bottom Navigation
// ---------------------------------------------------------------------------

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/home.png', height: 28, width: 28),
          // issue: all 4 SVGAs load at startup even though only 1 tab is active
          activeIcon: const ShowSVGA(
            svgaAssetPath: 'assets/svga/home_active.svga',
            isNeedToRepeat: false,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/chat.png', height: 28, width: 28),
          activeIcon: const ShowSVGA(
            svgaAssetPath: 'assets/svga/chat_active.svga',
            isNeedToRepeat: false,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/profile.png', height: 28, width: 28),
          activeIcon: const ShowSVGA(
            svgaAssetPath: 'assets/svga/profile_active.svga',
            isNeedToRepeat: false,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icons/settings.png', height: 28, width: 28),
          activeIcon: const ShowSVGA(
            svgaAssetPath: 'assets/svga/settings_active.svga',
            isNeedToRepeat: false,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AREA 3: Routes Map
// ---------------------------------------------------------------------------

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';

  // issue: static map holds all closures in memory from app start
  static Map<String, Widget Function(BuildContext)> routes = {
    splash: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: di<SplashBloc>()),
            BlocProvider.value(value: di<ConfigAppBloc>()),
            BlocProvider.value(value: di<ColorsBloc>()),
          ],
          child: const SplashPage(),
        ),
    login: (context) => BlocProvider.value(
          value: di<LoginBloc>(),
          child: const LoginPage(),
        ),
    home: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: di<HomeBloc>()),
            BlocProvider.value(value: di<FetchUserDataBloc>()),
          ],
          child: const HomePage(),
        ),
  };
}

// ---------------------------------------------------------------------------
// AREA 4: Misc Issues
// ---------------------------------------------------------------------------

class MiscIssues {
  static ValueNotifier<bool> isKeepInRoom = ValueNotifier<bool>(false);

  static void onExitRoom() {
    // issue: set to true then immediately false — listeners never see 'true'
    isKeepInRoom.value = true;
    isKeepInRoom.value = false;
  }

  // issue: missing const on simple pure widgets
  static Widget buildDivider() => SizedBox(height: 1);
  static Widget buildSpacer() => Spacer();
  static Widget buildEmpty() => SizedBox.shrink();
}

// =============================================================================
// ANALYSIS
// =============================================================================

// ISSUE #1: StreamBuilder at the root rebuilds everything every 30 seconds
// IMPACT: HIGH
// WHY: It wraps the entire Stack, so every tick re-runs build for all children
//      even if nothing changed.
// FIX: Move it down so it wraps only the widget that actually uses the stream.
//      If nothing visible depends on it, remove it.

// ISSUE #2: 4 BlocBuilder<FetchUserDataBloc> without buildWhen
// IMPACT: HIGH
// WHY: Every state change (unreadCount, wallet, isOnline, banners) triggers all
//      4 builders even when only 1 field changed. In a realtime app this is very
//      frequent.
// FIX: Add buildWhen to each one — only rebuild when its field changes:
//
//   BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
//     buildWhen: (prev, curr) => prev.bannerData?['gift'] != curr.bannerData?['gift'],
//     builder: (_, state) { ... },
//   )
//   BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
//     buildWhen: (prev, curr) => prev.isOnline != curr.isOnline,
//     builder: (_, state) { ... },
//   )

// ISSUE #3: BlocBuilder<HomeBloc> wraps the whole home page
// IMPACT: HIGH
// WHY: Any change to any of HomeState's 50+ fields rebuilds all 4 tab views,
//      even the tabs that are not visible.
// FIX: One builder per tab, each with its own buildWhen:
//
//   BlocBuilder<HomeBloc, HomeState>(
//     buildWhen: (p, c) => p.currentTabIndex != c.currentTabIndex,
//     builder: (_, state) => _TabBar(currentIndex: state.currentTabIndex),
//   )
//   BlocBuilder<HomeBloc, HomeState>(
//     buildWhen: (p, c) =>
//         p.popularRooms != c.popularRooms ||
//         p.popularCurrentPage != c.popularCurrentPage,
//     builder: (_, state) => _PopularTab(rooms: state.popularRooms),
//   )

// ISSUE #4: Nested BlocBuilders for the unread counter
// IMPACT: MEDIUM
// WHY: Outer (FetchUserDataBloc) rebuilds on any user change, inner (LayoutBloc)
//      on any nav change — the badge rebuilds even when it is hidden.
// FIX:
//   BlocBuilder<LayoutBloc, LayoutState>(
//     buildWhen: (p, c) => p.currentIndex != c.currentIndex,
//     builder: (_, layoutState) {
//       if (layoutState.currentIndex != 1) return const SizedBox.shrink();
//       return BlocBuilder<FetchUserDataBloc, FetchUserDataState>(
//         buildWhen: (p, c) => p.unreadCount != c.unreadCount,
//         builder: (_, userState) => _Badge(count: userState.unreadCount),
//       );
//     },
//   )

// ISSUE #5: ValueNotifier created inside build()
// IMPACT: HIGH
// WHY: A brand new ValueNotifier is created every rebuild so the listener never
//      fires — wallet always shows '0' and can never update.
// FIX: Read walletBalance from the BLoC using BlocSelector instead:
//
//   BlocSelector<FetchUserDataBloc, FetchUserDataState, String?>(
//     selector: (state) => state.walletBalance,
//     builder: (_, wallet) => Text('${wallet ?? "0"}'),
//   )

// ISSUE #6: ShowSVGA animation loaded for all nav icons at startup
// IMPACT: MEDIUM
// WHY: All 4 SVGA files load and start animating even though only 1 is active.
//      Heavy on CPU and memory on mid-range devices.
// FIX: Only render the SVGA for the active tab:
//
//   activeIcon: currentIndex == 0
//       ? const ShowSVGA(svgaAssetPath: 'assets/svga/home_active.svga')
//       : Image.asset('assets/icons/home.png'),

// ISSUE #7: Static routes Map holds all closures in memory permanently
// IMPACT: LOW
// WHY: Created at class-load time and never freed, even for routes never visited.
//      With 100+ routes this adds up.
// FIX: Migrate to onGenerateRoute — closures are created only when a route is pushed:
//
//   Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(
//           builder: (_) => MultiBlocProvider(
//             providers: [
//               BlocProvider.value(value: di<SplashBloc>()),
//               BlocProvider.value(value: di<ConfigAppBloc>()),
//             ],
//             child: const SplashPage(),
//           ),
//         );
//       case '/login':
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider.value(
//             value: di<LoginBloc>(), child: const LoginPage(),
//           ),
//         );
//       default:
//         return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Not found')));
//     }
//   }

// ISSUE #8: ValueNotifier set twice in a row in onExitRoom
// IMPACT: LOW
// WHY: value = true then immediately value = false — both notifications fire in
//      the same microtask so the 'true' state is never actually rendered.
// FIX:
//   static void onExitRoom() {
//     isKeepInRoom.value = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       isKeepInRoom.value = false;
//     });
//   }

// ISSUE #9: Missing const on simple widgets
// IMPACT: LOW
// WHY: Non-const widgets are heap-allocated on every build. Const widgets are
//      canonicalized so Flutter skips diffing them.
// FIX:
//   static Widget buildDivider() => const SizedBox(height: 1);
//   static Widget buildSpacer()  => const Spacer();
//   static Widget buildEmpty()   => const SizedBox.shrink();

// ISSUE #10: BlocBuilder<LayoutBloc> rebuilds IndexedStack on showBanner change
// IMPACT: MEDIUM
// WHY: showBanner and currentIndex are both in LayoutState. Toggling a banner
//      triggers a full rebuild of IndexedStack even though the tab didn't change.
// FIX:
//   BlocBuilder<LayoutBloc, LayoutState>(
//     buildWhen: (prev, curr) => prev.currentIndex != curr.currentIndex,
//     builder: (context, layoutState) => IndexedStack(
//       index: layoutState.currentIndex,
//       children: const [_HomePage(), ChatPage(), ProfilePage(), SettingsPage()],
//     ),
//   )

// =============================================================================
// SENIOR BONUS #1: onGenerateRoute vs static Map
// =============================================================================
// Static Map: all closures created at class load, sit in memory forever.
// onGenerateRoute: closure created only when Navigator.push() is called.
// Also supports typed route arguments and per-route page transitions.
// See fix code in ISSUE #7 above.

// =============================================================================
// SENIOR BONUS #2: HomeState split (50+ fields to focused sub-states)
// =============================================================================
//
// TabState          { currentTabIndex }
// PopularRoomsState { popularRooms, popularCurrentPage, popularLastPage, status }
// LiveRoomsState    { liveRooms, liveCurrentPage, liveLastPage, status }
// FollowRoomsState  { followRooms, followCurrentPage, followLastPage, status }
// FriendsRoomsState { friendsRooms, friendsCurrentPage, friendsLastPage, status }
// SearchState       { filteredRooms, searchQuery, status }
//
// Each tab subscribes to its own state only.
// Updating popularRooms no longer rebuilds Live, Follow, Friends, or the TabBar.
