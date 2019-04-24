package org.broadinstitute.ebola_care_guidelines;

import org.apache.commons.math3.analysis.function.Sigmoid;
import processing.core.PApplet;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class LogRegModel implements DataTypes {
  protected float intercept;
  protected float rangeScale;
  protected Sigmoid sigmoid;
  protected HashMap<String, ModelTerm> terms;
  protected String name;

  public LogRegModel(String name, InputStream modelIS, InputStream minmaxIS, int format) {
    this.name = name;
    intercept = 0;
    terms = new HashMap<String, ModelTerm>();
    sigmoid = new Sigmoid();

    if (format == MICE) {
      loadTermsMICE(modelIS);
    } else {
      loadTermsCSV(modelIS);
    }
    System.out.println(toString());

    loadRanges(minmaxIS);
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }

  public boolean matches(Set<String> vars) {
    Set<String> mvars = terms.keySet();
    return vars.containsAll(mvars) && mvars.containsAll(vars);
  }

  public boolean contains(Set<String> vars) {
    Set<String> mvars = terms.keySet();
    return mvars.containsAll(vars);
  }

  public boolean containedIn(Set<String> vars) {
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

  public List<Map.Entry<String, Float[]>> evalDetails(HashMap<String, Float> values) {
    HashMap<String, Float[]> map = new HashMap<String, Float[]>();
    for (String var: values.keySet()) {
      ModelTerm t = terms.get(var);
      if (t == null) continue;
      float value = values.get(var);
      float coeff0 = t.coeff(0);
      float contrib = t.eval(value);
      float scaledRange = PApplet.abs(t.max - t.min) / rangeScale;
      float scaledContrib = PApplet.min(PApplet.abs(contrib - t.min) / rangeScale, scaledRange);
      map.put(t.varName, new Float[]{value, contrib, scaledContrib, scaledRange, coeff0});
    }

    // Sorting the detailed contributions to the largest are first
    Set<Map.Entry<String, Float[]>> set = map.entrySet();
    List<Map.Entry<String, Float[]>> details = new ArrayList<Map.Entry<String, Float[]>>(set);
    Collections.sort(details, new Comparator<Map.Entry<String, Float[]>>() {
      public int compare(Map.Entry<String, Float[]> e1, Map.Entry<String, Float[]> e2) {
        if (e2.getValue()[2] < e1.getValue()[2]) return -1;
        else if (e2.getValue()[2] > e1.getValue()[2]) return +1;
        else return 0;
      }
    });

    return details;
  }

  private void loadTermsMICE(InputStream is) {
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

  private void loadTermsCSV(InputStream is) {
    ArrayList<Float> rcsCoeffs = new ArrayList<Float>();
    String varName = "";
    String[] lines = PApplet.loadStrings(is);

    int n = 1;
    while (n < lines.length) {
      String line = lines[n++];
      String[] row = line.split(",");
      String name = row[0].replace("\"", "");
      float value = PApplet.parseFloat(row[1].replace("\"", ""));
      String ttype = row[2].replace("\"", "");
      String tknot = row[3].replace("\"", "");
      if (name.equals("Intercept")) {
        setIntercept(value);
      } else {
        if (ttype.equals("linear")) {
          ModelTerm term = new LinearTerm(name, value);
          addTerm(term);
        } else if (ttype.contains("RCS")) {
          int coeffOrder = PApplet.parseInt(ttype.replace("RCS", ""));
          if (coeffOrder == 0) {
            rcsCoeffs.clear();
            rcsCoeffs.add(value);
            varName = name;
          } else {
            rcsCoeffs.add(value);
            String[] knotStr = tknot.split(" ");
            float[] rcsKnots = new float[knotStr.length];
            int rcsOrder = knotStr.length;
            for (int i = 0; i < rcsOrder; i++) {
              rcsKnots[i] = PApplet.parseFloat(knotStr[i]);
            }
            if (coeffOrder == rcsOrder - 2) {
              float[] rcsCoeffsArray = new float[rcsCoeffs.size()];
              for (int i = 0; i < rcsCoeffs.size(); i++) {
                rcsCoeffsArray[i] = rcsCoeffs.get(i);
              }
              RCSTerm term = new RCSTerm(varName, rcsOrder, rcsCoeffsArray, rcsKnots);
              addTerm(term);
            }
          }
        }
      }
    }
  }

  private void loadRanges(InputStream is) {
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
