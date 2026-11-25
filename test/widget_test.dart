import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cuaca_skylearn/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'Aplikasi CuacaSkylearn berhasil dimuat dan menampilkan kota default',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CuacaSkylearnApp());
    await tester.pumpAndSettle();

    // Memastikan header lokasi default (Purwokerto) tampil pada HomeScreen
    expect(find.text('Purwokerto'), findsOneWidget);
  });
}
