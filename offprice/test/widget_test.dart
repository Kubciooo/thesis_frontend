// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:offprice/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('end-to-end test', () {
//     testWidgets('Login to the App', (WidgetTester tester) async {
//       app.main();
//       await tester.pumpAndSettle();

//       // // Verify the counter starts at 0.
//       // expect(find.text('0'), findsOneWidget);

//       // // Finds the floating action button to tap on.
//       // final Finder fab = find.byTooltip('Increment');

//       // // Emulate a tap on the floating action button.
//       // await tester.tap(fab);

//       // // Trigger a frame.
//       // await tester.pumpAndSettle();

//       // // Verify the counter increments by 1.
//       // expect(find.text('1'), findsOneWidget);
//     });
//   });
// }


// // void main() {
// //   Widget createWidgetForTesting({required Widget child}) {
// //     return MaterialApp(
// //       home: MediaQuery(
// //           data: const MediaQueryData(size: Size(5000, 640)), child: child),
// //     );
// //   }

// //   testWidgets('Open login button', (WidgetTester tester) async {
// //     // Build our app and trigger a frame.
// //     await tester.pumpWidget(MultiProvider(providers: [
// //       ChangeNotifierProvider(
// //         create: (context) => AuthProvider(),
// //       ),
// //       ChangeNotifierProxyProvider<AuthProvider, PromotionsProvider>(
// //         create: (context) => PromotionsProvider(),
// //         update: (context, auth, promotions) => promotions!..update(auth),
// //       ),
// //       ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
// //         create: (context) => ProductsProvider(),
// //         update: (context, auth, products) => products!..update(auth),
// //       ),
// //       ChangeNotifierProxyProvider<AuthProvider, FoldersProvider>(
// //         create: (context) => FoldersProvider(),
// //         update: (context, auth, folders) => folders!..update(auth),
// //       ),
// //     ], child: createWidgetForTesting(child: const LoginScreen())));
// //     expect(find.text('Login'), findsNWidgets(2));
// //   });
// // }
