package org.broadinstitute.ebolarisk;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

// From
// https://www.bignerdranch.com/blog/splash-screens-the-right-way/
// https://github.com/cstew/Splash
public class SplashActivity extends AppCompatActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // Adding some extra 2 secs dealy so app log can be seen
    try {
      Thread.sleep(2000);
    } catch (InterruptedException e) { }

//        Intent intent = new Intent(this, MainActivity.class);
    Intent intent = new Intent(this, InfoActivity.class);
    intent.putExtra(InfoActivity.LAUNCH_MAIN, true);
    startActivity(intent);
    finish();
  }
}