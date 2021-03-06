package issues;

import tink.state.Scheduler;
import tink.state.internal.ObservableObject;
import tink.state.State;
import tink.state.Observable;


@:asserts
class Issue61 {
  public function new() {}

  public function test() {
    var first = true;
    final s = new State(7);

    final o = Observable.auto(() -> if (first) {
      first = false;
      s.value;
    } else 42);

    final o = Observable.auto(() -> o.value);

    function canFire()
      return (o:ObservableObject<Int>).canFire();

    final log = [];
    o.bind(v -> log.push(v), Scheduler.direct);
    asserts.assert(canFire());
    asserts.assert(canFire());
    s.set(123);
    asserts.assert(!canFire());
    asserts.assert(log.join(',') == '7,42');
    return asserts.done();
  }
}