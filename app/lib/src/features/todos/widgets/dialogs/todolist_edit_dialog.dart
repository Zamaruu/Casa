import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/todos/data/repositories/todo_list.repository.dart';
import 'package:casa/src/widgets/base/primarybutton.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoListEditDialog extends ConsumerStatefulWidget {
  /// The todolist to edit.
  /// If null, a new todolist will be created with and empty dialog.
  final ITodoList? todoList;

  const TodoListEditDialog({super.key, this.todoList});

  @override
  ConsumerState<TodoListEditDialog> createState() => _TodoListEditDialogState();
}

class _TodoListEditDialogState extends ConsumerState<TodoListEditDialog> {
  late bool isLoading;

  late bool isShared;

  late final GlobalKey<FormState> formKey;

  late final TextEditingController nameController;

  late final TextEditingController descriptionController;

  // region LifeCycle

  @override
  void initState() {
    super.initState();

    isLoading = false;

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    isShared = false;
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

      final currentUser = ref.read(authUserProvider);

      final todoList = TodoList(
        name: nameController.text,
        description: descriptionController.text,
        ownerUserId: currentUser.id,
      );

      final saveResponse = await ref.read(todoListRepositoryProvider).save(todoList);

      if (mounted) {
        setLoading(false);

        if (saveResponse.isSuccess) {
          Navigator.of(context).pop(saveResponse);
        } else {
          CasaSnackbars.showDefaultSnackbar(
            message: saveResponse.message ?? 'Fehler beim Speichern der Todo-Liste',
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
              labelText: 'Listenname',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Listenname darf nicht leer sein';
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

          SwitchListTile(
            value: isShared,
            onChanged: (value) => setState(() => isShared = value),
            title: const Text('Geteilt'),
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
