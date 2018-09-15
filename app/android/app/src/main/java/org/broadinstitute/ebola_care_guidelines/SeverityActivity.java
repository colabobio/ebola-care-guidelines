package org.broadinstitute.ebola_care_guidelines;

import android.content.Intent;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import processing.android.PFragment;

public class SeverityActivity extends AppCompatActivity {
  private SeverityChart sketch;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_severity);

//    Toolbar toolbar = (Toolbar) findViewById(R.id.settings_toolbar);
//    setSupportActionBar(toolbar);

    setTitle("Severity Score of Patient");

    Log.e("----->", "CREATING PREFERENCES ACTIVITY");

    sketch = new SeverityChart();
    PFragment fragment = new PFragment(sketch);
    fragment.setLayout(R.layout.content_severity, R.id.content_severity, this);
  }

  @Override
  public void onResume() {
    super.onResume();
    Log.e("----->", "UPDATE SKETCH");

    sketch.update(PreferenceManager.getDefaultSharedPreferences(this));
  }
}
