class Scenarios {
  
  PVector GOOD_AND_CHEAP_BUT_NOT_FAST = new PVector( 1.0, 1.0, 0.0);
  PVector GOOD_AND_FAST_BUT_NOT_CHEAP = new PVector( 1.0, 0.0, 1.0);
  PVector CHEAP_AND_FAST_BUT_NOT_GOOD = new PVector( 0.0, 1.0, 1.0);
  PVector GOOD_AND_CHEAP_AND_FAST = new PVector( 1.0, 1.0, 1.0);
  
  PVector[] scenarios = {
    GOOD_AND_CHEAP_BUT_NOT_FAST,
    GOOD_AND_FAST_BUT_NOT_CHEAP,
    CHEAP_AND_FAST_BUT_NOT_GOOD,
    GOOD_AND_CHEAP_AND_FAST
  };
  
  int index;
  PVector current;
  
  Scenarios() {
    index = 0;
    updateCurrent();
  }

  void updateCurrent() {
    current = scenarios[ index];
  }

  Scenarios next() {
    index = (++index) % scenarios.length;
    updateCurrent();
    return this;
  }  

  Scenarios previous() {
    index = (--index + scenarios.length) % scenarios.length;
    updateCurrent();
    return this;
  }  
  
  PVector getScenario() {
    return current;
  }

  String getText() {
    String result = "";
    if( current.x >= 1.0) { result += "GOOD"; } else { result += "NOT GOOD"; }
    if( current.y >= 1.0) { result += ", CHEAP"; } else { result += ", NOT CHEAP"; }
    if( current.z >= 1.0) { result += ", FAST"; } else { result += ", NOT FAST"; }
    return result;
  }  
}
