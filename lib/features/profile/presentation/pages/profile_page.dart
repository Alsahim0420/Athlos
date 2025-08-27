import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_skeleton.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../../../core/controllers/theme_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            onPressed: () => _showThemeDialog(context),
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Cambiar tema',
          ),
        ],
      ),
      body: Obx(() {
        // Show skeleton while loading OR when no profile is available yet
        if (controller.isLoading.value || !controller.hasProfile) {
          return const ProfileSkeleton();
        }

        // Show error only when there's an error and we're not loading
        if (controller.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar perfil',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.error.value,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.reloadProfile(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        // Show profile content when available
        final profile = controller.userProfile.value!;
        return _buildProfileContent(profile, theme);
      }),
    );
  }

  Widget _buildProfileContent(UserProfileEntity profile, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(profile, theme),

          const SizedBox(height: 32),

          // Personal Information
          _buildSectionTitle('Información Personal', theme),
          const SizedBox(height: 16),

          _buildInfoCard([
            _buildInfoRow(
              'Nombre completo',
              profile.fullName,
              Icons.person,
              theme,
            ),
            _buildInfoRow('Email', profile.email, Icons.email, theme),
            _buildInfoRow('Teléfono', profile.phone, Icons.phone, theme),
            _buildInfoRow(
              'Género',
              profile.gender,
              Icons.person_outline,
              theme,
            ),
          ], theme),

          const SizedBox(height: 24),

          // Physical Information
          _buildSectionTitle('Información Física', theme),
          const SizedBox(height: 16),

          _buildInfoCard([
            _buildInfoRow('Edad', '${profile.age} años', Icons.cake, theme),
            _buildInfoRow(
              'Peso',
              '${profile.weight} kg',
              Icons.monitor_weight,
              theme,
            ),
            _buildInfoRow(
              'Estatura',
              '${profile.height} cm',
              Icons.height,
              theme,
            ),
            _buildInfoRow(
              'IMC',
              profile.bmi.toStringAsFixed(1),
              Icons.fitness_center,
              theme,
            ),
            _buildInfoRow(
              'Categoría IMC',
              profile.bmiCategory,
              Icons.analytics,
              theme,
            ),
          ], theme),

          const SizedBox(height: 32),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfileEntity profile, ThemeData theme) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              profile.firstName[0].toUpperCase(),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            profile.email,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar Tema',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...ThemeMode.values.map(
              (themeMode) => ListTile(
                leading: Icon(
                  themeController.getThemeIcon(themeMode),
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(themeController.getThemeName(themeMode)),
                trailing: Obx(
                  () => themeController.currentThemeMode.value == themeMode
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const SizedBox.shrink(),
                ),
                onTap: () {
                  themeController.changeTheme(themeMode);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
