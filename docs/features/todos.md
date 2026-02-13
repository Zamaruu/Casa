# Todos Feature (Planned)

This document defines the planned **Todos** feature from the roadmap in a way that is easy to read and directly usable as an implementation scaffold.

## 1. Goal

Todos should help families organize tasks in daily life with both personal and shared lists.

Primary outcomes:
- Create and manage multiple todo lists
- Support personal and family collaboration
- Assign ownership and responsibility
- Track due dates, priority, and status
- Attach files to tasks
- Notify users about relevant changes

## 2. Scope (Version 1.0)

In scope for the first release:
- Todo lists (personal + shared)
- Multiple lists per user/family
- Task assignment to one or more users
- Task lifecycle: `open`, `done`, `archived`
- Priority levels (low, medium, high)
- Optional due date
- Optional file attachments
- Notifications for create/update/due events

Out of scope for initial release (can be added later):
- Recurring tasks
- Comments/activity feed
- Rich text editor
- External calendar sync

## 3. Core User Stories

- As a user, I can create a private list for my own tasks.
- As a user, I can create a shared family list.
- As a user, I can add tasks with title, details, due date, and priority.
- As a user, I can assign tasks to family members.
- As a user, I can mark tasks done and archive old tasks.
- As a user, I get notified when tasks are created/changed/near due.

## 4. Domain Model (Proposed)

The existing `Todo` model in `shared/lib/src/models/todo/todo.model.dart` is a good start, but it currently only supports a single-owner todo style. For the roadmap scope, split model responsibilities into list-level and item-level entities.

### 4.1 Entities

- `TodoList`
  - `id`
  - `name`
  - `description`
  - `ownerUserId`
  - `memberUserIds` (who can access)
  - `isShared` (private vs family)
  - `createdAt`, `updatedAt`

- `TodoItem`
  - `id`
  - `listId`
  - `title`
  - `description`
  - `status` (`open`, `done`, `archived`)
  - `priority` (`low`, `medium`, `high`)
  - `dueDate` (optional)
  - `assignedUserIds`
  - `attachmentIds`
  - `createdByUserId`
  - `createdAt`, `updatedAt`

- `TodoAttachment`
  - `id`
  - `todoItemId`
  - `fileName`
  - `mimeType`
  - `sizeBytes`
  - `storagePath`
  - `uploadedByUserId`
  - `createdAt`

- `TodoNotificationEvent` (internal event model)
  - `id`
  - `type` (`created`, `updated`, `due_soon`, `due_today`, `overdue`)
  - `todoItemId`
  - `recipientUserIds`
  - `createdAt`

### 4.2 Enums

Add shared enums in `shared/lib/src/enums/`:
- `e_todo_status.dart`
- `e_todo_priority.dart`
- optional: `e_todo_notification_type.dart`

## 5. Permissions and Access Rules

Baseline rules:
- Only list members can read list tasks.
- Only list members can create tasks in that list.
- Task creator and list owner can edit any task.
- Assignees can update task status (`open` <-> `done`) but cannot delete list.
- Archive/unarchive allowed for list owner + creator.

Admin behavior:
- Admin can read all lists/tasks for support and moderation.
- Admin override should be explicit and auditable in logs.

## 6. API Design (Scaffold Contract)

Suggested REST contract under `/api/todos`.

### 6.1 Lists

- `GET /api/todos/lists`
- `POST /api/todos/lists`
- `GET /api/todos/lists/:listId`
- `PATCH /api/todos/lists/:listId`
- `DELETE /api/todos/lists/:listId`

### 6.2 Items

- `GET /api/todos/lists/:listId/items`
- `POST /api/todos/lists/:listId/items`
- `GET /api/todos/items/:itemId`
- `PATCH /api/todos/items/:itemId`
- `DELETE /api/todos/items/:itemId`
- `POST /api/todos/items/:itemId/complete`
- `POST /api/todos/items/:itemId/archive`

### 6.3 Attachments

- `POST /api/todos/items/:itemId/attachments`
- `GET /api/todos/items/:itemId/attachments`
- `DELETE /api/todos/attachments/:attachmentId`

### 6.4 Notifications

- Internal trigger via service/event pipeline
- Optional API endpoints later:
  - `GET /api/todos/notifications`
  - `PATCH /api/todos/notifications/:id/read`

## 7. App UX (Initial)

Routes:
- `/todos` list overview (all visible todo lists)
- `/todos/:listId` list detail (tasks by status)
- optional `/todos/:listId/item/:itemId` detail/edit

Main UI behaviors:
- Quick add task from list detail
- Tabs or filters by status (`Open`, `Done`, `Archived`)
- Inline status toggle for fast completion
- Assignment chips/user avatars on task tiles
- Due date and priority shown in compact format

## 8. Technical Scaffold Plan

This section is the implementation blueprint for creating the first scaffold.

### 8.1 Shared package (`shared/`)

Create:
- `shared/lib/src/models/todo/todo_list.model.dart`
- `shared/lib/src/models/todo/todo_item.model.dart`
- `shared/lib/src/models/todo/todo_attachment.model.dart`
- `shared/lib/src/enums/e_todo_status.dart`
- `shared/lib/src/enums/e_todo_priority.dart`
- export updates in:
  - `shared/lib/src/models/models.dart`
  - `shared/lib/src/enums/enums.dart`
  - `shared/lib/shared.dart`

Notes:
- Keep JSON-serializable model style consistent with existing `Todo` model.
- Keep existing `Todo` for compatibility until migration is completed.

### 8.2 API package (`api/`)

Create:
- controller:
  - `api/lib/src/controllers/todo.controller.dart`
- operations:
  - `api/lib/src/database/mongodb/todo.operations.dart`
- interfaces:
  - `shared/lib/src/interfaces/data/i_todo_operations.dart`
- service/repository registrations:
  - `api/lib/src/services/service_initializer.dart`
  - `api/lib/src/services/service_locator.dart`
- controller mount:
  - `api/lib/src/controllers/controller_builder.dart`

Scaffold behavior:
- Return typed response wrappers (`ValueResponse`, `MultiResponse`) like existing controllers.
- Start with list/items CRUD; add attachment and notification handlers after base flow is stable.

### 8.3 App package (`app/`)

Create feature module:
- `app/lib/src/features/todos/api/todo.api.dart`
- `app/lib/src/features/todos/data/interfaces/i_todo.api.dart`
- `app/lib/src/features/todos/data/repositories/todo.repository.dart`
- `app/lib/src/features/todos/data/repositories/todo.repo.dart`
- `app/lib/src/features/todos/data/provider/todo_lists_provider.dart`
- `app/lib/src/features/todos/data/provider/todo_items_provider.dart`
- `app/lib/src/features/todos/routes/todos.route.dart`
- `app/lib/src/features/todos/routes/todo_list.route.dart`
- `app/lib/src/features/todos/widgets/*`

Integrations:
- Register routes in `app/lib/src/core/router/casa_router.dart`
- Keep navigation entry in `app/lib/src/core/utils/menu.util.dart` (already contains `Todos`)

## 9. Delivery Milestones

### Milestone 1: Skeleton
- Shared models + enums created
- API controller wired with in-memory/mock responses
- App routes load with placeholder UI

### Milestone 2: Basic CRUD
- List CRUD works end-to-end
- Item CRUD works end-to-end
- Assignment + due date + priority stored and rendered

### Milestone 3: Collaboration
- Shared lists with member checks
- Permission rules enforced on API
- UI filters for assignee and status

### Milestone 4: Attachments + Notifications
- File upload/delete integrated
- Due-date notification jobs/events active
- Notification surface in app

## 10. Acceptance Criteria (v1.0)

- Users can create at least one personal and one shared list.
- Users can assign tasks to family members.
- Tasks support status, priority, due date, and optional attachments.
- Permission checks prevent non-members from accessing lists.
- Users receive notifications on creation, updates, and due events.
- Feature can be toggled through existing feature configuration (`EFeature.todos`).

## 11. Open Decisions

- Single assignee vs multiple assignees per task (recommended: multiple).
- Attachment storage backend strategy (filesystem vs object storage).
- Notification delivery channels (in-app only vs push/email).
- Whether to migrate old `Todo` model immediately or in a compatibility phase.

## 12. Suggested Next Step

Create the scaffold in Milestone 1 exactly as defined in Section 8, commit it as a dedicated baseline, then iterate feature depth milestone-by-milestone.
