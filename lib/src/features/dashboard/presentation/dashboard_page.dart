import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_shell.dart';

/// Main dashboard page displaying the VERBADENT title.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWideScreen =
        MediaQuery.of(context).size.width >= AppConstants.sidebarBreakpoint;

    return AppShell(
      showLanguageSelector: false,
      child: Container(
        key: const Key('dashboard_content'),
        color: AppColors.background,
        child: Center(
          child: Text(
            'VERBADENT',
            style: isWideScreen
                ? AppTextStyles.titleLarge
                : AppTextStyles.titleMobile,
          ),
        ),
      ),
    );
  }
}
