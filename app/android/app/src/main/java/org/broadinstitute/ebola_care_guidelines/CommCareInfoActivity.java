package org.broadinstitute.ebola_care_guidelines;

import android.app.Activity;
import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.view.View;

public class CommCareInfoActivity extends FragmentActivity {
  final static public int REQUEST_CODE = 2;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_info_commcare);
  }

  public void continueToCommCareButton(View view) {
    Utils.requestCommCarePermissions(this);
    setResult(Activity.RESULT_OK, null);
    finish();
  }
}
