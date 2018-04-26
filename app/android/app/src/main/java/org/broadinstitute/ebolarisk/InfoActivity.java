package org.broadinstitute.ebolarisk;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class InfoActivity extends AppCompatActivity {
  final static public String LAUNCH_MAIN = "launch_main";
  private boolean launchMain =  false;
  private View contentView;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_info);
    contentView = findViewById(R.id.fullscreen_view);
    hideUI();
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

  @Override
  protected void onStart() {
    super.onStart();
    hideUI();
  }

  @Override
  protected void onStop() {
    super.onStop();
    showUI();
  }

  public void closeButton(View view) {
    if (launchMain) {
      Intent intent = new Intent(this, MainActivity.class);
      startActivity(intent);
    }
    finish();
  }

  @SuppressLint("InlinedApi")
  private void hideUI() {
      // Note that some of these constants are new as of API 16 (Jelly Bean)
      // and API 19 (KitKat). It is safe to use them, as they are inlined
      // at compile-time and do nothing on earlier devices.
      contentView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LOW_PROFILE
              | View.SYSTEM_UI_FLAG_FULLSCREEN
              | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
              | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
              | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
              | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
  }

  @SuppressLint("InlinedApi")
  private void showUI() {
    // Show the system bar
    contentView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
  }
}
