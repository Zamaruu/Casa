import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/extensions/datetime.extensions.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/user/data/provider/users_list_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_item.repository.dart';
import 'package:casa/src/features/user/widgets/user_selection_dialog.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:casa/src/widgets/base/primarybutton.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoEditDialog extends ConsumerStatefulWidget {
  /// The item to edit.
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
  DateTime? dueDate;
  String? assignedUserId;

  // region LifeCycle

  @override
  void initState() {
    super.initState();

    isLoading = false;

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    selectedPriority = widget.todo?.priority ?? ETodoPriority.medium;
    dueDate = widget.todo?.dueDate;
    assignedUserId = widget.todo?.assignedUserIds.firstOrNull;
    nameController.text = widget.todo?.title ?? '';
    descriptionController.text = widget.todo?.description ?? '';
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
        priority: selectedPriority,
        dueDate: dueDate,
        assignedUserIds: assignedUserId != null ? [assignedUserId!] : const [],
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

  Future<void> selectAssignee() async {
    final selectedUser = await ContextDialog.open(
      context,
      ContextDialog(
        title: 'Benutzer auswählen',
        content: UserSelectionDialog(
          selectedUserId: assignedUserId,
        ),
      ),
    );

    if (!mounted || selectedUser == null) {
      return;
    }

    setState(() {
      assignedUserId = selectedUser.id;
    });
  }

  Future<void> pickDueDate() async {
    final now = DateTime.now();
    final initialDate = dueDate ?? now;

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      initialDate: initialDate,
    );

    if (!mounted || date == null) {
      return;
    }

    final initialTime = TimeOfDay.fromDateTime(dueDate ?? now);
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (!mounted) {
      return;
    }

    if (time == null) {
      setState(() {
        dueDate = DateTime(date.year, date.month, date.day);
      });
      return;
    }

    setState(() {
      dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final selectedUser = usersAsync.asData?.value.value?.firstWhere(
      (user) => user.id == assignedUserId,
      orElse: () => User.initial(),
    );

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
            items: ETodoPriority.values
                .map(
                  (priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedPriority = value);
              }
            },
            decoration: const InputDecoration(labelText: 'Priorität'),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: pickDueDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fälligkeitsdatum',
                    ),
                    child: CasaText(
                      dueDate?.toDateTimeString() ?? '-',
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: dueDate != null
                    ? () => setState(() {
                        dueDate = null;
                      })
                    : null,
                icon: const Icon(Icons.clear),
                tooltip: 'Fälligkeitsdatum entfernen',
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CasaText(
                  assignedUserId == null
                      ? 'Keine Person zugewiesen'
                      : 'Zugewiesen: ${selectedUser != null && selectedUser.id.isNotEmpty ? selectedUser.username : assignedUserId}',
                ),
              ),
              TextButton.icon(
                onPressed: selectAssignee,
                icon: const Icon(Icons.person_search),
                label: const Text('Auswählen'),
              ),
              IconButton(
                onPressed: assignedUserId != null
                    ? () => setState(() {
                        assignedUserId = null;
                      })
                    : null,
                icon: const Icon(Icons.clear),
                tooltip: 'Zuweisung entfernen',
              ),
            ],
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
