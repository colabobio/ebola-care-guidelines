package org.broadinstitute.ebolarisk;

import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.FragmentActivity;
import android.util.Log;

import processing.android.PFragment;

public class RiskActivity extends FragmentActivity {
  private PredSketch sketch;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_risk);

    Log.e("----->", "CREATE SKETCH");
    sketch = new PredSketch();
    PFragment fragment = new PFragment(sketch);
    fragment.setLayout(R.layout.fragment_risk, R.id.risk_content, this);
  }

  @Override
  public void onResume() {
    super.onResume();
//    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
    Log.e("----->", "UPDATE SKETCH");
    sketch.update(DataHolder.getInstance().getSelectedModel(),
                  DataHolder.getInstance().getCurrentData(),
                  DataHolder.getInstance().getExtraData(),
                  PreferenceManager.getDefaultSharedPreferences(this));
  }
}
