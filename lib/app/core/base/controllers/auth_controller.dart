import 'package:get/get.dart';

import 'theme_controller.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async => this;

  final ThemeController themeController = Get.put(ThemeController());

  final RxBool isAuthenticated = false.obs;
  final RxBool isLogOut = false.obs;
  var user = <String, dynamic>{}.obs; // Observable map to store user data

  void refreshAuth() {
    isAuthenticated.refresh();
  }

  initAuth() async {
    isAuthenticated.value = true;
    // await validateAuth();
    // ever(isAuthenticated, (auth) => handleAuthChange());
  }

  bool initialAuthStateReceived = false;

  // Future<bool> validateAuth() async {
  //   fetchUserByUid();
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       if (initialAuthStateReceived) {
  //         print('User is currently signed out!');
  //       }
  //     } else {
  //       isAuthenticated(true);
  //       Get.offAllNamed(Routes.HOME);

  //       print('User is signed in!');
  //     }
  //     initialAuthStateReceived = true;
  //   });

  //   return isAuthenticated.value;
  // }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void fetchUserByUid() async {
  //   var uid = FirebaseAuth.instance.currentUser!.uid;
  //   try {
  //     // Query Firestore for the document with the matching UID
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('users')
  //         .where('id', isEqualTo: uid)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       // If a document is found, store the data
  //       user.value = snapshot.docs.first.data() as Map<String, dynamic>;
  //     } else {
  //       // If no document is found, clear the user data
  //       user.clear();
  //       print('No user found with the given UID.');
  //     }
  //   } catch (e) {
  //     print("Error fetching user: $e");
  //   }
  // }

  // void handleAuthChange() {
  //   if (isLogOut.value) {
  //     Get.offAllNamed(Routes.SIGNIN);
  //   } else {
  //     print("sffs ${Get.find<AuthController>().isAuthenticated.value}");

  //     AppRouteAccess.handleRedirect(Get.currentRoute, isAuthChange: true);
  //   }
  // }

  // var uuid = Uuid();
  // Future<void> createUser(data) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: data['email'],
  //       password: data['password'],
  //     );
  //     var userData = {
  //       "id": userCredential.user!.uid,
  //       "email": data['email'],
  //       "username": data['username'],
  //       "phone": data['phone'],
  //     };
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set(userData);
  //     isAuthenticated(true);
  //     Get.offAllNamed(Routes.SIGNIN);
  //   } catch (e) {
  //     showErrorMessage("Sign up Failed", e.toString());
  //   }
  // }

  // Future<void> reset(data) async {
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(
  //       email: data['email'],
  //     );

  //     isAuthenticated(true);

  //     Get.offAllNamed(Routes.SIGNIN);
  //   } catch (e) {
  //     showErrorMessage("Password reset failed", e.toString());
  //   }
  // }

  // Future<void> login(data) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: data['email'],
  //       password: data['password'],
  //     );

  //     isAuthenticated(true);

  //     Get.offAllNamed(Routes.ORDERS);
  //     fetchUserByUid();
  //   } catch (e) {
  //     showErrorMessage("Login Failed", e.toString());
  //   }
  // }

  // void showErrorMessage(String title, String message) {
  //   Get.defaultDialog(
  //     title: title,
  //     content: Text(message),
  //   );
  // }
}
