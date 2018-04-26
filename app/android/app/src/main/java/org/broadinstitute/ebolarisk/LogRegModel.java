package org.broadinstitute.ebolarisk;

import org.apache.commons.math3.analysis.function.Sigmoid;
import processing.core.PApplet;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Set;

public class LogRegModel {
  protected float intercept;
  protected float rangeScale;
  protected Sigmoid sigmoid;
  protected HashMap<String, ModelTerm> terms;

  public LogRegModel(InputStream modelIS, InputStream minmaxIS) {
    intercept = 0;
    terms = new HashMap<String, ModelTerm>();
    sigmoid = new Sigmoid();

    loadTerms(modelIS);
    loadMinMax(minmaxIS);
  }

  public boolean matches(Set<String> vars) {
    Set<String> mvars = terms.keySet();
    return vars.containsAll(mvars) && mvars.containsAll(vars);
  }

  public boolean contains(Set<String> vars) {
    Set<String> mvars = terms.keySet();
    return vars.containsAll(mvars);
  }

  void setIntercept(float b0) {
    intercept = b0;
  }

  void addTerm(ModelTerm term) {
    terms.put(term.varName, term);
  }

  public float eval(HashMap<String, Float> values) {
    return (float)sigmoid.value(evalScore(values));
  }

  public float evalScore(HashMap<String, Float> values) {
    float score = intercept;
    for (String var: values.keySet()) {
      ModelTerm t = terms.get(var);
      if (t == null) continue;
      score += t.eval(values.get(var));
    }
    return score;
  }

  public HashMap<String, Float[]> evalDetails(HashMap<String, Float> values) {
    HashMap<String, Float[]> details = new HashMap<String, Float[]>();
    for (String var: values.keySet()) {
      ModelTerm t = terms.get(var);
      if (t == null) continue;
      float value = values.get(var);
      float coeff0 = t.coeff(0);
      float contrib = t.eval(value);
      float scaledRange = PApplet.abs(t.max - t.min) / rangeScale;
      float scaledContrib = PApplet.min(PApplet.abs(contrib - t.min) / rangeScale, scaledRange);
      details.put(t.varName, new Float[]{value, contrib, scaledContrib, scaledRange, coeff0});
    }
    return details;
  }

  void loadTerms(InputStream is) {
    float[] rcsCoeffs = null;
    String[] lines = PApplet.loadStrings(is);

    int pos = lines[0].indexOf("est") + 2;

    int n = 1;
    while (true) {
      String line = lines[n++];
      String s = line.substring(0, pos).trim();
      String[] v = s.split(" ");
      if (v.length == 1) break;
      String valueStr = v[v.length - 1];
      float value = PApplet.parseFloat(valueStr);

      int pos0 = s.indexOf(valueStr);
      String varStr = s.substring(0, pos0).trim();

      if (varStr.indexOf("rcs") == 0) {
        int pos1 = varStr.lastIndexOf(")");
        String rcsString = varStr.substring(4, pos1);
        String[] pieces = rcsString.split("c");

        String[] part1 = pieces[0].split(",");
        String varName = part1[0].trim();
        int rcsOrder = PApplet.parseInt(part1[1].trim());
        String[] knotStr = pieces[1].replace("(", "").replace(")", "").split(",");
        float[] rcsKnots = new float[knotStr.length];
        for (int i = 0; i < knotStr.length; i++) {
          rcsKnots[i] = PApplet.parseFloat(knotStr[i]);
        }

        int coeffOrder = varStr.length() - varStr.replace("'", "").length();
        if (coeffOrder == 0) {
          rcsCoeffs = new float[rcsOrder - 1];
        }
        if (rcsCoeffs != null) rcsCoeffs[coeffOrder] = value;

        if (coeffOrder == rcsOrder - 2) {
          ModelTerm rcs = new RCSTerm(varName, rcsOrder, rcsCoeffs, rcsKnots);
          addTerm(rcs);
        }
      } else {
        if (varStr.equals("(Intercept)")) {
          setIntercept(value);
        } else {
          ModelTerm lin = new LinearTerm(varStr, value);
          addTerm(lin);
        }
      }
    }
  }

  void loadMinMax(InputStream is) {
    String[] lines = PApplet.loadStrings(is);
    rangeScale = 0;
    for (String line: lines) {
      String[] pieces = line.split(" ");
      String name = pieces[0];
      float min = PApplet.parseFloat(pieces[1]);
      float max = PApplet.parseFloat(pieces[2]);
      ModelTerm term = terms.get(name);
      if (term != null) {
        term.setMin(min);
        term.setMax(max);
        float f = PApplet.abs(max - min);
        if (rangeScale < f) rangeScale = f;
      }
    }
  }

  public String toString() {
    String res = "Intercept: " + intercept;
    for (ModelTerm term: terms.values()) {
      res += "\n" + term.toString();
    }
    return res;
  }

  class ModelTerm {
    String varName;
    float min, max;

    ModelTerm(String name) { varName = name; }
    float coeff(int i) { return 0; }
    float eval(float x) { return 0; }
    void setMin(float m) { min = m; }
    void setMax(float m) { max = m; }
  }

  class LinearTerm extends ModelTerm {
    float coeff;

    LinearTerm(String name, float c) {
      super(name);
      coeff = c;
    }
    float coeff(int i) { return coeff; }
    float eval(float x) {
      return coeff * x;
    }
    public String toString() {
      String res = "Linear term for " + varName + "\n";
      res += "  Coefficient: " + coeff;
      res += "\n  Minimum value: " + min;
      res += "\n  Maximum value: " + max;
      return res;
    }
  }

  class RCSTerm extends ModelTerm {
    int order;
    float[] coeffs;
    float[] knots;

    RCSTerm(String name, int k, float[] c, float[] kn) {
      super(name);
      order = k;
      coeffs = new float[k - 1];
      knots = new float[k];
      PApplet.arrayCopy(c, coeffs);
      PApplet.arrayCopy(kn, knots);
    }

    float cubic(float u) {
      float t = u > 0 ? u : 0;
      return t * t * t;
    }

    float rcs(float x, int term) {
      int k = order - 1;
      int j = term - 1;
      float[] t = knots;
      float c = (t[k] - t[0]) * (t[k] - t[0]);
      float value = +cubic(x - t[j])
                    -cubic(x - t[k - 1]) * (t[k] - t[j])/(t[k] - t[k-1])
                    +cubic(x - t[k]) * (t[k - 1] - t[j])/(t[k] - t[k-1]);
      return value / c;
    }

    float coeff(int i) {
      return coeffs[i];
    }

    float eval(float x) {
      float sum = coeffs[0] * x;
      for (int t = 1; t < order - 1; t++) {
        sum += coeffs[t] * rcs(x, t);
      }
      return sum;
    }

    public String toString() {
      String res = "RCS term of order " + order + " for " + varName + "\n";
      res += "  Coefficients:";
      for (int i = 0; i < coeffs.length; i++) {
        res += " " + coeffs[i];
      }
      res += "\n";
      res += "  Knots:";
      for (int i = 0; i < knots.length; i++) {
        res += " " + knots[i];
      }
      res += "\n  Minimum value: " + min;
      res += "\n  Maximum value: " + max;
      return res;
    }
  }
}
