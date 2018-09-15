package org.broadinstitute.ebola_care_guidelines;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;

import org.commcare.commcaresupportlibrary.CaseUtils;

import java.util.HashMap;

public class CaseSelectorActivity extends AppCompatActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.content_case);
    showCaseData(null, null);
  }

  private void showCaseData(String selection, String[] selectionArgs) {
    ListView list = this.findViewById(R.id.list_view);

    final Cursor cursor = CaseUtils.getCaseMetaData(this, selection, selectionArgs);

    final SimpleCursorAdapter cursorAdapter = new SimpleCursorAdapter(this, android.R.layout.two_line_list_item, cursor, new String[]{"case_name", "date_opened"}, new int[]{android.R.id.text1, android.R.id.text2}, 1);

    list.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
      @Override
      public boolean onItemLongClick(AdapterView<?> arg0, View arg1, int position, long id) {
        cursor.moveToPosition(position);
        String command = "COMMAND_ID" + " " + "m2" + " " +
                         "CASE_ID" + " " + "case_id" + " " + cursor.getString(1) +
                         " " + "COMMAND_ID" + " " + "m2-f1";
        Intent i = new Intent("org.commcare.dalvik.action.CommCareSession");
        i.putExtra("ccodk_session_request", command);
        CaseSelectorActivity.this.startActivity(i);
        return true;
      }
    });

    list.setAdapter(cursorAdapter);
    list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        cursor.moveToPosition(position);
        String caseId = cursor.getString(cursor.getColumnIndex("case_id"));
        Cursor caseData = CaseUtils.getCaseDataCursor(CaseSelectorActivity.this, caseId);
        HashMap<String, Float> values = new HashMap<String, Float>();
        while(caseData.moveToNext()) {
          int index = caseData.getColumnIndexOrThrow("datum_id");
          String datum_id = caseData.getString(index);
          index = caseData.getColumnIndexOrThrow("value");
          String value = caseData.getString(index);
          int gidx = datum_id.indexOf("_Group");
          if (-1 < gidx) {
            String gstr = datum_id.substring(gidx + 6);
            String[] group = DataHolder.getInstance().getVariableGroup(gstr);
            for (String v: group) values.put(v, 0f);
            String[] present = value.split(" ");
            for (String v: present) values.put(v, 1f);
          } else if (-1 < datum_id.indexOf("_Check")) {
            continue;
          } else {
            float fval;
            try {
              fval = Float.parseFloat(value);
            } catch (NumberFormatException e) {
              fval = Float.NaN;
            }
            values.put(datum_id, fval);
          }
          System.out.println(datum_id + " " + value);
        }
        DataHolder.getInstance().clearData();
        DataHolder.getInstance().setData(values);
        finish();
      }
    });
  }
}
