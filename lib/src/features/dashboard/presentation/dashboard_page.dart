import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
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
        color: context.appBackground,
        child: Center(
          child: Text(
            'VERBADENT',
            style: TextStyle(
              fontFamily: 'KumarOne',
              fontSize: isWideScreen
                  ? AppConstants.titleFontSizeDesktop
                  : AppConstants.titleFontSizeMobile,
              fontWeight: FontWeight.bold,
              color: context.appTextTitle,
            ),
          ),
        ),
      ),
    );
  }
}
