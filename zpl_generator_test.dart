import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_print_pro/features/printing/data/zpl_generator.dart';

void main() {
  group('ZplGenerator', () {
    test('generateProductLabel creates valid ZPL', () {
      final zpl = ZplGenerator.generateProductLabel(
        productName: 'Test Product',
        price: '99.99',
        barcode: '123456789012',
        storeName: 'My Store',
        currency: 'SAR',
      );

      expect(zpl, contains('^XA'));
      expect(zpl, contains('^XZ'));
      expect(zpl, contains('Test Product'));
      expect(zpl, contains('99.99'));
      expect(zpl, contains('123456789012'));
      expect(zpl, contains('My Store'));
    });

    test('generatePriceTag creates valid ZPL', () {
      final zpl = ZplGenerator.generatePriceTag(
        price: '49.99',
        barcode: '987654321098',
        currency: 'USD',
      );

      expect(zpl, contains('^XA'));
      expect(zpl, contains('^XZ'));
      expect(zpl, contains('49.99'));
    });

    test('generateBatchLabel creates valid ZPL for multiple items', () {
      final items = [
        {'name': 'Item 1', 'price': '10.00', 'currency': 'SAR', 'barcode': '111'},
        {'name': 'Item 2', 'price': '20.00', 'currency': 'SAR', 'barcode': '222'},
      ];

      final zpl = ZplGenerator.generateBatchLabel(items: items);
      expect(zpl, contains('^XA'));
      expect(zpl, contains('^XZ'));
      expect(zpl, contains('Item 1'));
      expect(zpl, contains('Item 2'));
    });
  });
}