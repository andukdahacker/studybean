import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/di/get_it.dart';
import 'features/auth/auth/auth_cubit.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuth(),
      lazy: false,
      child: MaterialApp.router(
        routerConfig: router,
        title: 'StudyBean',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45),
          useMaterial3: true,
        ),
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF7C5EF1),
            onPrimary: Colors.black,
            primaryContainer: Colors.white,
            secondary: Color(0xFF2653EF),
            onSecondary: Colors.white,
            tertiary: Color(0xFFED2677),
            onTertiary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Color(0xFFF3F5FC),
            onSurface: Colors.black,
          ),
          fontFamily: 'PlusJakartaSans',
          textTheme: const TextTheme(),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlusJakartaSans',
                ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C5EF1),
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
              shadowColor: Colors.grey,
              foregroundColor: Colors.white,
              elevation: 2,
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              side: const BorderSide(
                width: 2,
                color: Color(0xFF7C5EF1),
              ),
            ),
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color(0xFFF3F5FC),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          dropdownMenuTheme: const DropdownMenuThemeData(
              menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            surfaceTintColor: WidgetStatePropertyAll(Colors.white),
            elevation: WidgetStatePropertyAll(1),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))),
          )),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Colors.red,
          ),
          shadowColor: Colors.grey.withAlpha((255.0 * 0.1).round()),
          checkboxTheme: const CheckboxThemeData(
            shape: CircleBorder(),
            visualDensity: VisualDensity(
                vertical: VisualDensity.minimumDensity,
                horizontal: VisualDensity.minimumDensity),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            checkColor: WidgetStatePropertyAll(Colors.white),
          ),
          chipTheme: const ChipThemeData(),
        ),
      ),
    );
  }
}
