package org.broadinstitute.ebola_care_guidelines;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.preference.PreferenceManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import processing.core.PApplet;

public class Utils {
  public final static int ALL_PERMISSIONS_REQUEST = 1;
  public static final String ORG_COMMCARE_DALVIK_PROVIDER_CASES_READ_PERMISSION = "org.commcare.dalvik.provider.cases.read";
  public static final String ORG_COMMCARE_DALVIK_DEBUG_PROVIDER_CASES_READ_PERMISSION = "org.commcare.dalvik.debug.provider.cases.read";

  static public float[] normalizeDetails(float scale, List<Map.Entry<String, Float[]>> details) {
    float min = Float.MAX_VALUE;
    float max = Float.MIN_VALUE;
    Map.Entry<String, Float[]> entry0 = details.get(0);
    Float[] det = entry0.getValue();
    float maxContrib = det[2];
    for (Map.Entry<String, Float[]> entry: details) {
      det = entry.getValue();
      det[2] *= scale/maxContrib;
      min = PApplet.min(min, det[2]);
      max = PApplet.max(max, det[2]);
    }
    return new float[]{min, max};
  }

  static public Map.Entry<String, Float[]> findContrib(String varName, List<Map.Entry<String, Float[]>> details) {
    for (Map.Entry<String, Float[]> entry: details) {
      String key = entry.getKey();
      if (key.equals(varName)) return entry;
    }
    return null;
  }

  // The severity score should be between 0 and 1
  static public int severityColor(Context ctx, float score, boolean sigmoidScaling, float sigmoidFactor) {
    int minScore = ctx.getResources().getColor(R.color.colorMinSeverity);
    int maxScore = ctx.getResources().getColor(R.color.colorMaxSeverity);

    float[] minHsv = new float[3];
    float[] maxHsv = new float[3];
    Color.RGBToHSV(Color.red(minScore), Color.green(minScore), Color.blue(minScore), minHsv);
    Color.RGBToHSV(Color.red(maxScore), Color.green(maxScore), Color.blue(maxScore), maxHsv);

    float scaledScore = sigmoidScaling ?  1 / (1 + PApplet.exp(-sigmoidFactor * score)) : score;

    float h = PApplet.map(scaledScore, 0, 1, minHsv[0], maxHsv[0]);
    float s = PApplet.map(scaledScore, 0, 1, minHsv[1], maxHsv[1]);
    float v = PApplet.map(scaledScore, 0, 1, minHsv[2], maxHsv[2]);

    float hsv[] = {h, s, v};
    return Color.HSVToColor(hsv);
  }

  static public void setButtonColor(Button button, int color) {
    Drawable backgroundDrawable = DrawableCompat.wrap(button.getBackground()).mutate();
    DrawableCompat.setTint(backgroundDrawable, color);
  }

  static public void setDrawableColor(Drawable drawable, int color) {
    Drawable compatDrawable = DrawableCompat.wrap(drawable).mutate();
    DrawableCompat.setTint(compatDrawable, color);
  }

  static public float getHighRiskThreshold(Context context) {
    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
    return PApplet.parseFloat(prefs.getString("riskThreshold", "0.5"));
  }

  static public boolean useCommCare(Context context) {
    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
    String str = prefs.getString("dataEntryForm", "0");
    return str.equals("1");
  }


  static public String getResString(Context context, int id) {
    Resources res = context.getResources();
    return res.getString(id);
  }

  static public String getResString(Context context, String name) {
    if (-1 < name.indexOf("*")) {
      String[] names = name.split("\\*");
      String prod = "";
      for (int i = 0; i < names.length; i++) {
        String s = names[i].trim();
        if (!prod.equals("")) prod += " x ";
        prod += getResStringImpl(context, s);
      }
      return prod;
    } else {
      return getResStringImpl(context, name);
    }
  }

  // Get resource by name
  // https://stackoverflow.com/a/16444471
  static private String getResStringImpl(Context context, String name) {
    Resources res = context.getResources();
    String pkg = context.getPackageName();
    int id = res.getIdentifier(name, "string", pkg);
    if (id == 0) {
      return name;
    } else {
      return res.getString(id);
    }
  }

  static public Drawable getResDrawable(Context context, String name) {
    Resources res = context.getResources();
    String pkg = context.getPackageName();
    int id = res.getIdentifier(name, "drawable", pkg);
    if (id == 0) {
      return null;
    } else {
      return res.getDrawable(id);
    }
  }

  static public Button createButtonWithIcon(Context context, String textRes, String drawableRes,
                                            int marginVert, int marginHor) {
    Button button = new Button(context);
    final String label = getResString(context, textRes);
    button.setText(label);

    if (drawableRes != null) {
      // https://freakycoder.com/android-note-49-how-to-programatically-set-drawableleft-on-a-textview-a8cc77e22722
      Drawable img = getResDrawable(context, drawableRes);
      button.setCompoundDrawablesWithIntrinsicBounds(img, null, null, null);
    }

    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    );
    params.setMargins(marginVert, marginHor, marginVert, marginHor);
    button.setLayoutParams(params);

    return button;
  }

  static public Button createButton(Context context, String textRes, int marginVert, int marginHor) {
    return createButtonWithIcon(context, textRes, null, marginVert, marginHor);
  }

  static public void setupButton(Button button, String textRes, String drawableRes,
                                 int marginVert, int marginHor) {
    Context context = button.getContext();

    final String label = getResString(context, textRes);
    button.setText(label);

    Drawable img = getResDrawable(context, drawableRes);
    button.setCompoundDrawablesWithIntrinsicBounds(img, null, null, null);


    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    );
    params.setMargins(marginVert, marginHor, marginVert, marginHor);
    button.setLayoutParams(params);
  }

  static public void setupTextView(TextView view, String textRes, int textSize,
                                   int maxLines, int paddingVert, int paddingHor) {
    view.setText(Utils.getResString(view.getContext(), textRes));
    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    );
    view.setLayoutParams(params);
    view.setTextSize(textSize);
    view.setMaxLines(maxLines);
    view.setPadding(paddingVert, paddingHor, paddingVert, paddingHor);
    view.setMovementMethod(new ScrollingMovementMethod());
    view.setVerticalScrollBarEnabled(true);
  }

  static public void setupTextView(TextView view, int textSize, int paddingVert, int paddingHor) {
    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    );
    view.setLayoutParams(params);
    view.setTextSize(textSize);
    view.setPadding(paddingVert, paddingHor, paddingVert, paddingHor);
  }

  static public HashMap<String, Button> getButtonsInLayout(LinearLayout layout, HashMap<String, Button> buttons) {
    if (buttons == null) buttons = new HashMap<String, Button>();
    for (int i = 0; i < layout.getChildCount(); i++) {
      View view = layout.getChildAt(i);
      if (view instanceof Button) {
        Button button = (Button)view;
        buttons.put(button.getText().toString(), button);
      }
    }
    return buttons;
  }

  static public HashMap<String, RadioButton> getRadioButtonsInLayout(LinearLayout layout, HashMap<String, RadioButton> buttons) {
    if (buttons == null) buttons = new HashMap<String, RadioButton>();
    for (int i = 0; i < layout.getChildCount(); i++) {
      View view = layout.getChildAt(i);
      if (view instanceof RadioGroup) {
        RadioGroup group = (RadioGroup)view;
        for (int n = 0; n < group.getChildCount(); n++) {
          RadioButton button = (RadioButton)group.getChildAt(n);
          String tag = (String)button.getTag();
          buttons.put(tag, button);
        }
      }
    }
    return buttons;
  }

  static public HashMap<String, EditText> getEditTextsInLayout(LinearLayout layout, HashMap<String, EditText> edits) {
    if (edits == null) edits = new HashMap<String, EditText>();
    for (int i = 0; i < layout.getChildCount(); i++) {
      View view = layout.getChildAt(i);
      if (view instanceof EditText) {
        EditText edit = (EditText)view;
        String tag = (String)edit.getTag();
        edits.put(tag, edit);
      }
    }
    return edits;
  }

  public static boolean missingCommCarePermissions(Activity activity) {
    String[] permissions = {ORG_COMMCARE_DALVIK_PROVIDER_CASES_READ_PERMISSION};
    return missingAppPermission(activity, permissions);
  }

  public static boolean requestCommCarePermissions(Activity activity) {
    int permRequestCode = ALL_PERMISSIONS_REQUEST;
    String[] permissions = getAppPermissions();

    if (missingAppPermission(activity, permissions)) {
      requestNeededPermissions(activity, permRequestCode);
      return true;
    } else {
      return false;
    }
  }

  private static boolean missingAppPermission(Activity activity,
                                              String[] permissions) {
    for (String perm : permissions) {
      if (missingAppPermission(activity, perm)) {
        return true;
      }
    }
    return false;
  }

  public static boolean missingAppPermission(Activity activity,
                                             String permission) {
    return ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_DENIED;
  }

  public static String[] getAppPermissions() {
    return new String[]{
        ORG_COMMCARE_DALVIK_PROVIDER_CASES_READ_PERMISSION,
        ORG_COMMCARE_DALVIK_DEBUG_PROVIDER_CASES_READ_PERMISSION,
        Manifest.permission.WRITE_EXTERNAL_STORAGE
    };
  }

  @TargetApi(Build.VERSION_CODES.M)
  public static void requestNeededPermissions(Activity activity, int requestCode) {
    ActivityCompat.requestPermissions(activity, getAppPermissions(), requestCode);
  }
}
