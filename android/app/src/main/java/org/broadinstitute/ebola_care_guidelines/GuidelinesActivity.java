package org.broadinstitute.ebola_care_guidelines;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;

import org.commcare.commcaresupportlibrary.CaseUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import processing.core.PApplet;

public class GuidelinesActivity extends AppCompatActivity {
  protected ArrayList<String[]> recommendations;
  protected HashMap<String, ArrayList<VarCondition>> recommendConditions;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_guidelines);

    Button button = findViewById(R.id.button_data);
    Utils.setButtonColor(button, getResources().getColor(R.color.colorEnterData));

    CaseUtils.setPackageExtension(this, null);

    loadGuidelines();
    buildGuidelinesList();
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_toolbar, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    int id = item.getItemId();

    if (id == R.id.action_references) {
      Intent i = new Intent(this, ReferencesActivity.class);
      startActivity(i);
    }

    if (id == R.id.action_preferences) {
      Intent i = new Intent(this, PreferencesActivity.class);
      startActivity(i);
    }

    return super.onOptionsItemSelected(item);
  }

  public void onRiskButtonClick(View view) {
    Intent i = new Intent(this, SeverityActivity.class);
    startActivity(i);
  }

  public void onDataButtonClick(View view) {
    if (Utils.useCommCare(this)) {
      if (Utils.missingCommCarePermissions(this)) {
        Intent i = new Intent(this, CommCareInfoActivity.class);
        startActivityForResult(i, CommCareInfoActivity.REQUEST_CODE);
      } else {
        openCommCareEntryDialog();
      }
    } else {
      openBuiltinEntryActivity();
    }
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == CommCareEntryDialog.REQUEST_CODE) {
      openCaseSelector();
    } else if (requestCode == CommCareInfoActivity.REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        openCommCareEntryDialog();
      }
    }
  }

  protected void openCommCareEntryDialog() {
    CommCareEntryDialog dialog = new CommCareEntryDialog();
    dialog.setParentActivity(this);
    dialog.show(getSupportFragmentManager(), "CommCareEntryDialogFragment");
  }

  protected void openBuiltinEntryActivity() {
    DataHolder.getInstance().clearData();
    Intent i = new Intent(this, DataInputActivity.class);
    startActivity(i);
  }

  protected void openCaseSelector() {
    Intent i = new Intent(this, CaseSelectorActivity.class);
    startActivity(i);
  }

  @Override
  public void onResume() {
    super.onResume();
    updateSeverityButton();
    updateRecommButtons();
  }

  private void updateSeverityButton() {
    LogRegModel model = DataHolder.getInstance().getSelectedModel();
    Button button = findViewById(R.id.button_severity);
    if (model != null) {
      HashMap<String, Float> data = DataHolder.getInstance().getCurrentData();
      float score = model.eval(data);
      int points = (int)PApplet.ceil(10 * score);
      String text = Utils.getResString(this, "severity_score") + "\n" + points;
      if (Utils.getHighRiskThreshold(this) < score) {
        text += " - " + Utils.getResString(this, "severity_score_high");
      }
      button.setText(text);
      Utils.setButtonColor(button, Utils.severityColor(this, score, false, 0));
    } else {
      button.setText(R.string.severity_score_no_data);
      Utils.setButtonColor(button, getResources().getColor(R.color.colorDefaultRecomm));
    }
  }

  private void updateRecommButtons() {
    LinearLayout layout = findViewById(R.id.recommendations_list_layout);
    HashMap<String, Button> buttons = Utils.getButtonsInLayout(layout, null);

    DataHolder holder = DataHolder.getInstance();
    float threshold = Utils.getHighRiskThreshold(this);

    // We get the model and details (contributions per variable) in order to color the recommendations
    LogRegModel model = DataHolder.getInstance().getSelectedModel();
    List<Map.Entry<String, Float[]>> details = null;
    float defScore = 0.25f;
    float score = 0.0f;
    if (model != null) {
      HashMap<String, Float> data = DataHolder.getInstance().getCurrentData();
      score = model.eval(data);
      details = model.evalDetails(data);
      Utils.normalizeDetails(score, details);
    }

    for (String label: recommendConditions.keySet()) {
      boolean sigmoidScaling = false;
      float maxScore = 0;
      Button button = buttons.get(label);
      ArrayList<VarCondition> conditions = recommendConditions.get(label);
      boolean highlight = false;
      for (VarCondition cond: conditions) {
        if (holder.conditionIsSatisfied(cond, threshold)) {
          highlight = true;

          if (model != null) {
            if (cond.getVariable().equals("SeverityScore")) {
              // The severity score cannot be found in the details, but this means that the patient
              // is high risk so we use the actual severity for this recommendation.
              maxScore = PApplet.max(maxScore, score);
              continue;
            }

            Map.Entry<String, Float[]> entry = Utils.findContrib(cond.getVariable(), details);
            if (entry == null) {
              // The variable in this condition is not part of the model, so using the minimum
              // contribution to update the maximum score for this recommendation
              maxScore = PApplet.max(maxScore, defScore);
            } else {
              // The variable in this condition is part of the model, so using it to update the
              // maximum score for this recommendation
              Float det[] = entry.getValue();
              maxScore = PApplet.max(maxScore, det[2]);
              sigmoidScaling = true;
            }
          } else {
            maxScore = defScore;
            break;
          }
        }
      }

      if (highlight) {
        Utils.setButtonColor(button, Utils.severityColor(this, maxScore, sigmoidScaling, 2));
      } else {
        Utils.setButtonColor(button, getResources().getColor(R.color.colorDefaultRecomm));
      }
    }
  }

  private void loadGuidelines() {
    recommendations = new ArrayList<>();
    recommendConditions = new HashMap<String, ArrayList<VarCondition>>();
    try {
      InputStream is = getAssets().open("guidelines/recommendations.txt");
      String[] lines = PApplet.loadStrings(is);

      String[] recommend = null;
      for (int i = 0; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.length() == 0 || line.indexOf("#") == 0) continue; // Empty or Comment line
        String[] parts = line.split("=");
        if (parts.length != 2) continue; // Malformed line
        String key = parts[0];
        String value = parts[1];
        if (key.equals("label")) {
          addRecommendation(recommend); // Store current recommendation
          recommend = new String[5]; // Start new recommendation
          recommend[0] = value;
        }
        if (recommend == null) continue;
        if (key.equals("icon")) {
          recommend[1] = value;
        }
        if (key.equals("description")) {
          recommend[2] = value;
        }
        if (key.equals("guides")) {
          recommend[3] = value;
        }
        if (key.equals("presentation")) {
          recommend[4] = value;
        }
      }
      addRecommendation(recommend);
    } catch (java.io.IOException ex) {
      ex.printStackTrace();
    }
  }

  private void addRecommendation(String[] recommend) {
    if (recommend != null) {
      if (recommend[0] != null && recommend[1] != null &&
          recommend[3] != null && recommend[3] != null) {
        recommendations.add(recommend);
      } else {
        throw new IncompleteGuidelineException("Incomplete recommendation found in assets file");
      }
    }
  }

  private void buildGuidelinesList() {
    LinearLayout layout = findViewById(R.id.recommendations_list_layout);
    for (String[] recomend: recommendations) {
      final String labelRes = recomend[0];
      final String iconRes = recomend[1];
      final String descRes = recomend[2];
      final String guidesJson = recomend[3];
      final String presentJson = recomend[4];

      Button button = Utils.createButtonWithIcon(this, labelRes, iconRes, 10, 0);
      button.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View v) {
          openRecommendation(labelRes, iconRes, descRes, guidesJson);
        }
      });
      layout.addView(button);

      if (presentJson != null) {
        parsePresentation(labelRes, presentJson, button);
      }
    }
  }

  private void parsePresentation(String labelRes, String json, Button button) {
    ArrayList<VarCondition> conditions = new ArrayList<VarCondition>();
    JSONObject jMap = null;
    try {
      jMap = new JSONObject(json);
    } catch (JSONException ex) {
      ex.printStackTrace();
      return;
    }
    final String label = Utils.getResString(this, labelRes);
    Iterator<?> keys = jMap.keys();
    while( keys.hasNext() ) {
      String var = (String)keys.next();
      String valStr = jMap.optString(var);
      if (valStr == null) continue;

      int rel;
      int n = valStr.length() - 1;
      if (valStr.indexOf('+') == n) {
        valStr = valStr.substring(0, n);
        rel = VarCondition.GREATER_OR_EQUAL;
      } else if (valStr.indexOf('-') == n) {
        valStr = valStr.substring(0, n);
        rel = VarCondition.LESS_OR_EQUAL;
      } else {
        rel = VarCondition.EQUAL;
      }
      float val = PApplet.parseFloat(valStr, Float.NaN);
      VarCondition cond = new VarCondition(var, val, rel);
      conditions.add(cond);
    }
    recommendConditions.put(label, conditions);
  }

  private void openRecommendation(String labelRes, String iconRes, String descRes, String guidesJson) {
    Intent intent = new Intent(this, RecommendationActivity.class);
    intent.putExtra(RecommendationActivity.LABEL_RES, labelRes);
    intent.putExtra(RecommendationActivity.ICON_RES, iconRes);
    intent.putExtra(RecommendationActivity.DESCRIPTION_RES, descRes);
    intent.putExtra(RecommendationActivity.GUIDES_JSON, guidesJson);
    startActivity(intent);
  }

  private class IncompleteGuidelineException extends RuntimeException {
    public IncompleteGuidelineException() {}
    public IncompleteGuidelineException(String message) {
      super(message);
    }
  }
}
