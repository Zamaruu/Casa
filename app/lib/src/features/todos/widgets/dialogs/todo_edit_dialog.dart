import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/todos/data/repositories/todo_item.repository.dart';
import 'package:casa/src/widgets/base/primarybutton.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoEditDialog extends ConsumerStatefulWidget {
  /// The todolist to edit.
  /// If null, a new todolist will be created with and empty dialog.
  final ITodo? todo;

  final String todoListId;

  const TodoEditDialog({
    super.key,
    this.todo,
    required this.todoListId,
  });

  @override
  ConsumerState<TodoEditDialog> createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  late bool isLoading;

  late ETodoPriority selectedPriority;

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
    selectedPriority = ETodoPriority.medium;
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

      final todoList = Todo(
        title: nameController.text,
        description: descriptionController.text,
        createdByUserId: currentUser.id,
        listId: widget.todoListId,
      );

      final saveResponse = await ref.read(todoRepositoryProvider).save(todoList);

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

          DropdownButtonFormField<ETodoPriority>(
            initialValue: selectedPriority,
            items: ETodoPriority.values.map((priority) => DropdownMenuItem(value: priority, child: Text(priority.name))).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedPriority = value);
              }
            },
            decoration: const InputDecoration(labelText: 'Priorität'),
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
