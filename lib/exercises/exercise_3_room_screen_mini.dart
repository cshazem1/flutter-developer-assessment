import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final di = _MockDI();

class _MockDI {
  T call<T>() => throw UnimplementedError('Mock DI');
}

class ZegoService {
  Stream<Map<String, dynamic>> getCommandStream() =>
      Stream.periodic(const Duration(seconds: 5), (i) => {'type': 'ping'});

  Stream<Map<String, dynamic>> getMessageStream() =>
      Stream.periodic(const Duration(seconds: 3), (i) => {'msg': 'hello $i'});

  Stream<Map<String, dynamic>> getUserJoinStream() =>
      Stream.periodic(const Duration(seconds: 10), (i) => {'user': 'user_$i'});
}

final zegoService = ZegoService();
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class RoomState extends Equatable {
  final String roomMode;
  final bool isCommentLocked;
  final List<String> messages;
  final int seatCount;
  final bool isLoading;

  const RoomState({
    this.roomMode = 'normal',
    this.isCommentLocked = false,
    this.messages = const [],
    this.seatCount = 8,
    this.isLoading = false,
  });

  RoomState copyWith({
    String? roomMode,
    bool? isCommentLocked,
    List<String>? messages,
    int? seatCount,
    bool? isLoading,
  }) =>
      RoomState(
        roomMode: roomMode ?? this.roomMode,
        isCommentLocked: isCommentLocked ?? this.isCommentLocked,
        messages: messages ?? this.messages,
        seatCount: seatCount ?? this.seatCount,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props =>
      [roomMode, isCommentLocked, messages, seatCount, isLoading];
}

class RoomEvent extends Equatable {
  const RoomEvent();
  @override
  List<Object?> get props => [];
}

class UpdateModeEvent extends RoomEvent {
  final String mode;
  const UpdateModeEvent(this.mode);
}

class AddMessageEvent extends RoomEvent {
  final String message;
  const AddMessageEvent(this.message);
}

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc() : super(const RoomState()) {
    on<UpdateModeEvent>((event, emit) {
      emit(state.copyWith(roomMode: event.mode));
    });
    on<AddMessageEvent>((event, emit) {
      emit(state.copyWith(messages: [...state.messages, event.message]));
    });
  }
}

class BannerState extends Equatable {
  final Map<String, dynamic>? activeBanner;
  final bool isVisible;

  const BannerState({this.activeBanner, this.isVisible = false});

  BannerState copyWith({
    Map<String, dynamic>? activeBanner,
    bool? isVisible,
  }) =>
      BannerState(
        activeBanner: activeBanner ?? this.activeBanner,
        isVisible: isVisible ?? this.isVisible,
      );

  @override
  List<Object?> get props => [activeBanner, isVisible];
}

class BannerEvent extends Equatable {
  const BannerEvent();
  @override
  List<Object?> get props => [];
}

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(const BannerState());
}

// ---------------------------------------------------------------------------
// Fixed screen — bugs listed below each fix
// ---------------------------------------------------------------------------

class RoomScreenMini extends StatefulWidget {
  final int roomId;
  final bool isLocked;

  // added const
  const RoomScreenMini(
      {super.key, required this.roomId, this.isLocked = false});

  @override
  State<RoomScreenMini> createState() => _RoomScreenMiniState();
}

class _RoomScreenMiniState extends State<RoomScreenMini>
    with WidgetsBindingObserver {
  // Bug #7: these were static — shared across all room instances which corrupts state
  final Map<String, GlobalKey> seatKeys = {};
  final Map<int, String> seatUserIds = {};

  final RoomBloc _roomBloc = RoomBloc();
  final BannerBloc _bannerBloc = BannerBloc();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  late final ScrollController _chatScrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatScrollController = ScrollController();
    _initializeSubscriptions();
    _loadRoomData();
  }

  void _initializeSubscriptions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Bug #3: getMessageStream was never subscribed to — messages were dropped
      _subscriptions.add(
        zegoService.getMessageStream().listen((event) {
          _roomBloc.add(AddMessageEvent(event['msg'] ?? ''));
        }),
      );
      _subscriptions
          .add(zegoService.getCommandStream().listen(_onCommandReceived));
      _subscriptions.add(zegoService.getUserJoinStream().listen(_onUserJoined));
    });
  }

  Future<void> _loadRoomData() async {
    await Future.delayed(const Duration(seconds: 2));
    // Bug #1: no mounted check — setState on a disposed widget throws
    if (!mounted) return;
    setState(() {
      seatKeys.clear();
      for (int i = 0; i < 8; i++) {
        seatKeys['seat_$i'] = GlobalKey();
      }
    });
  }

  void _onCommandReceived(Map<String, dynamic> data) {
    try {
      final String type = data['type'] ?? '';
      switch (type) {
        case 'mode_change':
          _roomBloc.add(UpdateModeEvent(data['mode'] ?? 'normal'));
          break;
        case 'ban_user':
          // Bug #5: navKey.currentState can be null — accessing .context on null crashes
          final currentState = navKey.currentState;
          if (currentState != null) {
            Navigator.popUntil(currentState.context, (route) => route.isFirst);
          }
          break;
        case 'lock_comments':
          _roomBloc.add(const UpdateModeEvent('locked'));
          break;
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    }
  }

  void _onUserJoined(Map<String, dynamic> data) {
    _roomBloc.add(AddMessageEvent('${data['user']} joined the room'));
  }

  // Bug #8: was async — framework declares this void and doesn't await it,
  // so exceptions become unhandled errors
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Future.delayed(const Duration(milliseconds: 100), () {
        debugPrint('Camera stopped');
      });
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        debugPrint('Camera resumed');
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Bug #4: subscriptions were never cancelled — streams keep firing after widget is gone
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _chatScrollController.dispose();
    _roomBloc.close();
    _bannerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Room'),
              background: Container(color: Colors.purple.shade900),
            ),
          ),

          SliverToBoxAdapter(
            child: BlocBuilder<RoomBloc, RoomState>(
              bloc: _roomBloc,
              // Bug #6: no buildWhen — every AddMessageEvent was rebuilding the mode badge too
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: state.roomMode == 'locked'
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  child: Text('Mode: ${state.roomMode}'),
                );
              },
            ),
          ),

          // Bug #2: GridView.builder inside CustomScrollView creates nested scrollables
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                 mainAxisExtent: 100,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.grey),
                          const SizedBox(height: 4),
                          Text('Seat ${index + 1}',
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _roomBloc.state.seatCount,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: BlocBuilder<BannerBloc, BannerState>(
              bloc: _bannerBloc,
              buildWhen: (prev, curr) => prev.isVisible != curr.isVisible,
              builder: (context, state) {
                if (!state.isVisible) return const SizedBox.shrink();
                return Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.amber, Colors.orange]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      state.activeBanner?['text'] ?? 'Special Event!',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Chat Messages ---
          BlocBuilder<RoomBloc, RoomState>(
            bloc: _roomBloc,
            // Missing buildWhen
            builder: (context, state) {
              return SliverList.builder(
                // Performance issue: shrinkWrap not needed here since
                // parent container has fixed height, but it's still bad
                // practice to leave it (it's not present here though)
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  return CustomChatMessage(
                    message:state.messages[index] ,
                    key: Key(state.messages[index]),
                  );
                },
              );
            },
          ),
        ],
      ),

      // --- Bottom Action Bar ---
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.card_giftcard),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChatMessage extends StatelessWidget {
  const CustomChatMessage({
    super.key,
    required this.message
  });
final String message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
