/// 类型扩展
extension TypeExt on Type {
  /// 获取当前类型mask
  int? get mask => TypeMap.getMask(this);
}

/// 类型map,只能接受注册的类型
class TypeMap {
  /// 已注册type,最多960-16个
  static final Map<Type, int> _registeredMap = {};

  /// 当前存储类型对象
  final Map<Type, Object> _map = {};

  /// 当前存储对象mask
  final Map<int, int> _maskMap = {};

  /// 类型注册方法
  static int registerType<T>([Type? type]) {
    type ??= T;
    int? oldMask = _registeredMap[type];
    if (oldMask != null) {
      return oldMask;
    }
    if (_registeredMap.length > 960 - 16) {
      throw Exception('registeredMap.length < 944 == false !');
    }
    int index = _registeredMap.length ~/ 60;
    int bit = _registeredMap.length % 60;
    int mask = 1 << bit;
    mask |= (index << 59);
    _registeredMap[type] = mask;
    return mask;
  }

  /// 获取类型mask
  static int? getMask<T>([Type? type]) {
    type ??= T;
    return _registeredMap[type];
  }

  /// 合并mask
  static List<int> mergeMask(List<int> masks) {
    Map<int, int> maskMap = {};
    masks.forEach((mask) {
      int index = mask >> 59;
      int oldMask = maskMap[index] ?? 0;
      maskMap[index] = oldMask | mask;
    });
    return maskMap.values.toList();
  }

  /// 存放对象
  void put(Object value) {
    Type type = value.runtimeType;
    int? mask = _registeredMap[type];
    if (mask == null) {
      throw Exception('$type is unregistered!');
    }
    _map[type] = value;
    int index = mask >> 59;
    int oldMask = _maskMap[index] ?? 0;
    _maskMap[index] = oldMask | mask;
  }

  /// 获取对象
  T? get<T>([Type? type]) {
    type ??= T;
    return _map[type] as T?;
  }

  /// 查找是否包含
  bool contains(Type type) {
    return _map.containsKey(type);
  }

  /// 根据mask查找是否包含
  bool containsByMask(int mask) {
    int index = mask >> 59;
    int? localMask = _maskMap[index];
    if (localMask == null) {
      return false;
    }
    return localMask & mask == mask;
  }

  /// 根据mask列表查找是否包含
  bool containsByMasks(List<int> masks) {
    return masks.every((mask) => containsByMask(mask));
  }
}
