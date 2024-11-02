import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybean/common/api/api_client.dart';
import 'package:studybean/common/api/auth_interceptor.dart';
import 'package:studybean/common/api/header_interceptor.dart';
import 'package:studybean/common/api/logging_interceptor.dart';
import 'package:studybean/common/db/local_db.dart';
import 'package:studybean/features/auth/auth/auth_cubit.dart';
import 'package:studybean/features/auth/change_password/bloc/change_password_cubit.dart';
import 'package:studybean/features/auth/forgot_password/bloc/forgot_password_cubit.dart';
import 'package:studybean/features/auth/repository/auth_local_repository.dart';
import 'package:studybean/features/auth/repository/auth_repository.dart';
import 'package:studybean/features/auth/services/firebase_auth_service.dart';
import 'package:studybean/features/auth/sign_up/bloc/sign_up_cubit.dart';
import 'package:studybean/features/home/bloc/check_user_credit_cubit/check_user_credit_cubit.dart';
import 'package:studybean/features/home/bloc/upload_local_roadmap_cubit/upload_local_roadmap_cubit.dart';
import 'package:studybean/features/home/repository/home_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';
import 'package:studybean/features/roadmap/repositories/subject_repository.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/check_user_credit/check_local_user_credit_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/choose_subject_cubit/choose_subject_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_subject_cubit/create_subject_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/add_milestone_cubit/add_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/add_milestone_cubit/add_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/create_action_cubit/create_local_action_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/create_action_resource_cubit/create_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_action_resource_cubit/delete_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_action_resource_cubit/delete_local_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_milestone_cubit/delete_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_milestone_cubit/delete_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_roadmap_cubit/delete_local_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_roadmap_cubit/delete_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_local_action_resource_cubit/edit_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_local_action_resource_cubit/edit_local_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_milestone_cubit/edit_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_action_cubit/get_local_action_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_milestone_cubit/get_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_milestone_cubit/get_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_roadmap_cubit/get_local_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_roadmap_cubit/get_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/mark_action_complete_cubit/mark_action_complete_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/mark_action_complete_cubit/mark_local_action_complete_cubit.dart';

import '../../features/auth/sign_in/bloc/sign_in_cubit.dart';
import '../../features/roadmap/views/create_roadmap/bloc/create_roadmap_cubit/create_roadmap_cubit.dart';
import '../../features/roadmap/views/create_roadmap/bloc/create_roadmap_cubit/create_roadmap_with_ai_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/create_action_cubit/create_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/create_action_resource_cubit/create_local_action_resource_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/delete_action_cubit/delete_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/delete_action_cubit/delete_local_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/edit_action_cubit/edit_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/edit_action_cubit/edit_local_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/edit_milestone_cubit/edit_milestone_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/get_action_cubit/get_action_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/get_roadmap_detail_cubit/get_local_roadmap_detail_cubit.dart';
import '../../features/roadmap/views/roadmap/bloc/get_roadmap_detail_cubit/get_roadmap_detail_cubit.dart';
import '../../features/splash/views/bloc/splash_cubit.dart';
import '../services/shared_preference_service.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerSingleton<SharedPreferenceService>(SharedPreferenceService(
    pref: await SharedPreferences.getInstance(),
  ));

  getIt.registerSingleton<APIClient>(
    APIClient(
      InterceptedClient.build(
        interceptors: [
          CommonHeaderInterceptor(),
          AuthInterceptor(getIt<SharedPreferenceService>()),
          LoggingInterceptor(),
        ],
      ),
    ),
  );

  getIt.registerSingleton<LocalDB>(
    LocalDB(
      await LocalDB.openDb(),
    ),
  );

  getIt.registerSingleton<FirebaseAuthService>(
      FirebaseAuthService(FirebaseAuth.instance));

  getIt.registerSingleton<RoadmapRepository>(
      RoadmapRepository(getIt<APIClient>()));

  getIt.registerSingleton<SubjectRepository>(
      SubjectRepository(getIt<APIClient>()));

  getIt.registerSingleton<AuthRepository>(AuthRepository(getIt<APIClient>()));

  getIt.registerSingleton<RoadmapLocalRepository>(
      RoadmapLocalRepository(getIt<LocalDB>()));

  getIt.registerSingleton<AuthLocalRepository>(
      AuthLocalRepository(getIt<LocalDB>()));

  getIt.registerSingleton<HomeRepository>(HomeRepository(getIt<APIClient>()));

  getIt.registerFactory<SplashCubit>(() => SplashCubit(
      getIt<RoadmapLocalRepository>(),
      getIt<AuthLocalRepository>(),
      getIt<SharedPreferenceService>()));

  getIt.registerFactory<AuthCubit>(() => AuthCubit(
      getIt<AuthLocalRepository>(), getIt<SharedPreferenceService>()));

  getIt.registerFactory<ChooseSubjectCubit>(
      () => ChooseSubjectCubit(getIt<SubjectRepository>()));

  getIt.registerFactory<CreateSubjectCubit>(
      () => CreateSubjectCubit(getIt<SubjectRepository>()));

  getIt.registerFactory<CreateLocalRoadmapCubit>(
      () => CreateLocalRoadmapCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<GetLocalRoadmapCubit>(
      () => GetLocalRoadmapCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<GetLocalRoadmapDetailCubit>(
      () => GetLocalRoadmapDetailCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<AddLocalMilestoneCubit>(
      () => AddLocalMilestoneCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<GetLocalMilestoneCubit>(
      () => GetLocalMilestoneCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<CreateLocalActionCubit>(
      () => CreateLocalActionCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<MarkLocalActionCompleteCubit>(
      () => MarkLocalActionCompleteCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<GetLocalActionCubit>(
      () => GetLocalActionCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<CreateLocalActionResourceCubit>(
      () => CreateLocalActionResourceCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<EditLocalActionResourceCubit>(
      () => EditLocalActionResourceCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<DeleteLocalActionResourceCubit>(
      () => DeleteLocalActionResourceCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<EditLocalActionCubit>(
      () => EditLocalActionCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<DeleteLocalActionCubit>(
      () => DeleteLocalActionCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<EditLocalMilestoneCubit>(
      () => EditLocalMilestoneCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<DeleteLocalMilestoneCubit>(
      () => DeleteLocalMilestoneCubit(getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<CreateLocalRoadmapWithAiCubit>(
      () => CreateLocalRoadmapWithAiCubit(
            getIt<RoadmapRepository>(),
            getIt<RoadmapLocalRepository>(),
            getIt<SharedPreferenceService>(),
          ));

  getIt.registerFactory<SignUpCubit>(
      () => SignUpCubit(getIt<AuthRepository>(), getIt<FirebaseAuthService>()));

  getIt.registerFactory<SignInCubit>(() => SignInCubit(
      getIt<FirebaseAuthService>(),
      getIt<AuthRepository>(),
      getIt<SharedPreferenceService>(),
      getIt<AuthLocalRepository>()));

  getIt.registerFactory<GetRoadmapCubit>(
      () => GetRoadmapCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CreateRoadmapCubit>(
      () => CreateRoadmapCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CreateRoadmapWithAiCubit>(
      () => CreateRoadmapWithAiCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<GetRoadmapDetailCubit>(
      () => GetRoadmapDetailCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<AddMilestoneCubit>(
      () => AddMilestoneCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<GetMilestoneCubit>(
      () => GetMilestoneCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<DeleteMilestoneCubit>(
      () => DeleteMilestoneCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<MarkActionCompleteCubit>(
      () => MarkActionCompleteCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<EditMilestoneCubit>(
      () => EditMilestoneCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<GetActionCubit>(
      () => GetActionCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CreateActionCubit>(
      () => CreateActionCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<DeleteActionCubit>(
      () => DeleteActionCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<EditActionCubit>(
      () => EditActionCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(getIt<FirebaseAuthService>()));

  getIt.registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(getIt<FirebaseAuthService>()));

  getIt.registerFactory<UploadLocalRoadmapCubit>(() => UploadLocalRoadmapCubit(
      getIt<RoadmapRepository>(), getIt<RoadmapLocalRepository>()));

  getIt.registerFactory<DeleteActionResourceCubit>(
      () => DeleteActionResourceCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CheckLocalUserCreditCubit>(
      () => CheckLocalUserCreditCubit(getIt<SharedPreferenceService>()));

  getIt.registerFactory<EditActionResourceCubit>(
      () => EditActionResourceCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CreateActionResourceCubit>(
      () => CreateActionResourceCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<CheckUserCreditCubit>(
      () => CheckUserCreditCubit(getIt<HomeRepository>()));

  getIt.registerFactory<DeleteRoadmapCubit>(
      () => DeleteRoadmapCubit(getIt<RoadmapRepository>()));

  getIt.registerFactory<DeleteLocalRoadmapCubit>(
      () => DeleteLocalRoadmapCubit(getIt<RoadmapLocalRepository>()));
}
