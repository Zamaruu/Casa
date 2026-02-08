import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/api/data/repositories/api.repository.dart';
import 'package:casa/src/widgets/base/primarybutton.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class ApiKeyEditDialog extends ConsumerStatefulWidget {
  /// The user to edit.
  /// If null, a new user will be created with and empty dialog.
  final IApiKey? user;

  const ApiKeyEditDialog({super.key, this.user});

  @override
  ConsumerState<ApiKeyEditDialog> createState() => _ApiKeyEditDialogState();
}

class _ApiKeyEditDialogState extends ConsumerState<ApiKeyEditDialog> {
  late bool isLoading;

  late final GlobalKey<FormState> formKey;

  late final TextEditingController nameController;

  late final TextEditingController descriptionController;

  late final TextEditingController expiresAtController;

  late DateTime? expiresAt;

  // region LifeCycle

  @override
  void initState() {
    super.initState();

    isLoading = false;
    formKey = GlobalKey<FormState>();

    nameController = TextEditingController();
    descriptionController = TextEditingController();
    expiresAtController = TextEditingController();
    expiresAt = null;
  }

  // endregion

  // region Methods

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void selectExpirationDate() async {
    final expirationDate = await showDatePicker(
      context: context,
      fieldLabelText: "Ablaufdatum auswählen",
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );

    if (expirationDate != null) {
      setState(() {
        expiresAt = expirationDate;
        expiresAtController.text = expirationDate.toString();
      });
    }
  }

  void save() async {
    if (formKey.currentState!.validate()) {
      setLoading(true);

      final apiKey = ApiKey(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        expiresAt: expiresAt,
      );

      final saveResponse = await ref.read(apiKeyRepositoryProvider).save(apiKey);

      if (mounted) {
        setLoading(false);

        if (saveResponse.isSuccess) {
          Navigator.of(context).pop(saveResponse);
        } else {
          CasaSnackbars.showDefaultSnackbar(
            message: saveResponse.message ?? 'Fehler beim Speichern des API-Schlüssels',
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
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name darf nicht leer sein';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Beschreibung',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: expiresAtController,
            decoration: InputDecoration(
              labelText: 'Ablaufdatum',
              suffixIconColor: context.theme.primaryColor,
              suffix: IconButton(
                onPressed: () => selectExpirationDate(),
                icon: Icon(Icons.edit_calendar),
              ),
            ),
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
