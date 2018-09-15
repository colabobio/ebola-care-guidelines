package org.broadinstitute.ebola_care_guidelines;

import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class RecommendationActivity extends AppCompatActivity {
  final static public String LABEL_RES = "label_res";
  final static public String ICON_RES = "icon_res";
  final static public String DESCRIPTION_RES = "description_res";
  final static public String GUIDES_JSON = "guides_json";

  String labelRes;
  String iconRes;
  String descRes;
  String guidesJson;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_recommendation);

    if (savedInstanceState == null) {
      Bundle extras = getIntent().getExtras();
      if (extras == null) {
        throw new MissingExtrasException("No extras available to populate recommendation");
      } else {
        labelRes = extras.getString(LABEL_RES);
        iconRes = extras.getString(ICON_RES);
        descRes = extras.getString(DESCRIPTION_RES);
        guidesJson = extras.getString(GUIDES_JSON);
      }
    } else {
      labelRes = (String) savedInstanceState.getSerializable(LABEL_RES);
      iconRes = (String) savedInstanceState.getSerializable(ICON_RES);
      descRes = (String) savedInstanceState.getSerializable(DESCRIPTION_RES);
      guidesJson = (String) savedInstanceState.getSerializable(GUIDES_JSON);
    }

    createLayout();
  }

  private void createLayout() {
    Button button = findViewById(R.id.recommendation_button);
    Utils.setupButton(button, labelRes, iconRes, 10, 0);
    button.setClickable(false);
//    button.setTextAlignment(View.TEXT_ALIGNMENT_TEXT_START);

    TextView text = findViewById(R.id.recommendation_text);
    Utils.setupTextView(text, descRes, 18, 10, 28, 0);

    addGuides();
  }

  private void addGuides() {
    JSONObject jRoot = null;
    try {
      jRoot = new JSONObject(guidesJson);
    } catch (JSONException ex) {
      ex.printStackTrace();
      return;
    }

    // Get the current system language, en, fr, etc
    String lang = Resources.getSystem().getConfiguration().locale.getLanguage();

    LinearLayout layout = findViewById(R.id.guides_list_layout);
    Iterator<?> keys = jRoot.keys();
    while( keys.hasNext() ) {
      String key = (String)keys.next();
      try {
        JSONObject obj = jRoot.getJSONObject(key);
        JSONObject jGuide = obj.optJSONObject(lang);
        if (jGuide == null) {
          // No guide available in current system language, will default to english
          jGuide = obj.optJSONObject("en");
        }
        if (jGuide != null) {
          final String pdfFile = jGuide.optString("file");
          final int pageNumber = jGuide.optInt("page", -1);
          if (pdfFile != null && pageNumber != -1) {
            // We have a guide, will create button for it
            String labelRes = key;
            System.out.println(Utils.getResString(this, labelRes) + " " + pdfFile + " " + pageNumber);

            final String viewTitle = Utils.getResString(this, labelRes);
            Button button = Utils.createButton(this, labelRes, 10, 0);
            button.setOnClickListener(new View.OnClickListener() {
              @Override
              public void onClick(View v) {
                openGuide(viewTitle, pdfFile, pageNumber);
              }
            });
            layout.addView(button);

          }
        }
      } catch (JSONException ex) {
        ex.printStackTrace();
        continue;
      }
    }
  }

  private void openGuide(String viewTitle, String pdfFile, int pageNumber) {
    Intent intent = new Intent(this, PDFViewActivity.class);
    intent.putExtra(PDFViewActivity.VIEW_TITLE, viewTitle);
    intent.putExtra(PDFViewActivity.PDF_FILE, "guidelines/" + pdfFile);
    intent.putExtra(PDFViewActivity.PAGE_NUMBER, pageNumber);
    startActivity(intent);
  }

  private class MissingExtrasException extends RuntimeException {
    public MissingExtrasException() {}
    public MissingExtrasException(String message) {
      super(message);
    }
  }
}
