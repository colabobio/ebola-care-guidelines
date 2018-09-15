package org.broadinstitute.ebola_care_guidelines;

public class VarCondition {
  static public final int LESS_OR_EQUAL    = 1;
  static public final int GREATER_OR_EQUAL = 2;
  static public final int EQUAL            = 3;

  protected String variable;
  protected float value;
  protected int relation;

  public VarCondition(String var, float val, int rel) {
    this.variable = var;
    this.value = val;
    this.relation = rel;
  }

  public String getVariable() {
    return variable;
  }

  public void setValue(float val) {
    this.value = val;
  }

  public boolean holds(float val) {
    if (relation == LESS_OR_EQUAL) return val <= value;
    else if (relation == GREATER_OR_EQUAL) return value <= val;
    else return value <= val && val <= value;
  }
}
