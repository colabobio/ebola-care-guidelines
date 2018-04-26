package org.broadinstitute.ebolarisk;

import android.content.res.AssetManager;
import android.util.Log;

import java.util.HashMap;

// What's the best way to share data between activities?
// http://stackoverflow.com/a/4878259
public class DataHolder {
  private LogRegModel minModel;
  private LogRegModel fullModel;
  private LogRegModel wellModel;
  private LogRegModel selModel;
  private HashMap<String, Float> floatVars;
  private HashMap<String, Float> floatExtra;
  private static DataHolder instance = new DataHolder();

  public static DataHolder getInstance() {
    return instance;
  }
  private DataHolder() {
    minModel = null;
    fullModel = null;
    wellModel = null;
    selModel = null;
    floatVars = new HashMap<String, Float>();
    floatExtra = new HashMap<String, Float>();
  }

  public static void loadModels(AssetManager am) {
    try {
      instance.minModel = new LogRegModel(am.open("min/mice.txt"), am.open("min/minmax.txt"));
      System.out.println("PRESENTATION-MIN MODEL ========================");
      System.out.println(instance.minModel);
    } catch (java.io.IOException ex) {
      Log.e("EbolaCARE2", "Cannot load the min model");
    }

    try {
      instance.fullModel = new LogRegModel(am.open("kgh/mice.txt"), am.open("kgh/minmax.txt"));
      System.out.println("PRESENTATION-FULL MODEL ========================");
      System.out.println(instance.fullModel);
    } catch (java.io.IOException ex) {
      Log.e("EbolaCARE2", "Cannot load the full model");
    }

    try {
      instance.wellModel = new LogRegModel(am.open("well/mice.txt"), am.open("well/minmax.txt"));
      System.out.println("WELLNESS MODEL ========================");
      System.out.println(instance.wellModel);
    } catch (java.io.IOException ex) {
      Log.e("EbolaCARE2", "Cannot load the wellness model");
    }

    // no model currently selected.
    instance.selModel = null;
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

  private void selectModel() {
    if (fullModel.contains(floatVars.keySet())) {
      System.out.println("===================== Selected Full Presentation Model");
      selModel = fullModel;
    } else if (wellModel.contains(floatVars.keySet())) {
      System.out.println("===================== Selected Wellness Presentation Model");
      selModel = wellModel;
    } else if (minModel.contains(floatVars.keySet())) {
      System.out.println("===================== Selected Minimal Presentation Model");
      selModel = minModel;
    } else {
      selModel = null;
    }
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
}
