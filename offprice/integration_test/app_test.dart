import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offprice/main.dart' as app;
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('password');
  }

  group('end-to-end test', () {
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
    testWidgets('Login to the app and check "DEALS" Screen',
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
      await tester.enterText(password, "kubcio2");
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("HOT"), findsOneWidget);
      expect(find.byKey(const Key('Promotions')), findsOneWidget);
      await Future.delayed(const Duration(seconds: 5));
      expect(find.byKey(const Key('Single promotion list tile')), findsWidgets);

      final getMore = find.byKey(const Key('See all hot deals'));
      expect(getMore, findsOneWidget);
      await tester.tap(getMore);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));

      expect(find.byKey(const Key('Promotions')), findsOneWidget);
      expect(find.byKey(const Key('Single promotion list tile')), findsWidgets);
      final singlePromotion2 =
          find.byKey(const Key('Single promotion list tile')).first;

      await tester.tap(singlePromotion2);
      await tester.pumpAndSettle();

      final followButton = find.byKey(const Key('followButton'));
      expect(followButton, findsOneWidget);
      // final type = find.text('Follow');

      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(followButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(minutes: 5));

      // if (type.evaluate().isNotEmpty) {
      //   await tester.tap(followButton);
      //   await Future.delayed(const Duration(seconds: 10));
      //   expect(find.byKey(const Key('okButton')), findsOneWidget);
      //   await tester.tap(find.byKey(const Key('okButton')).first);
      //   await tester.pumpAndSettle();
      //   expect(find.text('Unfollow'), findsOneWidget);
      // } else {
      //   await tester.tap(followButton);
      //   // await tester.pumpAndSettle();
      //   await Future.delayed(const Duration(seconds: 10));
      //   expect(find.byKey(const Key('okButton')), findsOneWidget);
      //   await tester.tap(find.byKey(const Key('okButton')).first);
      //   await tester.pumpAndSettle();
      //   expect(find.text('Follow'), findsOneWidget);
      // }

      final addNewPromotionButton = find.byElementType(FloatingActionButton);

      expect(addNewPromotionButton, findsOneWidget);
      await tester.tap(addNewPromotionButton.first);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));

      expect(find.text('Choose product'), findsOneWidget);
      final product = find.byKey(const Key('Product list tile'));
      expect(product, findsOneWidget);
      await tester.tap(product.first);
      await tester.pumpAndSettle();

      expect(find.text('percentage'), findsOneWidget);

      final dropdownButton = find.byElementType(DropdownButton);
      expect(dropdownButton, findsOneWidget);
      await tester.tap(dropdownButton.first);
      await tester.pumpAndSettle();

      final cashItem = find.text('cash');
      expect(cashItem, findsOneWidget);
      await tester.tap(cashItem);
      await tester.pumpAndSettle();

      expect(find.text('percentage'), findsNothing);
      final dropdownButton2 = find.byElementType(DropdownButton);
      expect(dropdownButton2, findsOneWidget);
      await tester.tap(dropdownButton2.last);
      await tester.pumpAndSettle();

      final other = find.text('other');
      expect(other, findsOneWidget);
      await tester.tap(other);
      await tester.pumpAndSettle();

      final textField = find.byElementType(TextFieldDark);
      expect(textField, findsOneWidget);
      await tester.enterText(textField.first, "10");
      await tester.pumpAndSettle();

      final addButton = find.byElementType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton.first);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 4));

      final alertDialog = find.byElementType(AlertDialog);
      expect(alertDialog, findsOneWidget);
      await tester.tap(find.text('Ok').first);
      await tester.pumpAndSettle();

      expect(find.text('All deals'), findsOneWidget);
    });
  });
}
