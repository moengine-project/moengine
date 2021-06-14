import 'package:flutter/foundation.dart';

/// 类型扩展
extension TypeExt on Type {
  /// 获取当前类型mask
  int? getTypeMask(TypeMapFactory factory) => factory.getMask(this);
}

/// index mask
const _indexMask = 0xf << 60;

/// bit mask
const _bitMask = ~_indexMask;

/// type map工厂
@immutable
class TypeMapFactory {
  /// 已注册type,最多960个
  final Map<Type, int> _registeredMap = {};

  TypeMapFactory();

  /// 使用初始的类型创建工厂
  TypeMapFactory.fromTypes(Iterable<Type> types) {
    for (final Type type in types) {
      registerType(type);
    }
  }

  /// 生成TypeMap对象
  TypeMap newMap() => TypeMap._new(this);

  /// 类型注册方法
  int registerType<T>([Type? type]) {
    final int? oldMask = getMask<T>(type);
    if (oldMask != null) {
      return oldMask;
    }
    if (_registeredMap.length > 960) {
      throw Exception('registeredMap.length < 960 == false !');
    }
    // 计算出当前类型属于的mask块
    final int index = _registeredMap.length ~/ 60;
    // 计算mask偏移位
    final int bit = _registeredMap.length % 60;
    final int mask = (1 << bit) | (index << 60);
    _registeredMap[type ?? T] = mask;
    return mask;
  }

  /// 获取类型mask
  int? getMask<T>([Type? type]) {
    return _registeredMap[type ?? T];
  }

  /// 获取类型mask列表
  Iterable<int> getMasks(Iterable<Type> types, [bool merge = true]) {
    List<int>? masks;
    Map<int, int>? maskMap;
    if (merge) {
      maskMap = {};
    } else {
      masks = [];
    }
    for (final Type type in types) {
      final int? mask = type.getTypeMask(this);
      if (mask == null) {
        throw Exception('$type is unregistered!');
      }
      if (masks != null) {
        masks.add(mask);
      } else if (maskMap != null) {
        final int index = mask >> 60;
        final int oldMask = maskMap[index] ?? 0;
        maskMap[index] = oldMask | mask;
      }
    }
    if (masks != null) {
      return masks;
    } else if (maskMap != null) {
      return maskMap.values;
    }
    return [];
  }

  /// 合并mask
  Iterable<int> mergeMasks(Iterable<int> masks) {
    final Map<int, int> maskMap = {};
    for (final int mask in masks) {
      final int index = mask >> 60;
      final int oldMask = maskMap[index] ?? 0;
      maskMap[index] = oldMask | mask;
    }
    return maskMap.values;
  }
}

/// 类型map,只能接受注册的类型
class TypeMap extends Iterable<Object> {
  /// 当前map所属工厂
  final TypeMapFactory factory;

  /// 当前存储类型对象
  final Map<Type, Object> _map = {};

  /// 当前存储对象mask
  final Map<int, int> _maskMap = {};

  @override
  Iterator<Object> get iterator => _map.values.iterator;

  TypeMap._new(this.factory);

  /// 存放对象
  void puts(Iterable<Object> values) {
    for (final Object value in values) {
      put(value);
    }
  }

  /// 存放对象
  void put(Object value) {
    final Type type = value.runtimeType;
    final int? mask = type.getTypeMask(factory);
    if (mask == null) {
      throw Exception('$type is unregistered!');
    }
    final int index = mask >> 60;
    final int oldMask = _maskMap[index] ?? 0;
    _map[type] = value;
    _maskMap[index] = oldMask | mask;
  }

  /// 获取对象
  T? get<T>([Type? type]) {
    return _map[type ?? T] as T?;
  }

  /// 移除对象
  T? remove<T>([Type? type]) {
    type ??= T;
    int? mask = type.getTypeMask(factory);
    if (mask == null) {
      return null;
    }
    final int index = mask >> 60;
    final int oldMask = _maskMap[index] ?? 0;
    mask &= _bitMask;
    final int newMask = oldMask & (~mask);
    _maskMap[index] = newMask;
    if (newMask == 0) {
      _maskMap.remove(index);
    }
    return _map.remove(type) as T?;
  }

  /// 查找是否包含
  bool containsByType(Type type) {
    return _map.containsKey(type);
  }

  /// 根据types查找是否包含
  bool containsByTypes(List<Type> types) {
    return containsByMasks(factory.getMasks(types));
  }

  /// 根据mask查找是否包含
  bool containsByMask(int mask) {
    final int index = mask >> 60;
    final int? localMask = _maskMap[index];
    if (localMask == null) {
      return false;
    }
    return localMask & mask == mask;
  }

  /// 根据mask列表查找是否包含
  bool containsByMasks(Iterable<int> masks) {
    return masks.every((mask) => containsByMask(mask));
  }
}
