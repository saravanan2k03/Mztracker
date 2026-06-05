# Mztracker — Complete Refactor & Build Guide

> **What this document covers:**  
> A full walkthrough of every change made to the Mztracker Flutter project — why each decision was made, what problem it solved, and how the pieces fit together.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Phase 1 — Mock Data Refactor (Removing API Calls)](#2-phase-1--mock-data-refactor-removing-api-calls)
3. [Phase 2 — Dark / Light Theme System](#3-phase-2--dark--light-theme-system)
4. [Phase 3 — APK Build Fixes](#4-phase-3--apk-build-fixes)
5. [Final File Structure](#5-final-file-structure)
6. [Quick Reference — All Changes](#6-quick-reference--all-changes)

---

## 1. Project Overview

**Mztracker** is a Flutter task-management app built for the MZcet organization.  
Originally it called a live REST API at `http://103.207.1.94:8080` for everything:
login, task lists, team members, file uploads, push notifications, and version checks.

**The three goals of this refactor were:**

| Goal | Problem | Solution |
|---|---|---|
| Remove API dependency | App crashed without backend server | Replace all HTTP calls with an in-memory mock layer |
| Add dark/light mode | All colours were hardcoded global variables | Centralized `AppColors` + `AppTheme` + `ValueNotifier` toggle |
| Produce a working APK | Build failed due to Java 23 / Gradle 7.5 mismatch | Migrated Android build files to modern format |

---

## 2. Phase 1 — Mock Data Refactor (Removing API Calls)

### 2.1 Why the API calls had to go

The original codebase made `http.post()` calls inside `Timer.periodic()` every 3 seconds in almost every widget. With no backend running this meant:

- The app showed a `CircularProgressIndicator` forever (streams never received data).
- Every page had `try/catch` blocks printing errors to the console.
- It was impossible to develop or demo the app offline.

### 2.2 The architecture decision: Models + MockRepository

Instead of scattering fake `if (kDebugMode)` checks everywhere, the cleanest solution is a **single source of truth** for mock data — a `MockRepository` class with static methods that return data in exactly the same `Map<String, dynamic>` shape that the existing widgets already expect.

This meant:

1. Widget rendering code needed **zero changes** — it still reads `data["Task_Tittle"]`, `data["Deadline_date"]`, etc.
2. Only the data-fetching functions were swapped out.
3. All state mutations (complete task, add attachment, reassign) update the in-memory store so the UI reacts immediately.

### 2.3 New files created

#### `lib/models/task_model.dart`
```dart
class TaskModel {
  final String assignedId;
  final String taskTitle;
  final String description;
  final String deadlineDate;   // format: "DD-MM-YYYY"
  final String deadlineTime;
  final String categoryText;
  final double percentage;     // 0.0 – 1.0
  final String status;         // "Pending" | "Completed" | "Done late"
  final String assignedBy;     // employee ID
  final String assignedTo;     // employee ID

  Map<String, dynamic> toMap() => { ... }; // same keys as API used
}
```

**Why:** Typed fields catch bugs at compile time. `toMap()` lets the mock repository convert to the `Map<String, dynamic>` the widgets already parse.

#### `lib/models/user_model.dart`
```dart
class UserModel {
  final String employeeId;
  final String employeeName;
  final String profile;          // avatar URL
  final String department;       // "CSE" | "ECE" | "EEE" | "MECH" | "CIVIL"
  final String individualStatus; // "Pending" | "Completed"
  
  Map<String, dynamic> toMap() => { ... };
}
```

#### `lib/models/category_model.dart` and `lib/models/attachment_model.dart`
Same pattern — typed class with a `toMap()` converter.

#### `lib/data/mock_repository.dart` — the central data store

This is the most important new file. It holds:

```
MockRepository
├── users           Map<String, UserModel>   — 5 employees
├── categories      List<CategoryModel>       — 5 categories
├── _tasks          List<TaskModel>           — 6 tasks (3 pending, 2 completed, 1 done-late)
├── _assignments    Map<taskId, [{empId, status}]>
└── _attachments    Map<taskId, [AttachmentModel]>
```

**Public API methods** (what widgets call instead of `http.post`):

| Method | Replaces | Returns |
|---|---|---|
| `getTasks(empId, status)` | `POST /mainpage/taskdetails` | `List<Map>` |
| `getTaskDetails(taskId)` | `POST /details/taskdetails` | `[[{row}]]` |
| `getCompletedStatuses(taskId)` | `POST /details/StatusDetail` | `[[{status}]]` |
| `getTeamMemberDetails(taskId)` | `POST /details/teammember/{id}` | `[[{emp}]]` |
| `getTeamProfiles(taskIds)` | `POST /mainpage/teammember` | `[[{profile}]]` |
| `getAttachments(taskId)` | `POST /attach/Attachment` | `[{Filename}]` |
| `getCategoryMaps()` | `GET /getcategory` | `[{category}]` |
| `getStaffByDepartment(dept)` | `POST /getstaff_details` | `[{employee}]` |
| `createTask(...)` | `POST /addtask` | void (mutates `_tasks`) |
| `completeTask(id, status)` | `POST /details/Taskcompleted` | void |
| `addCategory(text)` | `POST /addcategory` | bool (false if duplicate) |
| `addAttachment(...)` | `POST /addattachment` | void |
| `deleteAttachment(...)` | `POST /attach/Attachmentdelete` | void |

**Why return raw `Map<String, dynamic>` instead of model objects?**  
Because the widgets already had `data["Task_Tittle"]`, `data["Deadline_date"]` etc. hardcoded throughout. Changing every access site would have been hundreds of edits with high risk of breaking the UI. Keeping the Map format meant only the data-source line changed in each file — one surgical cut per widget.

### 2.4 Mock data

**5 employees**

| ID | Name | Department |
|---|---|---|
| E001 | Saravanan | CSE (current logged-in user) |
| E002 | Kumar | CSE |
| E003 | Priya | ECE |
| E004 | Raj | EEE |
| E005 | Divya | CSE |

**6 tasks assigned to E001**

| ID | Title | Status | Deadline |
|---|---|---|---|
| 101 | Build Dashboard UI | Pending | 30-06-2026 |
| 102 | Fix Login Bug | Pending | 20-06-2026 |
| 103 | Write API Documentation | Pending | 15-07-2026 |
| 104 | Setup Database | Completed | 01-05-2026 |
| 105 | Design Logo | Completed | 05-05-2026 |
| 106 | Update Server Config | Done late | 15-04-2026 |

**5 categories:** Web Development, Mobile App, Database, UI/UX Design, Testing

**Attachments per task:**
- Task 101: `requirements.pdf`, `mockup.png`
- Task 102: `bug_report.pdf`
- Task 104: `db_schema.pdf`
- Task 105: `logo_v1.png`, `logo_v2.png`
- Task 106: `server_cfg.txt`

### 2.5 Files updated — HTTP calls removed

Every file that previously called `http.post()` or `http.get()` was updated:

#### `lib/main.dart`
**Before:** Called `OneSignal`, `GoogleSignIn.isSignedIn()`, `FileOperationdart.versionchecking()`, and `UploadNotificationId()` (all HTTP).  
**After:** Just writes mock user to `GetStorage` and sets `Loginsucess = true`, `versioncheck = true`. App always goes directly to `BottomnavbarPage`.

```dart
void main() async {
  await GetStorage.init();
  _initMockUser();   // writes E001 / "Saravanan" to box
  Loginsucess = true;
  versioncheck = true;
  runApp(MyApp());
}
```

#### `lib/api/google_signin_api.dart`
**Before:** Made `POST /login/LoginPage` to validate email, wrote employee ID to GetStorage.  
**After:** Stub — `login()` and `logout()` are no-ops; `GetInitialData()` just navigates to `BottomnavbarPage`.

```dart
class GoogleSignInApi {
  static Future<void> login() async {}
  static Future<void> logout() async {}
  static void GetInitialData(String email, BuildContext context) {
    Navigator.of(context).pushReplacement(...BottomnavbarPage());
  }
}
```

#### `lib/api/FileOperation.dart`
**Before:** Used `Dio` for downloads, `http.MultipartRequest` for uploads, HTTP for notifications and version check.  
**After:** All methods show `SnackBar` feedback; `fileUploadfunc` still opens the file picker but saves the filename to `MockRepository._attachments` instead of uploading; `Filedeleting` removes from the mock store.

#### `lib/functions/api_methods.dart`
**Before:** `send_dep()`, `get_category()`, `send_task()`, `send_attachment()` all made HTTP calls.  
**After:** Each delegates to `MockRepository`:
```dart
Future send_dep(var dep) async {
  userList = MockRepository.getStaffByDepartment(dep.toString());
}
Future get_category() async {
  final cats = MockRepository.getCategoryMaps();
  cat_list = ["- - Choose-Category - -", ...cats.map((c) => c["category_text"])];
  catid_list = cats.map((c) => c["category_id"] as int).toList();
}
```

#### `lib/functions/upload_file.dart`
**Before:** Used `http.MultipartRequest` to upload files.  
**After:** Shows EasyLoading spinner for 500ms then shows success toast.

#### `lib/views/LoginPage.dart`
**Before:** Called `GoogleSignInApi.login()` which triggered the real Google OAuth flow.  
**After:** A "Continue" button that goes straight to `BottomnavbarPage`. No Google SDK needed.

#### `lib/views/Profile.dart`
**Before:** Called `_googleSignIn.signOut()` on logout.  
**After:** Just navigates back to `LoginPage`. No Google SDK import.

#### All task-display widgets
`Taskcontainer`, `category`, `attachments`, `Teammember`, `TasktittleandIndicator`, `Status`, `PendingTask`, `Completed`, `DoneLate`, `TaskDetailed`, `Todoist`, `FileDownloadPage` — all replaced their `http.post()` body with a call to the appropriate `MockRepository` method. The `Timer.periodic()` loops were kept (they just re-read mock data every 5 seconds harmlessly).

### 2.6 Packages removed from pubspec.yaml

The following packages were removed because the code no longer uses them:

| Package | Why removed |
|---|---|
| `http` | All HTTP calls gone |
| `dio` | Used only for file downloads (now stubbed) |
| `onesignal_flutter` | Push notification code removed |
| `google_sign_in` | Google Sign-In replaced with a bypass |
| `permission_handler` | Storage permission request removed from `main.dart` |
| `open_file` | File-opening now shows a SnackBar instead |

---

## 3. Phase 2 — Dark / Light Theme System

### 3.1 The problem with global colour variables

The original code used three global `Color` variables declared in `variabels.dart`:

```dart
Color MainTextColor    = const Color.fromARGB(255, 255, 73, 60);  // red
Color Appbackgroundcolor = const Color.fromARGB(252, 255, 250, 250); // near-white
Color blackclr         = Colors.black;
```

These are read-at-declaration-time constants. Switching themes would require calling `setState()` everywhere simultaneously — impossible without a global rebuild mechanism.

### 3.2 Solution: AppColors + AppTheme + BuildContext extension

#### `lib/constant/app_theme.dart` — the single source of truth

```dart
class AppColors {
  final Color primary;        // accent/CTA colour
  final Color background;     // scaffold background
  final Color surface;        // card / container background
  final Color text;           // primary text
  final Color textMuted;      // hints, secondary text
  final Color shadow;         // box-shadow base
  final Color inputBorder;    // TextField border
  final Color navBackground;  // bottom nav bar background
  final Color navIndicator;   // selected nav chip

  static const light = AppColors(
    primary:       Color(0xFFFF4940),
    background:    Color(0xFFFFFAFA),
    surface:       Color(0xFFFFFFFF),
    text:          Color(0xFF1A1A1A),
    textMuted:     Color(0xFF757575),
    shadow:        Color(0xFFC2CBD0),
    inputBorder:   Color(0xFF1A1A1A),
    navBackground: Color(0xFFFFFFFF),
    navIndicator:  Color(0xFFFF8077),
  );

  static const dark = AppColors(
    primary:       Color(0xFFFF6B63),   // slightly lighter for dark bg
    background:    Color(0xFF121212),
    surface:       Color(0xFF1E1E1E),
    text:          Color(0xFFF0F0F0),
    textMuted:     Color(0xFFAAAAAA),
    shadow:        Color(0xFF000000),
    inputBorder:   Color(0xFFAAAAAA),
    navBackground: Color(0xFF1E1E1E),
    navIndicator:  Color(0xFFFF6B63),
  );
}
```

**Why `const`?**  
Both palettes are compile-time constants. Switching themes is a pointer swap, not a colour re-computation.

#### `AppTheme` factory

```dart
class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark  => _build(AppColors.dark,  Brightness.dark);

  static ThemeData _build(AppColors c, Brightness b) => ThemeData(
    brightness: b,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme(primary: c.primary, surface: c.surface, ...),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.navBackground,
      indicatorColor: c.navIndicator,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(...),
    ),
    // + appBar, inputDecoration, elevatedButton, FAB themes
  );
}
```

**Why put everything in ThemeData?**  
Flutter's widget tree already uses `Theme.of(context)` to resolve colours for built-in widgets (switches, buttons, text fields, navigation bars). By wiring our colours into `ThemeData`, every Material widget automatically themed — no manual colour override needed on each widget.

#### `BuildContext` extension

```dart
extension AppColorsExt on BuildContext {
  AppColors get appColors =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light;
}
```

**Why an extension?**  
Every widget's `build(BuildContext context)` method already has `context`. Adding `final colors = context.appColors;` at the top of `build` gives access to the full palette in one line with zero boilerplate. No `Provider`, no `InheritedWidget`, no `Consumer`.

#### Theme notifier in `variabels.dart`

```dart
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
```

**Why `ValueNotifier` instead of `setState`?**  
`ValueNotifier` is a lightweight observable. `ValueListenableBuilder` at the root of the widget tree listens to it and rebuilds `MaterialApp` when it changes — this propagates the new `ThemeData` to every widget instantly without needing `setState` anywhere except the toggle.

#### `main.dart` — wiring it all up

```dart
return ValueListenableBuilder<ThemeMode>(
  valueListenable: themeNotifier,
  builder: (context, mode, _) => MaterialApp(
    theme:      AppTheme.light,
    darkTheme:  AppTheme.dark,
    themeMode:  mode,           // Flutter picks light or dark based on this
    ...
  ),
);
```

### 3.3 How the toggle works (Profile page)

The **Dark Mode switch** in the Profile settings page directly writes to `themeNotifier`:

```dart
bool get _isDark => themeNotifier.value == ThemeMode.dark;

void _toggleTheme(bool value) {
  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
  setState(() {});  // rebuilds Profile page to flip the switch visually
}
```

The `ValueListenableBuilder` at the root catches the change and rebuilds `MaterialApp` — every screen switches theme simultaneously without page navigation.

### 3.4 How widgets use colours

Every widget's `build` method starts with:
```dart
final colors = context.appColors;
```

Then all hardcoded colour references are replaced:

| Old global variable | New token |
|---|---|
| `MainTextColor` | `colors.primary` |
| `Appbackgroundcolor` | `colors.background` |
| `blackclr` | `colors.text` |
| `primary` | `colors.primary` |
| `Colors.white` (for cards) | `colors.surface` |
| `Color.fromARGB(255, 194, 203, 207)` (shadow) | `colors.shadow` |

### 3.5 Files updated for theming

Every screen and widget was updated:

`MainPage`, `Taskcontainer`, `category`, `attachments`, `Teammember`, `Status`, `Taskdeadline`, `TasktittleandIndicator`, `Bottomnavbar`, `PendingTask`, `Completed`, `DoneLate`, `TaskDetailed`, `TaskStatus`, `Todoist`, `FileDownloadPage`, `EditProfile`, `Profile`

The `Bottomnavbar` was also upgraded from the old `curved_navigation_bar` package to Flutter's built-in `NavigationBar` (Material 3), which respects the `NavigationBarThemeData` we set in `AppTheme`.

---

## 4. Phase 3 — APK Build Fixes

### 4.1 Root cause: Java 23 + Gradle 7.5 incompatibility

```
BUG! exception in phase 'semantic analysis'
Unsupported class file major version 67
```

Java class file versions map like this:

| Java version | Class file version |
|---|---|
| Java 17 | 61 |
| Java 21 | 65 |
| Java 23 | **67** ← what the machine has |

Gradle 7.5 only supports up to Java 18 (class file 62). Java 23 → class file 67 → Gradle 7.5 crashes immediately before even reading the project.

**Why not downgrade Java instead?**  
Changing the system Java version is destructive and affects other projects. The correct fix is to upgrade the build toolchain to match the installed Java.

### 4.2 Migrating to the new Gradle format

The old project used the legacy `apply plugin:` / `buildscript {}` format from 2018-era Flutter. Modern AGP 8.x requires the `plugins {}` block format. Three files changed:

#### `android/gradle/wrapper/gradle-wrapper.properties`
```properties
# Before
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip

# After
distributionUrl=https\://services.gradle.org/distributions/gradle-8.11.1-all.zip
```

Gradle 8.11.1 is the first Gradle version that supports both Java 23 and AGP 8.9.x.

#### `android/settings.gradle`
```groovy
// Before (legacy apply from)
include ':app'
apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"

// After (new pluginManagement format)
pluginManagement {
    def flutterSdkPath = { ... }()
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.9.1" apply false
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false
}
include ":app"
```

**Why this format?**  
Flutter 3.13+ ships its own Gradle plugin (`dev.flutter.flutter-gradle-plugin`) in the SDK. The `includeBuild()` call tells Gradle where to find it. This is the officially supported format for Flutter 3.x with AGP 8.x.

#### `android/app/build.gradle`
```groovy
// Before (legacy apply)
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
android {
  compileSdkVersion 33
  compileOptions { sourceCompatibility JavaVersion.VERSION_1_8 }
}

// After (new plugins block)
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"  // replaces apply from flutter.gradle
}
android {
    namespace "com.example.mztrackertodo"   // REQUIRED in AGP 8.x
    compileSdk 36
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17  // Java 17 for Kotlin 2.x
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}
```

**Why Java 17 source compatibility?**  
Kotlin 2.1.0 requires the JVM target to be 8 or higher. Java 8 produces a deprecation warning ("source value 8 is obsolete"). Java 17 is the standard for modern Android development and avoids all these warnings.

**Why `namespace` is required in AGP 8.x?**  
AGP 8.0 removed the ability to read the package name from `AndroidManifest.xml`. Every library module must now declare a `namespace` in its `build.gradle`. Without it, AGP 8.x throws:
```
Namespace not specified. Specify a namespace in the module's build file.
```

#### `android/build.gradle` (root)
Simplified to just repositories and clean task — the AGP/Kotlin versions are now declared in `settings.gradle` using the `plugins {}` block.

#### `android/gradle.properties` (new file)
```properties
org.gradle.jvmargs=-Xmx4G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
```

`Jetifier` converts old `android.support.*` dependencies to `androidx.*` automatically, which is needed because some transitive dependencies still use the old support library.

### 4.3 Package upgrades required for AGP 8.x

AGP 8.x enforces namespace on **all** libraries — including third-party packages from pub.dev. Old package versions that pre-date AGP 8.x don't have `namespace` in their Android build files.

#### `file_picker 4.6.1` → `8.1.2`
```
A problem occurred configuring project ':file_picker'.
> Namespace not specified... file_picker-4.6.1/android/build.gradle
```
`file_picker` 5.0+ added namespace. API shape (`result.paths`, `result.files`) didn't change for our usage.

#### `image_picker: 0.8.7` → `1.1.2`
Both `image_picker` and the new AndroidX activity library require `compileSdk 36`. Upgraded alongside the AGP bump.

#### `path_provider_android` — pinned via override
```yaml
dependency_overrides:
  path_provider_android: ">=2.2.0 <2.3.0"
```
`path_provider_android 2.2.x` added namespace (fixes AGP 8.x), while `2.3.x` introduced JNI which requires the Android NDK to be installed. Pinning to `2.2.x` gets the namespace fix without the NDK requirement.

#### `get: 4.6.5` → `4.7.3` (pinned via override)
```yaml
dependency_overrides:
  get: ^4.7.3
```
`flutter_easyloading` depends on `get` internally. `get 4.6.5` used `theme.backgroundColor` which Flutter 3.x removed. `get 4.7.3` uses the replacement `colorScheme.surface`.

### 4.4 Other build file fixes

#### Two unused legacy files
`lib/functions/file_upload.dart` and `lib/utils/fileupload.dart` still imported `dio` and `permission_handler` which were removed from `pubspec.yaml`. Both were stubbed to simple no-op implementations.

#### `avatar_glow` API change (2.x → 3.x)
```dart
// Before (avatar_glow 2.x)
AvatarGlow(endRadius: 70, glowColor: colors.primary, ...)

// After (avatar_glow 3.x — endRadius removed)
AvatarGlow(glowRadiusFactor: 0.3, glowColor: colors.primary, ...)
```
`glowRadiusFactor` is a multiplier of the child widget's size (0.3 = 30% bigger than the avatar).

#### Kotlin incremental cache warning
The build emits a long `IllegalArgumentException: this and base files have different roots` stack trace. This is a known cosmetic issue in Kotlin 2.x's incremental compiler when the pub cache (`C:\`) and the project (`D:\`) are on different drive letters. It does **not** prevent compilation — the APK is produced successfully.

### 4.5 Final build command

```bash
flutter build apk --debug
```

**Why `--debug` and not release?**  
The project had a `signingConfigs.debug` block referencing a `upload-keystore1.jks` file that does not exist in the repository. A release APK requires a valid signing keystore. `--debug` uses Flutter's automatically-generated debug keystore (`~/.android/debug.keystore`), which always exists.

To produce a proper release APK in the future, generate a keystore:
```bash
keytool -genkey -v -keystore release.jks -alias release -keyalg RSA -keysize 2048 -validity 10000
```
Then add it to `app/build.gradle`:
```groovy
signingConfigs {
    release {
        storeFile file("release.jks")
        storePassword "your-password"
        keyAlias "release"
        keyPassword "your-password"
    }
}
buildTypes {
    release { signingConfig signingConfigs.release }
}
```

---

## 5. Final File Structure

```
lib/
├── constant/
│   ├── app_theme.dart          ← NEW: AppColors, AppTheme, context.appColors extension
│   └── Textcolor.dart          (legacy, superseded)
│
├── models/                     ← NEW directory
│   ├── task_model.dart
│   ├── user_model.dart
│   ├── category_model.dart
│   └── attachment_model.dart
│
├── data/                       ← NEW directory
│   └── mock_repository.dart    ← central mock data + all query methods
│
├── functions/
│   ├── variabels.dart          ← added themeNotifier; colours made const
│   ├── api_methods.dart        ← all HTTP replaced with MockRepository calls
│   ├── upload_file.dart        ← stubbed (was Dio multipart upload)
│   └── file_upload.dart        ← stubbed (was Dio download)
│
├── api/
│   ├── google_signin_api.dart  ← stubbed (no Google SDK calls)
│   └── FileOperation.dart      ← stubbed (shows SnackBars, writes to MockRepository)
│
├── utils/
│   ├── Bottomnavbar.dart       ← upgraded to Material NavigationBar with theme colours
│   ├── Taskcontainer.dart      ← mock data + context.appColors
│   ├── category.dart           ← mock data + context.appColors
│   ├── attachments.dart        ← mock data + context.appColors
│   ├── Teammember.dart         ← mock data + context.appColors
│   ├── TasktittleandIndicator.dart ← removed API call, context.appColors
│   ├── Status.dart             ← context.appColors
│   ├── Taskdeadline.dart       ← context.appColors
│   └── fileupload.dart         ← stubbed
│
├── views/
│   ├── LoginPage.dart          ← bypass Google Sign-In
│   ├── Profile.dart            ← Dark Mode toggle wired to themeNotifier
│   ├── EditProfile.dart        ← context.appColors, avatar_glow 3.x API
│   ├── TaskDetailed.dart       ← mock data + context.appColors
│   ├── TaskStatus.dart         ← context.appColors
│   ├── Todoist.dart            ← mock data + context.appColors
│   ├── FileDownloadPage.dart   ← mock data + context.appColors
│   └── splashscreen.dart       (unchanged)
│
├── widgets/
│   ├── PendingTask.dart        ← mock data + context.appColors
│   ├── Completed.dart          ← mock data + context.appColors
│   └── DoneLate.dart           ← mock data + context.appColors
│
└── main.dart                   ← ValueListenableBuilder, mock user init, no OneSignal

android/
├── gradle/wrapper/
│   └── gradle-wrapper.properties   ← Gradle 7.5 → 8.11.1
├── settings.gradle                 ← legacy apply from → pluginManagement / plugins {}
├── build.gradle                    ← simplified root (removed buildscript block)
├── gradle.properties               ← NEW: JVM args, AndroidX, Jetifier
└── app/
    └── build.gradle                ← plugins {}, namespace, compileSdk 36, Java 17

pubspec.yaml
├── sdk constraint: ">=2.18.0 <3.0.0" → ">=3.0.0 <4.0.0"
├── REMOVED: dio, http, onesignal_flutter, google_sign_in,
│           open_file, permission_handler
├── UPGRADED: file_picker ^4→^8, image_picker ^0.8→^1, lottie ^2→^3,
│            google_fonts ^4→^6, avatar_glow ^2→^3
└── dependency_overrides:
    ├── path_provider_android: ">=2.2.0 <2.3.0"  (namespace yes, NDK no)
    └── get: ^4.7.3  (fixes removed ThemeData.backgroundColor)
```

---

## 6. Quick Reference — All Changes

### Build toolchain upgrades

| Component | Before | After | Why |
|---|---|---|---|
| Gradle | 7.5 | 8.11.1 | Java 23 support (class file 67) |
| AGP | 7.2.0 | 8.9.1 | Supports Gradle 8.11.x |
| Kotlin | 1.7.10 | 2.1.0 | Required by AGP 8.9.x |
| compileSdk | 33 | 36 | Required by `image_picker_android` |
| Java target | 1.8 | 17 | Eliminates deprecation warnings |
| build.gradle format | `apply plugin:` | `plugins {}` | Required by AGP 8.x |

### Package changes

| Package | Before | After | Reason |
|---|---|---|---|
| `file_picker` | 4.6.1 | 8.1.2 | Namespace for AGP 8.x |
| `image_picker` | 0.8.7 | 1.1.2 | Namespace + compileSdk 36 |
| `lottie` | 2.3.0 | 3.1.0 | Dart 3 compatibility |
| `google_fonts` | 4.0.3 | 6.2.1 | Dart 3 compatibility |
| `avatar_glow` | 2.0.2 | 3.0.1 | Dart 3 compatibility |
| `flutter_lints` | 2.0.0 | 4.0.0 | Dart 3 lint rules |
| `dio` | 5.0.2 | **removed** | All API calls gone |
| `http` | 0.13.5 | **removed** | All API calls gone |
| `onesignal_flutter` | 3.5.1 | **removed** | Push notifications removed |
| `google_sign_in` | 5.4.4 | **removed** | Auth bypassed |
| `permission_handler` | 9.2.0 | **removed** | No longer needed |
| `open_file` | 3.2.1 | **removed** | Replaced with SnackBar stub |

### Dependency overrides applied

```yaml
dependency_overrides:
  path_provider_android: ">=2.2.0 <2.3.0"
  get: ^4.7.3
```

`path_provider_android` — version 2.2.x has namespace (fixes AGP 8.x) but doesn't use JNI (avoids NDK requirement). Version 2.3.x added JNI which requires NDK 27 to be installed.

`get` — 4.6.5 called `ThemeData.backgroundColor` which was removed in Flutter 3.x. 4.7.3 uses `colorScheme.surface` as the replacement.

---

*Generated from the Mztracker refactor session — June 2026*
