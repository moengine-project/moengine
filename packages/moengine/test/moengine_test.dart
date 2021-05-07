import 'package:flutter_test/flutter_test.dart';

import 'package:moengine/moengine.dart';

void main() {
  test('TypeMap test', () {
    int stringMask = TypeMap.registerType(String);
    int intMask = TypeMap.registerType(int);
    int doubleMask = TypeMap.registerType(double);
    int typeMapMask = TypeMap.registerType(TypeMap);

    TypeMap map = TypeMap();
    map.put(5);
    map.put(1.6);
    map.put('test');

    List<int> a=TypeMap.mergeMask([stringMask]);
    List<int> b=TypeMap.mergeMask([stringMask, intMask]);
    List<int> c=TypeMap.mergeMask([stringMask, intMask, typeMapMask]);
    List<int> d=TypeMap.mergeMask([typeMapMask]);
    List<int> e=TypeMap.mergeMask([doubleMask]);

    print(a.length);
    print(map.containsByMasks(a));
    print(b.length);
    print(map.containsByMasks(b));
    print(c.length);
    print(map.containsByMasks(c));
    print(d.length);
    print(map.containsByMasks(d));
    print(e.length);
    print(map.containsByMasks(e));
  });
}
