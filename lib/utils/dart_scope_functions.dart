/// Kotlin-inspired scope functions implemented in Dart with the goal of
/// Extensions that can be used on any type [T].
extension ScopeFunctionExt<T> on T {
  /// Calls the specified function [block] with this value as its argument and
  /// returns `this` value.
  T also(void Function(T it) block) {
    block.call(this);
    return this;
  }

  /// Calls the specified function [block] with `this` value as its argument and
  /// returns its result.
  R let<R>(R Function(T it) block) {
    return block.call(this);
  }

  /// Returns `this` value if it satisfies the given [predicament] or null if
  /// it doesn't.
  T? takeIf(bool Function(T it) predicament) {
    return predicament.call(this) ? this : null;
  }

  /// Returns `this` value if it does not satisfy the given [predicament] or
  /// null if it does.
  T? takeUnless(bool Function(T it) predicament) {
    return predicament.call(this) ? null : this;
  }
}

/// Calls the specified function [block] and returns its result.
R run<R>(R Function() block) => block.call();
