# API Architecture — Portal Layanan Publik Mobile

This document explains how API calls are structured in the app, how to add new features, and the conventions to follow. The architecture is based on **Clean Architecture** with `flutter_bloc` for state management, `dio` for networking, and `get_it` for dependency injection.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Layer Breakdown](#layer-breakdown)
3. [API Client Setup](#api-client-setup)
4. [Error Handling](#error-handling)
5. [Adding a New API Feature (Step-by-step)](#adding-a-new-api-feature)
6. [File Naming Conventions](#file-naming-conventions)
7. [API Endpoints Reference](#api-endpoints-reference)

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                 Presentation Layer                    │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐ │
│  │  Widget   │◄──│   BLoC   │──►│   Event / State  │ │
│  └──────────┘   └────┬─────┘   └──────────────────┘ │
│                      │                                │
├──────────────────────┼───────────────────────────────┤
│                 Domain Layer                          │
│  ┌──────────────┐   │   ┌───────────────────────┐   │
│  │    Entity     │◄──┼──►│  Repository (abstract) │   │
│  └──────────────┘   │   └───────────────────────┘   │
│                      │                                │
├──────────────────────┼───────────────────────────────┤
│                  Data Layer                           │
│  ┌──────────────┐   │   ┌───────────────────────┐   │
│  │    Model      │◄──┼──►│  Repository (impl)     │   │
│  │  (fromJson)   │   │   └───────────┬───────────┘   │
│  └──────────────┘   │               │               │
│                      │   ┌───────────▼───────────┐   │
│                      │   │  Remote Data Source    │   │
│                      │   └───────────┬───────────┘   │
│                      │               │               │
├──────────────────────┼───────────────┼───────────────┤
│                  Core Layer          │               │
│  ┌──────────────┐   ┌───────────────▼───────────┐   │
│  │  Failure      │   │      ApiClient (Dio)      │   │
│  │  hierarchy    │   └───────────────────────────┘   │
│  └──────────────┘                                    │
│  ┌──────────────────────────────────────────────┐   │
│  │         Injection Container (GetIt)           │   │
│  └──────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

---

## Layer Breakdown

### 1. Domain Layer (`domain/`)

Contains the **business logic contracts** — no framework dependencies.

| File                | Purpose                                             |
|---------------------|-----------------------------------------------------|
| `entities/*.dart`   | Pure data classes using `Equatable` for comparison.  |
| `repositories/*.dart` | Abstract interfaces defining what data operations are available. |

**Example Entity:**
```dart
class InformasiLayananEntity extends Equatable {
  final int id;
  final String judul;
  final String deskripsi;
  // ... more fields

  @override
  List<Object?> get props => [id, judul, deskripsi];
}
```

### 2. Data Layer (`data/`)

Implements the domain contracts and handles serialization / network access.

| File                        | Purpose                                                      |
|-----------------------------|--------------------------------------------------------------|
| `models/*.dart`             | Extends entity, adds `fromJson()` / `toJson()`.             |
| `datasources/*.dart`        | Direct API calls via `ApiClient`. Returns models.            |
| `repositories/*.dart`       | Implements domain repository. Catches errors, returns `(Success?, Failure?)`. |

**Key Pattern — Error Handling with Dart 3 Records:**
```dart
Future<(List<InformasiLayananEntity>?, Failure?)> getInformasiLayanan() async {
  try {
    final items = await _remoteDatasource.getInformasiLayanan();
    return (items.cast<InformasiLayananEntity>(), null); // success
  } on DioException catch (e) {
    return (null, ApiExceptions.fromDioError(e));          // failure
  }
}
```

### 3. Presentation Layer (`presentation/`)

Manages UI state with `flutter_bloc`.

| File                  | Purpose                                          |
|-----------------------|--------------------------------------------------|
| `bloc/*_bloc.dart`    | Orchestrates events → state transitions.         |
| `bloc/*_event.dart`   | User / system actions (e.g. `FetchInformasiLayanan`). |
| `bloc/*_state.dart`   | UI states: `initial`, `loading`, `loaded`, `error`. |

**BLoC Pattern:**
```dart
class InformasiLayananBloc extends Bloc<InformasiLayananEvent, InformasiLayananState> {
  final InformasiLayananRepository _repository;

  InformasiLayananBloc(this._repository) : super(const InformasiLayananState()) {
    on<FetchInformasiLayanan>(_onFetch);
  }

  Future<void> _onFetch(FetchInformasiLayanan event, Emitter emit) async {
    emit(state.copyWith(status: InformasiLayananStatus.loading));
    final (items, failure) = await _repository.getInformasiLayanan();
    if (failure != null) {
      emit(state.copyWith(status: InformasiLayananStatus.error, errorMessage: failure.message));
    } else {
      emit(state.copyWith(status: InformasiLayananStatus.loaded, items: items));
    }
  }
}
```

---

## API Client Setup

The app uses **named `ApiClient` instances** registered via `get_it`:

| Instance Name       | Base URL                              | Purpose                      |
|---------------------|---------------------------------------|------------------------------|
| *(default)*         | `https://jsonplaceholder.typicode.com` | Testing / placeholder API    |
| `PortalApiClient`   | `http://217.217.254.139:4002`         | Portal Layanan Publik API    |

**Retrieving the right client:**
```dart
// Default (JSONPlaceholder)
final testClient = getIt<ApiClient>();

// Portal API
final portalClient = getIt<ApiClient>(instanceName: 'PortalApiClient');
```

**`ApiClient` features:**
- Pre-configured Dio with timeouts, JSON headers
- Logging interceptor (prints request/response via `Logger`)
- Auth token interceptor placeholder (ready for Bearer token)
- Convenience methods: `get()`, `post()`, `put()`, `delete()`
- Runtime base URL override: `client.setBaseUrl('...')`

---

## Error Handling

### Failure Hierarchy

```
Failure (abstract)
├── ServerFailure    — HTTP errors (401, 403, 404, 500, etc.)
├── NetworkFailure   — Timeout, no internet
├── CacheFailure     — Local storage errors
└── ValidationFailure — 400 Bad Request
```

### DioException → Failure Mapping

`ApiExceptions.fromDioError(e)` maps Dio errors:

| DioExceptionType        | Failure Type      |
|-------------------------|-------------------|
| `connectionTimeout`     | `NetworkFailure`  |
| `sendTimeout`           | `NetworkFailure`  |
| `receiveTimeout`        | `NetworkFailure`  |
| `connectionError`       | `NetworkFailure`  |
| `badResponse` (4xx/5xx) | varies by status  |
| `cancel`                | `ServerFailure`   |
| `badCertificate`        | `ServerFailure`   |

---

## Adding a New API Feature

Follow these steps to add a new API endpoint to the app. We'll use `layanan` as an example.

### Step 1: Create the Entity

```
lib/features/layanan/domain/entities/layanan_entity.dart
```

```dart
import 'package:equatable/equatable.dart';

class LayananEntity extends Equatable {
  final int id;
  final String nama;
  // ... add fields from the Swagger schema

  const LayananEntity({required this.id, required this.nama});

  @override
  List<Object?> get props => [id, nama];
}
```

### Step 2: Create the Model

```
lib/features/layanan/data/models/layanan_model.dart
```

```dart
import '../../domain/entities/layanan_entity.dart';

class LayananModel extends LayananEntity {
  const LayananModel({required super.id, required super.nama});

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    return LayananModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
    );
  }
}
```

### Step 3: Create the Remote Data Source

```
lib/features/layanan/data/datasources/layanan_remote_datasource.dart
```

```dart
class LayananRemoteDatasource {
  final ApiClient _apiClient;
  LayananRemoteDatasource(this._apiClient);

  Future<List<LayananModel>> getLayanan() async {
    final response = await _apiClient.get('/publik/layanan');
    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data.map((json) => LayananModel.fromJson(json)).toList();
  }
}
```

### Step 4: Create the Repository Contract

```
lib/features/layanan/domain/repositories/layanan_repository.dart
```

```dart
abstract class LayananRepository {
  Future<(List<LayananEntity>?, Failure?)> getLayanan();
}
```

### Step 5: Create the Repository Implementation

```
lib/features/layanan/data/repositories/layanan_repository_impl.dart
```

### Step 6: Create BLoC (Event, State, Bloc)

```
lib/features/layanan/presentation/bloc/
├── layanan_bloc.dart
├── layanan_event.dart
└── layanan_state.dart
```

### Step 7: Register in `injection_container.dart`

Add in this order:
1. Data Source (using the appropriate `ApiClient` instance)
2. Repository
3. Bloc (as factory)

### Step 8: Wire to UI

Use `BlocProvider` at the widget level:
```dart
BlocProvider(
  create: (_) => getIt<LayananBloc>()..add(const FetchLayanan()),
  child: const LayananWidget(),
),
```

---

## File Naming Conventions

| Type            | Pattern                           | Example                              |
|-----------------|-----------------------------------|--------------------------------------|
| Entity          | `<feature>_entity.dart`           | `informasi_layanan_entity.dart`      |
| Model           | `<feature>_model.dart`            | `informasi_layanan_model.dart`       |
| Data Source      | `<feature>_remote_datasource.dart` | `informasi_layanan_remote_datasource.dart` |
| Repository      | `<feature>_repository.dart`       | `informasi_layanan_repository.dart`  |
| Repository Impl | `<feature>_repository_impl.dart`  | `informasi_layanan_repository_impl.dart`   |
| BLoC            | `<feature>_bloc.dart`             | `informasi_layanan_bloc.dart`        |
| Event           | `<feature>_event.dart`            | `informasi_layanan_event.dart`       |
| State           | `<feature>_state.dart`            | `informasi_layanan_state.dart`       |

### Directory Structure

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   └── <feature>_remote_datasource.dart
│   ├── models/
│   │   └── <feature>_model.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <feature>_entity.dart
│   └── repositories/
│       └── <feature>_repository.dart
└── presentation/
    └── bloc/
        ├── <feature>_bloc.dart
        ├── <feature>_event.dart
        └── <feature>_state.dart
```

---

## API Endpoints Reference

Base URL: `http://217.217.254.139:4002`

### Publik API (no auth required)

| Method | Endpoint                                      | Description                      |
|--------|-----------------------------------------------|----------------------------------|
| GET    | `/publik/informasi-layanan`                   | List informasi layanan (paginated) |
| GET    | `/publik/informasi-layanan/{id}`              | Get single informasi layanan     |
| GET    | `/publik/informasi-layanan/{id}/ulasan`       | Get reviews for informasi layanan |
| GET    | `/publik/informasi-layanan/{id}/ulasan/aggregasi` | Get review summary           |
| GET    | `/publik/faq`                                  | List FAQ                         |
| GET    | `/publik/faq/{id}`                             | Get single FAQ                   |
| GET    | `/publik/kategori-faq/preload`                 | Preload FAQ categories           |
| GET    | `/publik/kategori-layanan`                     | List service categories          |
| GET    | `/publik/kategori-layanan/preload`             | Preload service categories       |
| GET    | `/publik/kategori-informasi-layanan/preload`   | Preload info categories          |
| GET    | `/publik/layanan`                              | List services                    |
| GET    | `/publik/layanan/{id}`                         | Get single service               |

### Common Query Parameters

| Parameter    | Type    | Default | Description           |
|--------------|---------|---------|-----------------------|
| `page`       | int     | 1       | Page number           |
| `limit`      | int     | 5       | Items per page        |
| `pagination` | string  | "true"  | Enable pagination     |
| `q`          | string  | —       | Search keyword (judul)|

### Response Envelope (ProxyResponse)

All Publik API responses follow this structure:

```json
{
  "success": true,
  "code": 200,
  "message": "Berhasil",
  "data": [ ... ] // or { ... } for single item
}
```

---

## Quick Reference: Dependency Injection

```dart
// In injection_container.dart, register in this order:

// 1. ApiClient (named instance for Portal API)
getIt.registerLazySingleton<ApiClient>(() {
  final client = ApiClient();
  client.setBaseUrl('http://217.217.254.139:4002');
  return client;
}, instanceName: 'PortalApiClient');

// 2. Data Source
getIt.registerLazySingleton<MyRemoteDatasource>(
  () => MyRemoteDatasource(getIt<ApiClient>(instanceName: 'PortalApiClient')),
);

// 3. Repository
getIt.registerLazySingleton<MyRepository>(
  () => MyRepositoryImpl(getIt<MyRemoteDatasource>()),
);

// 4. BLoC (factory = new instance per screen)
getIt.registerFactory<MyBloc>(
  () => MyBloc(getIt<MyRepository>()),
);
```
