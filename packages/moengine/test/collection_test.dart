import 'package:flutter_test/flutter_test.dart';
import 'package:moengine/src/collection/collection.dart';

void main() {
  group('TypeMap', () {
    const types = [A, B, C, D, E, F, G, H, I, J, K, L, M, N];
    final TypeMapFactory factory = TypeMapFactory.fromTypes(types);
    final TypeMap typeMap = factory.newMap();
    final objectsA = [H(), I(), J(), K(), L(), M(), N()];
    final typesA = [I, J, H, K, M, N, L];
    final masks = factory.getMasks(typesA);
    typeMap.puts(objectsA);
    test('puts', () {
      typeMap.puts([A(), E(), D(), F(), G()]);
      expect(typeMap.length, 12);
    });
    test('get', () {
      expect(typeMap.get<F>()?.runtimeType, F);
      expect(typeMap.get<D>()?.runtimeType, D);
      expect(typeMap.get<A>()?.runtimeType, A);
    });
    test('remove', () {
      typeMap.remove<F>();
      expect(typeMap.get<F>(), null);
      expect(typeMap.get<D>()?.runtimeType, D);
      expect(typeMap.length, 11);
    });
    test('contains', () {
      expect(typeMap.containsByTypes([D, E, G]), true);
      expect(typeMap.containsByTypes([D, F, A]), false);
    });
    group('containsAll', () {
      test('mask', () {
        expect(typeMap.containsByMasks(masks), true);
      });
      test('for', () {
        expect(typesA.every((type) => typeMap.containsByType(type)), true);
      });
      test('type', () {
        expect(typeMap.containsByTypes(typesA), true);
      });
    });
  });
}

/// 测试数据

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}

class H {}

class I {}

class J {}

class K {}

class L {}

class M {}

class N {}
