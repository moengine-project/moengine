import 'package:flutter_test/flutter_test.dart';
import 'package:moengine/src/collection/collection.dart';

void main() {
  group('TypeMap', () {
    const types = [A, B, C, D, E, F, G, H, I, J, K, L, M, N];
    final TypeMapFactory factory = TypeMapFactory.fromTypes(types);
    final TypeMap typeMap = factory.newMap();
    test('puts', () {
      typeMap.puts([A(), E(), D(), F(), G()]);
      expect(typeMap.length, 5);
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
      expect(typeMap.length, 4);
    });
    test('contains', () {
      expect(typeMap.containsByTypes([D, E, G]), true);
      expect(typeMap.containsByTypes([D, F, A]), false);
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
