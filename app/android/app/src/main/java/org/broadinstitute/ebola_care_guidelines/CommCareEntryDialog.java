package org.broadinstitute.ebola_care_guidelines;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;

public class CommCareEntryDialog extends DialogFragment {
  final static public int REQUEST_CODE = 1;

  AppCompatActivity parent;

  public void setParentActivity(AppCompatActivity parent) {
    this.parent = parent;
  }

  @Override
  public Dialog onCreateDialog(Bundle savedInstanceState) {
    AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
    builder.setTitle(R.string.pick_dataentry)
        .setItems(R.array.commcare_options, new DialogInterface.OnClickListener() {
          public void onClick(DialogInterface dialog, int which) {
            if (which == 0) {
              Intent i = new Intent("org.commcare.dalvik.action.CommCareSession");
              String sssd = "";
              sssd += "COMMAND_ID" + " " + "m0" + " " +
                      "COMMAND_ID" + " " + "m0-f0";
              i.putExtra("ccodk_session_request", sssd);
              parent.startActivityForResult(i, REQUEST_CODE);
            } else if (which == 1) {
              Intent i = new Intent(getActivity(), CaseSelectorActivity.class);
              parent.startActivity(i);
            }
          }
        });
    return builder.create();
  }
}
