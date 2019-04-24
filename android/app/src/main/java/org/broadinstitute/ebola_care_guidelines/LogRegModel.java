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
  protected HashMap<String, ProductTerm> pterms; // Product (interaction terms) terms
  protected String name;

  public LogRegModel(String name, InputStream modelIS, InputStream minmaxIS) {
    this.name = name;
    intercept = 0;
    terms = new HashMap<String, ModelTerm>();
    pterms = new HashMap<String, ProductTerm>();
    sigmoid = new Sigmoid();

    loadTermsCSV(modelIS);
    loadRanges(minmaxIS);
    System.out.println(toString());
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }

//  public boolean matches(Set<String> vars) {
//    Set<String> mvars = terms.keySet();
//    return vars.containsAll(mvars) && mvars.containsAll(vars);
//  }
//
//  public boolean contains(Set<String> vars) {
//    Set<String> mvars = terms.keySet();
//    return mvars.containsAll(vars);
//  }

  public boolean containedIn(Set<String> vars) {
    Set<String> mvars = terms.keySet();
//    boolean res = vars.containsAll(mvars);
//    PApplet.println("=============> ", name, res);
//    PApplet.print("MODEL: "); PApplet.println(mvars.toArray());
//    PApplet.print("DATA : "); PApplet.println(vars.toArray());
    return vars.containsAll(mvars);
  }

  void setIntercept(float b0) {
    intercept = b0;
  }

  void addTerm(ModelTerm term) {
    terms.put(term.name, term);
  }

  void addProductTerm(ProductTerm term) {
    pterms.put(term.name, term);
  }

  public float eval(HashMap<String, Float> values) {
    return (float)sigmoid.value(evalScore(values));
  }

  public float evalScore(HashMap<String, Float> values) {
    float score = intercept;

    for (ModelTerm t: terms.values()) {
      String var = t.name;
      if (values.containsKey(var)) {
        score += t.eval(values.get(var));
      }
    }

//    for (String var: values.keySet()) {
//      ModelTerm t = terms.get(var);
//      if (t == null) continue;
//      score += t.eval(values.get(var));
//    }

    for (ProductTerm t: pterms.values()) {
      String var1 = t.name1;
      String var2 = t.name2;
      if (values.containsKey(var1) && values.containsKey(var2)) {
        score += t.eval(values.get(var1) * values.get(var2));
      }
    }

    return score;
  }

  public List<Map.Entry<String, Float[]>> evalDetails(HashMap<String, Float> values) {
    HashMap<String, Float[]> map = new HashMap<String, Float[]>();

    for (ModelTerm t: terms.values()) {
      String var = t.name;
      if (values.containsKey(var)) {
        String var0 = "$" + var;
        float value = values.get(var);
        float value0 = value;
        if (values.containsKey(var0)) {
          // This variable is the result of a equation transformation, retrieving the original value for display purposes
          value0 = values.get(var0);
        }
        map.put(t.name, t.contrib(value, value0));
      }
    }

//    for (String var: values.keySet()) {
//      ModelTerm t = terms.get(var);
//      if (t == null) continue;
//      float value = values.get(var);
//      float coeff0 = t.coeff(0);
//      float contrib = t.eval(value);
//      float scaledRange = PApplet.abs(t.max - t.min) / rangeScale;
//      float scaledContrib = PApplet.min(PApplet.abs(contrib - t.min) / rangeScale, scaledRange);
//      map.put(t.name, t.test(value));
//    }

    for (ProductTerm t: pterms.values()) {
      String var1 = t.name1;
      String var2 = t.name2;
      String var10 = "$" + var1;
      String var20 = "$" + var2;
      if (values.containsKey(var1) && values.containsKey(var2)) {
        float value1 = values.get(var1);
        float value10 = value1;
        if (values.containsKey(var10)) value10 = values.get(var10);

        float value2 = values.get(var2);
        float value20 = value2;
        if (values.containsKey(var20)) value20 = values.get(var20);

        float value = value1 * value2;
        float value0 = value10 * value20;

        map.put(t.name, t.contrib(value, value0));
      }
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
        } else if (ttype.contains("product")) {
          String[] names = name.split("\\*");
          String v1 = names[0].trim();
          String v2 = names[1].trim();
          ProductTerm term = new ProductTerm(v1, v2, value);
          addProductTerm(term);
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
      String[] namval = line.split("=");
      String name = namval[0];
      String values = namval[1];
      String[] minmax = values.split(",");
      float min = PApplet.parseFloat(minmax[0]);
      float max = PApplet.parseFloat(minmax[1]);
      ModelTerm term = terms.get(name);
      if (term != null) {
        term.setMin(min);
        term.setMax(max);
        float f = PApplet.abs(max - min);
        if (rangeScale < f) rangeScale = f;
      } else {
        term = pterms.get(name);
        if (term != null) {
          term.setMin(min);
          term.setMax(max);
          float f = PApplet.abs(max - min);
          if (rangeScale < f) rangeScale = f;
        }
      }
    }
  }

  public String toString() {
    String res = "Intercept: " + intercept;
    for (ModelTerm term: terms.values()) {
      res += "\n" + term.toString();
    }
    for (ProductTerm term: pterms.values()) {
      res += "\n" + term.toString();
    }
    return res;
  }

  class ModelTerm {
    String name;
    float min, max;

    ModelTerm(String name) { this.name = name; }
    float coeff(int i) { return 0; }
    float eval(float x) { return 0; }
    void setMin(float m) { min = m; }
    void setMax(float m) { max = m; }
    Float[] contrib(float value, float value0) {
      float coeff0 = coeff(0);
      float contrib = eval(value);
      float scaledRange = PApplet.abs(max - min) / rangeScale;
      float scaledContrib = PApplet.min(PApplet.abs(contrib - min) / rangeScale, scaledRange);
      return new Float[]{value0, contrib, scaledContrib, scaledRange, coeff0};
    }
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
      String res = "Linear term for " + name + "\n";
      res += "  Coefficient: " + coeff;
      res += "\n  Minimum value: " + min;
      res += "\n  Maximum value: " + max;
      return res;
    }
  }

  class ProductTerm extends LinearTerm {
    String name1;
    String name2;

    ProductTerm(String name1, String name2, float c) {
      super(name1 + " * " + name2, c);
      this.name1 = name1;
      this.name2 = name2;
    }

    public String toString() {
      String res = "Product term for " + name + "\n";
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
      String res = "RCS term of order " + order + " for " + name + "\n";
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
