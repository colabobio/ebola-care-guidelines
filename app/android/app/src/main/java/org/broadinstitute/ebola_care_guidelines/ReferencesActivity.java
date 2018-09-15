package org.broadinstitute.ebola_care_guidelines;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AppCompatActivity;
import android.text.util.Linkify;
import android.widget.LinearLayout;
import android.widget.Space;
import android.widget.TextView;

import java.io.InputStream;

import processing.core.PApplet;

public class ReferencesActivity extends AppCompatActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_references);

    loadReferences();
  }

  private void loadReferences() {
    try {
      InputStream is = getAssets().open("guidelines/references.txt");
      String[] lines = PApplet.loadStrings(is);

      LinearLayout layout = findViewById(R.id.references_list_layout);

      String[] reference = null;
      for (int i = 0; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.length() == 0 || line.indexOf("#") == 0) continue; // Empty or Comment line
        String[] parts = line.split("=");
        if (parts.length != 2) continue; // Malformed line
        String key = parts[0];
        String value = parts[1];
        if (key.equals("description")) {
          addReference(reference, layout); // Add current reference
          reference = new String[2]; // Start new reference
          reference[0] = value;
        }
        if (reference == null) continue;
        if (key.equals("url")) {
          reference[1] = value;
        }
      }
      addReference(reference, layout);
    } catch (java.io.IOException ex) {
      ex.printStackTrace();
    }
  }

  private void addReference(String[] ref, LinearLayout layout) {
    if (ref == null) return;

    TextView view = new TextView(this);
    view.setText(Utils.getResString(view.getContext(), ref[0]));
    Utils.setupTextView(view, 14, 20, 5);
    layout.addView(view);

    view = new TextView(this);
    view.setText(Utils.getResString(view.getContext(), ref[1]));
    Utils.setupTextView(view, 14, 20, 5);
    view.setLinksClickable(true);
    Linkify.addLinks(view, Linkify.WEB_URLS);
    layout.addView(view);

    Space space = new Space(this);
    space.setMinimumHeight(40);
    layout.addView(space);
  }
}