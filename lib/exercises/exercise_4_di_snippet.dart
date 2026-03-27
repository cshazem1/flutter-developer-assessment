// ignore_for_file: unused_field, unused_local_variable

class _GetIt {
  static final _GetIt instance = _GetIt();
  void registerSingleton<T extends Object>(T instance) {}
  void registerLazySingleton<T extends Object>(T Function() factoryFunc) {}
  void registerFactory<T extends Object>(T Function() factoryFunc,
      {String? instanceName}) {}
  T call<T extends Object>({String? instanceName}) => throw UnimplementedError();
}

final di = _GetIt.instance;

// ---------------------------------------------------------------------------
// Mock classes
// ---------------------------------------------------------------------------

class DioFactory {}
class HiveManager {}
class SharedPreferences {}

class HomeRemoteDataSource { HomeRemoteDataSource(DioFactory dio); }
class MessagesRemoteDataSource { MessagesRemoteDataSource(DioFactory dio); }
class ProfileRemoteDataSource { ProfileRemoteDataSource(DioFactory dio); }
class PusherRemoteDataSource { PusherRemoteDataSource(dynamic pusher); }

class HomeRepository { HomeRepository(HomeRemoteDataSource ds); }
class MessagesRepository { MessagesRepository(MessagesRemoteDataSource ds); }
class ProfileRepository { ProfileRepository(ProfileRemoteDataSource ds); }
class PusherRepository { PusherRepository(PusherRemoteDataSource ds); }

class FetchRoomsUC { FetchRoomsUC(HomeRepository repo); }
class FetchLiveRoomsUC { FetchLiveRoomsUC(HomeRepository repo); }
class CreateRoomUC { CreateRoomUC(HomeRepository repo); }
class FetchMessagesUC { FetchMessagesUC(MessagesRepository repo); }
class SendMessageUC { SendMessageUC(MessagesRepository repo); }
class DeleteMessageUC { DeleteMessageUC(MessagesRepository repo); }
class FetchUserProfileUC { FetchUserProfileUC(ProfileRepository repo); }
class FetchMyProfileUC { FetchMyProfileUC(ProfileRepository repo); }
class UpdateProfileUC { UpdateProfileUC(ProfileRepository repo); }
class FetchGiftHistoryUC { FetchGiftHistoryUC(ProfileRepository repo); }
class FetchUserBadgesUC { FetchUserBadgesUC(ProfileRepository repo); }
class FetchMyBadgesUC { FetchMyBadgesUC(ProfileRepository repo); }
class FetchCpProfileUC { FetchCpProfileUC(ProfileRepository repo); }
class FetchUserRoomsUC { FetchUserRoomsUC(ProfileRepository repo); }
class FetchSupporterUC { FetchSupporterUC(ProfileRepository repo); }
class FetchUserIntroUC { FetchUserIntroUC(ProfileRepository repo); }
class FetchReelsUC { FetchReelsUC(HomeRepository repo); }
class LikeReelUC { LikeReelUC(HomeRepository repo); }
class ShareReelUC { ShareReelUC(HomeRepository repo); }
class ViewReelUC { ViewReelUC(HomeRepository repo); }
class FetchMomentsUC { FetchMomentsUC(HomeRepository repo); }
class InitPusherUC { InitPusherUC(PusherRepository repo); }
class SubscribeChatUC { SubscribeChatUC(PusherRepository repo); }
class SubscribeMessagesUC { SubscribeMessagesUC(PusherRepository repo); }
class ListenToBannersUC { ListenToBannersUC(PusherRepository repo); }
class ListenToGamesUC { ListenToGamesUC(PusherRepository repo); }
class SubscribeCounterUC { SubscribeCounterUC(PusherRepository repo); }
class FetchConfigUC { FetchConfigUC(HomeRepository repo); }
class FetchCountriesUC { FetchCountriesUC(HomeRepository repo); }
class UpdateFCMTokenUC { UpdateFCMTokenUC(ProfileRepository repo); }
class FetchLevelDataUC { FetchLevelDataUC(ProfileRepository repo); }
class InitAnalyticsUC { InitAnalyticsUC(HomeRepository repo); }
class FetchWalletUC { FetchWalletUC(ProfileRepository repo); }

class HomeBloc { HomeBloc(FetchRoomsUC uc1, FetchLiveRoomsUC uc2); }
class CreateRoomBloc { CreateRoomBloc(CreateRoomUC uc); }
class MessagesBloc { MessagesBloc(FetchMessagesUC uc, SendMessageUC uc2); }
class DeleteMessageBloc { DeleteMessageBloc(DeleteMessageUC uc); }
class GiftHistoryBloc { GiftHistoryBloc({required FetchGiftHistoryUC giftHistoryUseCase}); }
class GetBadgesBloc { GetBadgesBloc({required FetchUserBadgesUC getBadgesUseCase, required FetchMyBadgesUC getMyAllBadgeUC}); }
class UserBadgesBloc { UserBadgesBloc({required FetchUserBadgesUC uc}); }
class GetUserBadgesBloc { GetUserBadgesBloc({required FetchUserBadgesUC uc}); }
class CpProfileBloc { CpProfileBloc({required FetchCpProfileUC uc}); }
class GetUserRoomsBloc { GetUserRoomsBloc({required FetchUserRoomsUC uc}); }
class GetSupporterBloc { GetSupporterBloc({required FetchSupporterUC uc}); }
class GetUserIntroBloc { GetUserIntroBloc({required FetchUserIntroUC uc}); }
class GetReelsBloc { GetReelsBloc(FetchReelsUC uc1, LikeReelUC uc2, ShareReelUC uc3, ViewReelUC uc4); }
class ReelViewerBloc { ReelViewerBloc(ViewReelUC uc); }
class MomentBloc { MomentBloc(FetchMomentsUC uc); }

class FetchUserDataBloc {
  FetchUserDataBloc(
    FetchMyProfileUC uc1, FetchUserProfileUC uc2, InitPusherUC uc3,
    SubscribeChatUC uc4, SubscribeMessagesUC uc5, ListenToBannersUC uc6,
    ListenToGamesUC uc7, SubscribeCounterUC uc8, FetchConfigUC uc9,
    FetchCountriesUC uc10, UpdateFCMTokenUC uc11, FetchUserBadgesUC uc12,
    FetchLevelDataUC uc13, InitAnalyticsUC uc14, FetchWalletUC uc15,
    FetchGiftHistoryUC uc16, FetchUserRoomsUC uc17, FetchSupporterUC uc18,
    FetchCpProfileUC uc19, FetchUserIntroUC uc20, FetchMyBadgesUC uc21,
  );
}

// ---------------------------------------------------------------------------
// Question 1 [Junior]: DI registration types
// ---------------------------------------------------------------------------
/*
registerSingleton<T>(T instance):
  Creates the instance immediately and keeps it forever.
  Use it for things that must exist before anything else runs (Dio, SharedPrefs).

registerLazySingleton<T>(T Function() factory):
  Creates ONE instance, but only on the first call. Same object every time after.
  Use it for heavy objects that are shared app-wide (repos, data sources, use cases).

registerFactory<T>(T Function() factory):
  Returns a fresh instance on every call.
  Use it for BLoCs/ViewModels that hold per-screen state.

Having both lazySingleton AND factory for the same type is a mistake:
  callers get different instances depending on which registration resolves,
  the factory version (with instanceName) is dead code nobody calls,
  and it signals the team hasn't agreed on whether this object is shared or not.
*/

// ---------------------------------------------------------------------------
// Question 2 [Mid]: Refactored DI — no duplicates
// ---------------------------------------------------------------------------

class DependencyInjectionServiceRefactored {
  static Future<void> init() async {
    // Singleton: must exist before anything else
    di.registerSingleton<DioFactory>(DioFactory());
    di.registerSingleton<HiveManager>(HiveManager());

    // LazySingleton: shared, stateless, created once on first use
    di.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSource(di()));
    di.registerLazySingleton<MessagesRemoteDataSource>(() => MessagesRemoteDataSource(di()));
    di.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource(di()));
    di.registerLazySingleton<PusherRemoteDataSource>(() => PusherRemoteDataSource(null));

    di.registerLazySingleton<HomeRepository>(() => HomeRepository(di()));
    di.registerLazySingleton<MessagesRepository>(() => MessagesRepository(di()));
    di.registerLazySingleton<ProfileRepository>(() => ProfileRepository(di()));
    di.registerLazySingleton<PusherRepository>(() => PusherRepository(di()));

    di.registerLazySingleton(() => FetchRoomsUC(di()));
    di.registerLazySingleton(() => FetchLiveRoomsUC(di()));
    di.registerLazySingleton(() => CreateRoomUC(di()));
    di.registerLazySingleton(() => FetchMessagesUC(di()));
    di.registerLazySingleton(() => SendMessageUC(di()));
    di.registerLazySingleton(() => DeleteMessageUC(di()));
    di.registerLazySingleton(() => FetchUserProfileUC(di()));
    di.registerLazySingleton(() => FetchMyProfileUC(di()));
    di.registerLazySingleton(() => UpdateProfileUC(di()));
    di.registerLazySingleton(() => FetchGiftHistoryUC(di()));
    di.registerLazySingleton(() => FetchUserBadgesUC(di()));
    di.registerLazySingleton(() => FetchMyBadgesUC(di()));
    di.registerLazySingleton(() => FetchCpProfileUC(di()));
    di.registerLazySingleton(() => FetchUserRoomsUC(di()));
    di.registerLazySingleton(() => FetchSupporterUC(di()));
    di.registerLazySingleton(() => FetchUserIntroUC(di()));
    di.registerLazySingleton(() => FetchReelsUC(di()));
    di.registerLazySingleton(() => LikeReelUC(di()));
    di.registerLazySingleton(() => ShareReelUC(di()));
    di.registerLazySingleton(() => ViewReelUC(di()));
    di.registerLazySingleton(() => FetchMomentsUC(di()));
    di.registerLazySingleton(() => InitPusherUC(di()));
    di.registerLazySingleton(() => SubscribeChatUC(di()));
    di.registerLazySingleton(() => SubscribeMessagesUC(di()));
    di.registerLazySingleton(() => ListenToBannersUC(di()));
    di.registerLazySingleton(() => ListenToGamesUC(di()));
    di.registerLazySingleton(() => SubscribeCounterUC(di()));
    di.registerLazySingleton(() => FetchConfigUC(di()));
    di.registerLazySingleton(() => FetchCountriesUC(di()));
    di.registerLazySingleton(() => UpdateFCMTokenUC(di()));
    di.registerLazySingleton(() => FetchLevelDataUC(di()));
    di.registerLazySingleton(() => InitAnalyticsUC(di()));
    di.registerLazySingleton(() => FetchWalletUC(di()));

    // LazySingleton: shared state that survives tab navigation
    di.registerLazySingleton(() => HomeBloc(di(), di()));
    di.registerLazySingleton(() => MessagesBloc(di(), di()));

    // Factory: short-lived, per-screen BLoCs that shouldn't share state
    di.registerFactory(() => CreateRoomBloc(di()));
    di.registerFactory(() => DeleteMessageBloc(di()));
    di.registerFactory(() => GiftHistoryBloc(giftHistoryUseCase: di()));
    di.registerFactory(() => GetBadgesBloc(getBadgesUseCase: di(), getMyAllBadgeUC: di()));
    di.registerFactory(() => UserBadgesBloc(uc: di()));
    di.registerFactory(() => GetUserBadgesBloc(uc: di()));
    di.registerFactory(() => CpProfileBloc(uc: di()));
    di.registerFactory(() => GetUserRoomsBloc(uc: di()));
    di.registerFactory(() => GetSupporterBloc(uc: di()));
    di.registerFactory(() => GetUserIntroBloc(uc: di()));
    di.registerFactory(() => GetReelsBloc(di(), di(), di(), di()));
    di.registerFactory(() => ReelViewerBloc(di()));
    di.registerFactory(() => MomentBloc(di()));

    // FetchUserDataBloc removed — split into 4 focused BLoCs (see Q3)
  }
}

// ---------------------------------------------------------------------------
// Question 3 [Senior]: Modular DI + God-class split
// ---------------------------------------------------------------------------
/*
a) Splitting the 2000-line DI file:
   One init function per feature, called lazily when the user navigates there:

   initCoreDeps()     → Dio, Hive
   initHomeFeature()  → home data sources, repos, use cases, HomeBloc
   initProfile()      → profile data sources, repos, use cases
   initPusher()       → pusher repo + all subscribe use cases

   In main(): call initCoreDeps(), then initHomeFeature() upfront.
   Call initProfile() only when the user opens the profile screen.

b) Splitting FetchUserDataBloc (21 params → 4 BLoCs):

   UserProfileBloc(FetchMyProfileUC, FetchUserProfileUC)
   RealTimeBloc(InitPusherUC, SubscribeChatUC, SubscribeMessagesUC,
                ListenToBannersUC, ListenToGamesUC, SubscribeCounterUC)
   AppConfigBloc(FetchConfigUC, FetchCountriesUC, InitAnalyticsUC, UpdateFCMTokenUC)
   UserExtrasBloc(FetchUserBadgesUC, FetchLevelDataUC, FetchWalletUC,
                  FetchGiftHistoryUC, FetchUserRoomsUC, FetchSupporterUC,
                  FetchCpProfileUC, FetchUserIntroUC, FetchMyBadgesUC)

c) Dependency diagram:

   Dio/Hive
     │
     ▼
   DataSources → Repositories → UseCases
                                    │
                   ┌────────────────┼──────────────┬──────────────┐
                   ▼                ▼              ▼              ▼
            UserProfile         RealTime       AppConfig     UserExtras

   Testability: max 9 mocks for the worst BLoC vs 21 for the god-class.
*/
