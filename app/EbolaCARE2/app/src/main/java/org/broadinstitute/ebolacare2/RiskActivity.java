package org.broadinstitute.ebolacare2;

import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import org.broadinstitute.ebolacare2.R;
import processing.android.PFragment;

public class RiskActivity extends FragmentActivity {
  private PredSketch sketch;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_risk);

    Log.e("----->", "CREATE SKETCH");
    sketch = new PredSketch();

    PFragment fragment = new PFragment();
    fragment.setSketch(sketch);

    FragmentManager fragmentManager = getSupportFragmentManager();
    FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
    fragmentTransaction.add(R.id.risk_content, fragment);
    fragmentTransaction.commit();
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
