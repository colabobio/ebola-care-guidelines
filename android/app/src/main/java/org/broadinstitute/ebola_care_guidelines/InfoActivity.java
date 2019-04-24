package org.broadinstitute.ebola_care_guidelines;

import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.view.View;

public class InfoActivity extends FragmentActivity {
  final static public String LAUNCH_MAIN = "launch_main";
  private boolean launchMain =  false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_info);
    if (savedInstanceState == null) {
      Bundle extras = getIntent().getExtras();
      if(extras == null) {
        launchMain = false;
      } else {
        launchMain = extras.getBoolean(LAUNCH_MAIN);
      }
    } else {
      launchMain = (Boolean) savedInstanceState.getSerializable(LAUNCH_MAIN);
    }
  }

  public void continueButton(View view) {
    if (launchMain) {
      DataHolder.init(getAssets());
      Intent intent;
      intent = new Intent(this, GuidelinesActivity.class);
      startActivity(intent);
    }
    finish();
  }
}
