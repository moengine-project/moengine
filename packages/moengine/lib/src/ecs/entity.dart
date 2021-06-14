import 'package:moengine/moengine.dart';

import 'component.dart';

/// 实体
class Entity {
  /// 实体id
  final int id;

  /// 组件集合
  // final TypeMap _components = TypeMap();

  Entity._create(this.id, Iterable<Component>? components) {
    if (components != null) {
      // _components.puts(components);
    }
  }
}

/// 实体管理器
class EntityManager {
  /// 临时id
  int _nowId = 0;

  /// 创建实体,并自动分配id
  /// 创建时可以预分配[components]作为实体初始的组件
  Entity create([Iterable<Component>? components]) {
    return Entity._create(_nowId++, components);
  }
}
