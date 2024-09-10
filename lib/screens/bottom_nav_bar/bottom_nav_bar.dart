import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:iconly/iconly.dart';
import '../../locale/l10n/app_locale.dart';
import '../../repos/authentication/authentication_repository.dart';
import '../../routes/app_routes.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  const BottomNavigationBarWidget({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthenticationRepository>(context);

    return Container(
      height: context.setHeight(8),
      decoration: const BoxDecoration(color: Color(0xFFECE6F0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(
            context,
            icon: IconlyBold.paper,
            label: AppLocale.of(context)!.trials,
            index: 0,
            isActive: currentIndex == 0,
            onTap: () {
              // Add your navigation logic here
            },
          ),
          buildNavItem(
            context,
            icon: IconlyBold.activity,
            label: AppLocale.of(context)!.data,
            index: 1,
            isActive: currentIndex == 1,
            onTap: () {
              // Add your navigation logic here
            },
          ),
          buildNavItem(
            context,
            icon: IconlyBold.home,
            label: AppLocale.of(context)!.titleHome,
            index: 2,
            isActive: currentIndex == 2,
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          buildNavItem(
            context,
            icon: IconlyBold.message,
            label: AppLocale.of(context)!.messages,
            index: 3,
            isActive: currentIndex == 3,
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.chat);
            },
          ),
          buildNavItem(
            context,
            icon: IconlyBold.profile,
            label: AppLocale.of(context)!.profile,
            index: 4,
            isActive: currentIndex == 4,
            onTap: () async {
              try {
                await authRepo.logOut();
                Navigator.pushReplacementNamed(context, AppRoutes.start);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocale.of(context)!.logoutFailed}: $error')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: context.setWidth(7),
            color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F),
          ),
          SizedBox(height: context.setWidth(1)),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F),
              fontSize: context.setWidth(3),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}