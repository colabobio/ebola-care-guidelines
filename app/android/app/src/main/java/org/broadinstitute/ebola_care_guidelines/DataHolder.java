package org.broadinstitute.ebola_care_guidelines;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;

import processing.core.PApplet;

// What's the best way to share data between activities?
// http://stackoverflow.com/a/4878259
public class DataHolder implements DataTypes {
  private LogRegModel[] models;
  private LogRegModel selModel;

  private HashMap<String, Integer> varTypes;

  private HashMap<String, Float> floatVars;
  private HashMap<String, Float> floatExtra;
  private static DataHolder instance = new DataHolder();

  private HashMap<String, String[]> binLabels;

  private HashMap<String, ArrayList<String>> groups;

  public static DataHolder getInstance() {
    return instance;
  }

  public DataHolder() {
    models = null;
    selModel = null;
    floatVars = new HashMap<String, Float>();
    floatExtra = new HashMap<String, Float>();
    binLabels = new HashMap<String, String[]>();
    groups = new HashMap<String, ArrayList<String>>();
  }

  public static void init(AssetManager am) {
    loadModels(am);
    loadVarTypes(am);
    instance.selModel = null;
  }

  public void clearData() {
    floatVars.clear();
    floatExtra.clear();
    selModel = null;
  }

  public boolean supportedVar(String name) {
    return varTypes.containsKey(name);
  }

  public void setData(String var, boolean value) {
    Log.e("----->", var + ": " + value);
    if (value) floatVars.put(var, 1.0f);
    else floatVars.put(var, 0.0f);
    selectModel();
  }

  public void setData(String var, float value) {
    Log.e("----->", var + ": " + value);
    if (Float.isNaN(value)) {
      floatVars.remove(var);
    } else {
      floatVars.put(var, value);
    }
    selectModel();
  }

  public void remData(String var) {
    Log.e("----->", "Removed variable " + var);
    floatVars.remove(var);
    selectModel();
  }

  public void setDataExtra(String var, float value) {
    Log.e("----->", var + ": " + value);
    if (Float.isNaN(value)) {
      floatExtra.remove(var);
    } else {
      floatExtra.put(var, value);
    }
  }

  public void setData(HashMap<String, Float> data) {
    for (String var: data.keySet()) {
      Float val = data.get(var);
      if (val.isNaN()) {
        floatVars.remove(var);
      } else {
        floatVars.put(var, val);
      }
    }
    selectModel();
  }

  public String[] getVariables() {
    String[] vars = new String[varTypes.keySet().size()];
    varTypes.keySet().toArray(vars);
    return vars;
  }

  public String[] getVariableGroup(String name) {
    ArrayList<String> group = groups.get(name);
    if (group == null) return null;

    String[] res = new String[group.size()];
    group.toArray(res);

    return res;
  }

  public int getVarType(String var) {
    if (varTypes == null) {
      return FLOAT;
    } else {
      Integer type = varTypes.get(var);
      if (type == null) return FLOAT;
      else return type;
    }
  }

  public String getStringValue(float value, String var, int right, HashMap<String, String> localizedLabels) {
    int type = getVarType(var);
    if (type == BINARY) {
      int ival = (int)value;
      if (ival == 0 || ival == 1) {
        String[] labels = binLabels.get(var);
        String str = labels[ival];
        String loc = localizedLabels.get(str);
        return loc == null ? str : loc;
      } else {
        return "NA";
      }
    } else if (type == INT) {
      return new Integer((int)value).toString();
    } else {
      return PApplet.nfc(value, 1);
    }
  }

  public String[] getVarLabels(String var) {
    int type = getVarType(var);
    if (type == BINARY) {
       return binLabels.get(var);
    }
    return new String[] {};
  }

  private void selectModel() {
    if (models == null || models.length == 0) {
      selModel = null;
      return;
    }

    for (int i = 0; i < models.length; i++) {
      if (models[i] == null) continue;
      if (models[i].containedIn(floatVars.keySet())) {
        selModel = models[i];
        System.out.println("===================== Selected " + selModel.getName() + " model");
        return;
      }
    }

    selModel = null;
  }

  public LogRegModel getSelectedModel() {
    return selModel;
  }

  public HashMap<String, Float> getCurrentData() {
    return floatVars;
  }

  public HashMap<String, Float> getExtraData() {
    return floatExtra;
  }

  public boolean conditionIsSatisfied(VarCondition cond, float highRisk) {
    String var = cond.getVariable();
    float val;
    if (var.equals("SeverityScore")) {
      if (selModel == null) return false;
      val = selModel.eval(floatVars);
      cond.setValue(highRisk);
    } else {
      if (!floatVars.containsKey(var)) return false;
      val = floatVars.get(var);
    }
    return cond.holds(val);
  }

  private static void loadModels(AssetManager am) {
    InputStream is = null;
    try {
      is = am.open("models/list.txt");
    } catch (java.io.IOException ex) {
      ex.printStackTrace();
    }

    if (is != null) {
      String[] lines = PApplet.loadStrings(is);
      instance.models = new LogRegModel[lines.length];
      for (int i = 0; i < lines.length; i++) {
        String name = lines[i];
        System.out.println("====== Loading model " + name);
        try {
          LogRegModel model = new LogRegModel(name,
              am.open("models/" + name + "/model.csv"),
              am.open("models/" + name + "/ranges.txt"),
              LogRegModel.CSV);
          instance.models[i] = model;
        } catch (java.io.IOException ex) {
          ex.printStackTrace();
        }
      }
    }
  }

  private static void loadVarTypes(AssetManager am) {
    InputStream is = null;

    try {
      is = am.open("models/variables.txt");
    } catch (java.io.IOException ex) {
      ex.printStackTrace();
    }

    if (is != null) {
      String[] lines = PApplet.loadStrings(is);
      instance.varTypes = new HashMap<String, Integer>();
      for (int i = 0; i < lines.length; i++) {
        String line = lines[i];
        if (line.indexOf("#") == 0) continue;
        String parts[] = line.split("[ ]+");
        if (2 <= parts.length) {
          String name = parts[0].trim();
          String gname = "";
          if (-1 < name.indexOf(":")) {
            String[] nparts = name.split(":");
            name = nparts[0];
            gname = nparts[1];
            ArrayList<String> group;
            if (instance.groups.containsKey(gname)) {
              group = instance.groups.get(gname);
            } else {
              group = new ArrayList<String>();
              instance.groups.put(gname, group);
            }
            group.add(name);
          }

          String typeStr = parts[1].trim();
          int type = FLOAT;
          if (typeStr.equals("INT")) {
            type = INT;
          } else if (typeStr.equals("BINARY")) {
            type = BINARY;
            String[] labels = new String[] {"no", "yes"};
            if (parts.length == 3) {
              // parts[2] should be of the form {0:Female,1:Male}
              String str = parts[2].substring(1, parts[2].length()-1); // Remove brackets
              String[] tmp1 = str.split(",");  // This should give 0:Female and 1:Male
              for (String t1: tmp1) {
                String[] tmp2 = t1.split(":"); // Split into 0 and Female, 1 and Male
                if (tmp2.length == 2) {
                  int idx = PApplet.parseInt(tmp2[0], 0);
                  if (idx == 0 || idx == 1) labels[idx] = tmp2[1].toLowerCase();
                }
              }
            }
            instance.binLabels.put(name, labels);
          }
          instance.varTypes.put(name, type);
        } else {
          instance.varTypes.put(parts[0], FLOAT);
        }
      }
    }
  }
}
