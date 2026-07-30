import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/network/network_info.dart';
import 'core/network/supabase_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_session.dart';
import 'features/auth/domain/usecases/login_with_email_password.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/signup_with_email_password.dart';
import 'features/auth/domain/usecases/update_user_role.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/counter/data/datasources/counter_local_data_source.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/get_counter.dart';
import 'features/counter/domain/usecases/increment_counter.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';
import 'features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import 'features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import 'features/donor_home/data/repositories/donor_card_repository_impl.dart';
import 'features/donor_home/data/repositories/donor_feed_repository_impl.dart';
import 'features/donor_home/domain/repositories/donor_card_repository.dart';
import 'features/donor_home/domain/repositories/donor_feed_repository.dart';
import 'features/donor_home/domain/usecases/donor_feed_usecases.dart';
import 'features/donor_home/domain/usecases/get_donor_card.dart';
import 'features/donor_home/presentation/bloc/donor_card_bloc.dart';
import 'features/donor_home/presentation/bloc/donor_feed_bloc.dart';
import 'features/notifications/data/datasources/notification_remote_data_source.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/domain/repositories/notification_repository.dart';
import 'features/notifications/domain/usecases/get_notifications.dart';
import 'features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/datasources/profile_local_data_source_impl.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/change_role.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/domain/usecases/upload_avatar.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/requester_home/data/datasources/request_remote_data_source.dart';
import 'features/requester_home/data/repositories/request_repository_impl.dart';
import 'features/requester_home/domain/repositories/request_repository.dart';
import 'features/requester_home/domain/usecases/request_usecases.dart';
import 'features/requester_home/presentation/bloc/request_bloc.dart';
import 'features/requester_home/presentation/bloc/request_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initCore();
  await initCounter();
  await initAuth();
  await initProfile();
  await initRequesterHome();
  await initNotifications();
  await initDonorHome();
}

Future<void> initDonorHome() async {
  sl.registerFactory(() => DonorCardBloc(getDonorCard: sl()));
  sl.registerFactory(
    () => DonorFeedBloc(
      getFeed: sl(),
      getRecords: sl(),
      acceptRequest: sl(),
      cancelAppointment: sl(),
      redeemRequestQr: sl(),
      redeemCampaignQr: sl(),
      setAvailability: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetDonorFeed(sl()));
  sl.registerLazySingleton(() => GetDonorAvailability(sl()));
  sl.registerLazySingleton(() => SetDonorAvailability(sl()));
  sl.registerLazySingleton(() => GetCompatibleDonationRequests(sl()));
  sl.registerLazySingleton(() => GetAvailableCampaigns(sl()));
  sl.registerLazySingleton(() => GetDonationAppointments(sl()));
  sl.registerLazySingleton(() => GetDonationRecords(sl()));
  sl.registerLazySingleton(() => AcceptBloodRequest(sl()));
  sl.registerLazySingleton(() => CancelDonationAppointment(sl()));
  sl.registerLazySingleton(() => RedeemRequestDonation(sl()));
  sl.registerLazySingleton(() => RedeemCampaignDonation(sl()));
  sl.registerLazySingleton(() => GetDonorCard(sl()));
  sl.registerLazySingleton<DonorCardRepository>(
    () => DonorCardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DonorCardRemoteDataSource>(
    () => DonorCardRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<DonorFeedRepository>(
    () => DonorFeedRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DonorFeedRemoteDataSource>(
    () => DonorFeedRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> initNotifications() async {
  sl.registerFactory(
    () =>
        NotificationsBloc(getNotifications: sl(), markNotificationAsRead: sl()),
  );
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsRead(sl()));
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> initRequesterHome() async {
  sl.registerFactory(
    () => RequestBloc(
      getRequests: sl(),
      getHospitals: sl(),
      createRequest: sl(),
      updateRequest: sl(),
      cancelRequest: sl(),
    ),
  );
  sl.registerFactory(
    () => RequestDetailBloc(
      getDonors: sl(),
      getCompatibleDonors: sl(),
      getInvitations: sl(),
      inviteDonor: sl(),
      issueQr: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetRecipientRequests(sl()));
  sl.registerLazySingleton(() => GetRecipientRequest(sl()));
  sl.registerLazySingleton(() => GetHospitals(sl()));
  sl.registerLazySingleton(() => CreateRecipientRequest(sl()));
  sl.registerLazySingleton(() => UpdateRecipientRequest(sl()));
  sl.registerLazySingleton(() => CancelRecipientRequest(sl()));
  sl.registerLazySingleton(() => GetRequestDonors(sl()));
  sl.registerLazySingleton(() => GetCompatibleDonors(sl()));
  sl.registerLazySingleton(() => GetRequestInvitations(sl()));
  sl.registerLazySingleton(() => InviteCompatibleDonor(sl()));
  sl.registerLazySingleton(() => IssueRequestQr(sl()));

  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> initProfile() async {
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl(),
      updateProfile: sl(),
      changeRole: sl(),
      uploadAvatar: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangeRole(sl()));
  sl.registerLazySingleton(() => UploadAvatar(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );
}

Future<void> initCore() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseService.client);
}

Future<void> initAuth() async {
  sl.registerFactory(
    () => AuthBloc(
      loginWithUsernamePassword: sl(),
      signupWithUsernamePassword: sl(),
      signOutUseCase: sl(),
      getCurrentSession: sl(),
      updateUserRole: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignupWithUsernamePassword(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> initCounter() async {
  sl.registerFactory(
    () => CounterBloc(getCounter: sl(), incrementCounter: sl()),
  );
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );
}
