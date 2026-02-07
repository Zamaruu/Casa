import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/user/data/repositories/user.repository.dart';
import 'package:casa/src/widgets/base/primarybutton.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class UserEditDialog extends ConsumerStatefulWidget {
  /// The user to edit.
  /// If null, a new user will be created with and empty dialog.
  final IUser? user;

  const UserEditDialog({super.key, this.user});

  @override
  ConsumerState<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends ConsumerState<UserEditDialog> {
  late bool isLoading;

  late final GlobalKey<FormState> formKey;

  late final TextEditingController usernameController;

  late final TextEditingController emailController;

  late final TextEditingController passwordController;

  // region LifeCycle

  @override
  void initState() {
    super.initState();

    isLoading = false;
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // endregion

  // region Methods

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void save() async {
    if (formKey.currentState!.validate()) {
      setLoading(true);

      final user = User.create(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      final saveResponse = await ref.read(userRepositoryProvider).save(user);

      if (mounted) {
        setLoading(false);

        if (saveResponse.isSuccess) {
          Navigator.of(context).pop(saveResponse);
        } else {
          CasaSnackbars.showDefaultSnackbar(
            message: saveResponse.message ?? 'Fehler beim Speichern des Benutzers',
            context: context,
            type: ESnackbarType.error,
          );
        }
      }
    }
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Benutzername',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Benutzername darf nicht leer sein';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'E-Mail',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'E-Mail darf nicht leer sein';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Passwort',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Passwort darf nicht leer sein';
              }
              return null;
            },
          ),

          SizedBox(height: 32),

          PrimaryButton.icon(
            icon: Icons.save,
            onPressed: save,
            label: 'Speichern',
            loading: isLoading,
          ),
        ],
      ),
    );
  }
}
