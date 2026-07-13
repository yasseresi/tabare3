import '../models/counter_model.dart';

abstract class CounterLocalDataSource {
  Future<CounterModel> getLastCounter();
  Future<void> cacheCounter(CounterModel counterToCache);
}

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  int _cache = 0;

  @override
  Future<CounterModel> getLastCounter() {
    return Future.value(CounterModel(value: _cache));
  }

  @override
  Future<void> cacheCounter(CounterModel counterToCache) {
    _cache = counterToCache.value;
    return Future.value();
  }
}
