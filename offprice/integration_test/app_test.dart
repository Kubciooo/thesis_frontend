import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offprice/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('password');
  }

  group(
    'end-to-end test',
    () {
      testWidgets('Should show alert dialog with wrong login and password',
          (WidgetTester tester) async {
        app.main();
        await clearSharedPreferences();

        await tester.pumpAndSettle();

        final login = find.byKey(const Key('Login'));
        final password = find.byKey(const Key('Password'));
        final loginButton = find.byKey(const Key('loginButton'));

        expect(login, findsOneWidget);
        expect(password, findsOneWidget);
        expect(loginButton, findsOneWidget);

        await tester.enterText(login, "k");
        await tester.enterText(password, "k");
        await tester.pumpAndSettle();

        await tester.tap(loginButton);
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 2));
        expect(find.text('Ok'), findsOneWidget);
      });
      testWidgets(
        'Login to the app and check "DEALS" Screen',
        (WidgetTester tester) async {
          app.main();
          await clearSharedPreferences();

          await tester.pumpAndSettle();

          final login = find.byKey(const Key('Login'));
          final password = find.byKey(const Key('Password'));
          final loginButton = find.byKey(const Key('loginButton'));

          expect(login, findsOneWidget);
          expect(password, findsOneWidget);
          expect(loginButton, findsOneWidget);

          await tester.enterText(login, "kubcio");
          await tester.enterText(password, "kubcio");
          await tester.pumpAndSettle();

          await tester.tap(loginButton);
          await tester.pumpAndSettle();
          expect(find.text("HOT"), findsOneWidget);
          expect(find.byKey(const Key('Promotions')), findsOneWidget);
          await Future.delayed(const Duration(seconds: 5));
          expect(find.byKey(const Key('Single promotion list tile')),
              findsWidgets);

          final getMore = find.byKey(const Key('See all hot deals'));
          expect(getMore, findsOneWidget);
          await tester.tap(getMore);
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 5));

          expect(find.byKey(const Key('Promotions')), findsOneWidget);
          expect(find.byKey(const Key('Single promotion list tile')),
              findsWidgets);
          final singlePromotion2 =
              find.byKey(const Key('Single promotion list tile')).first;

          await tester.tap(singlePromotion2);
          await tester.pumpAndSettle();

          final followButton = find.byKey(const Key('followButton'));
          expect(followButton, findsOneWidget);

          await tester.pumpAndSettle();
          final closePromotionButton = find.byKey(const Key('closeButton'));
          expect(closePromotionButton, findsOneWidget);

          await tester.tap(closePromotionButton);
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 5));

          final addNewPromotionButton = find.byKey(const Key('AddDeal'));

          expect(addNewPromotionButton, findsOneWidget);
          await tester.tap(addNewPromotionButton.first);
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 10));

          expect(find.text('Choose product'), findsOneWidget);
          final product = find.byKey(const Key('Product list tile'));
          expect(product, findsWidgets);
          await tester.tap(product.first);
          await tester.pumpAndSettle();

          expect(find.text('percentage'), findsOneWidget);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'Login to the app and check "PRODUCTS" Screen',
        (WidgetTester tester) async {
          app.main();
          await clearSharedPreferences();

          await tester.pumpAndSettle();

          final login = find.byKey(const Key('Login'));
          final password = find.byKey(const Key('Password'));
          final loginButton = find.byKey(const Key('loginButton'));

          expect(login, findsOneWidget);
          expect(password, findsOneWidget);
          expect(loginButton, findsOneWidget);

          await tester.enterText(login, "kubcio");
          await tester.enterText(password, "kubcio");
          await tester.pumpAndSettle();

          await tester.tap(loginButton);
          await tester.pumpAndSettle();
          expect(find.text("HOT"), findsOneWidget);
          expect(find.byKey(const Key('Promotions')), findsOneWidget);

          final secondKey = find.byKey(const Key('Main1'));
          expect(secondKey, findsOneWidget);
          await tester.tap(secondKey);
          await tester.pumpAndSettle();

          final showMore = find.byKey(const Key('See all products'));

          expect(showMore, findsOneWidget);
          await tester.tap(showMore);
          await tester.pumpAndSettle();
          await Future.delayed(
            const Duration(seconds: 5),
          );

          expect(find.text("All products"), findsOneWidget);

          final products = find.byKey(const Key('Product list tile'));
          expect(products, findsWidgets);

          await tester.tap(products.first);
          await tester.pumpAndSettle();

          expect(find.text("Product"), findsOneWidget);
        },
      );

      testWidgets(
        'Login to the app and check "FOLDERS" Screen',
        (WidgetTester tester) async {
          app.main();
          await clearSharedPreferences();

          await tester.pumpAndSettle();

          final login = find.byKey(const Key('Login'));
          final password = find.byKey(const Key('Password'));
          final loginButton = find.byKey(const Key('loginButton'));

          expect(login, findsOneWidget);
          expect(password, findsOneWidget);
          expect(loginButton, findsOneWidget);

          await tester.enterText(login, "kubcio");
          await tester.enterText(password, "kubcio");
          await tester.pumpAndSettle();

          await tester.tap(loginButton);
          await tester.pumpAndSettle();
          expect(find.text("HOT"), findsOneWidget);
          expect(find.byKey(const Key('Promotions')), findsOneWidget);

          final secondKey = find.byKey(const Key('Main2'));
          expect(secondKey, findsOneWidget);
          await tester.tap(secondKey);
          await tester.pumpAndSettle();

          final showMore = find.byKey(const Key('Show more folders'));

          expect(showMore, findsOneWidget);
          await tester.tap(showMore);
          await tester.pumpAndSettle();
          expect(find.text("All folders"), findsOneWidget);
          await Future.delayed(
            const Duration(seconds: 5),
          );

          final folders = find.byKey(const Key('folder item'));
          expect(folders, findsWidgets);

          await tester.tap(folders.first);
          await tester.pumpAndSettle();

          expect(find.text("Chosen folder"), findsOneWidget);

          final products = find.byKey(const Key('Product Card'));
          expect(products, findsWidgets);

          await tester.tap(products.first);
          await tester.pumpAndSettle();

          final openProductCard = find.byKey(const Key('Open product card'));
          expect(openProductCard, findsOneWidget);
          await tester.tap(openProductCard);
          await tester.pumpAndSettle();

          expect(find.text("Product"), findsOneWidget);
        },
      );
    },
  );
}
