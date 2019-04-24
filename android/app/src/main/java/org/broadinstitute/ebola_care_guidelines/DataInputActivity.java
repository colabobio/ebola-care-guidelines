package org.broadinstitute.ebola_care_guidelines;

import android.support.design.widget.TabLayout;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.content.Intent;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;

import java.util.HashMap;
import java.util.HashSet;

public class DataInputActivity extends FragmentActivity {

  static private final int NUM_PAGES = 4;
  static private final String[] PAGE_TITLES = {"PATIENT", "TRIAGE", "LAB", "WELLNESS"};
  static private final String PAGE_NUMBER = "page_number";

  private SectionsPagerAdapter mSectionsPagerAdapter;
  private ViewPager mViewPager;

  private HashSet<String> clickedRadioButtonTags = new HashSet<String>();
  private HashSet<String> clickedEditTextTags = new HashSet<String>();

  protected HashMap<String, Float> values = new HashMap<String, Float>();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_data_input);

    Log.e("----->", "CREATING DATA INPUT ACTIVITY");

    // Create the adapter that will return a fragment for each of the three
    // primary sections of the activity.
    mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

    // Set up the ViewPager with the sections adapter.
    mViewPager = (ViewPager) findViewById(R.id.container);
    mViewPager.setAdapter(mSectionsPagerAdapter);

    TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
    tabLayout.setupWithViewPager(mViewPager);

    mViewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
    tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
      @Override
      public void onTabSelected(TabLayout.Tab tab) {
        // Hide soft keyboard when changing tab
        final InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(mViewPager.getWindowToken(), 0);
        mViewPager.setCurrentItem(tab.getPosition());
      }

      @Override
      public void onTabUnselected(TabLayout.Tab tab) {
        extractValues(tab.getPosition());
      }

      @Override
      public void onTabReselected(TabLayout.Tab tab) {
      }
    });
  }

  @Override
  public void onBackPressed() {
    extractValues(mViewPager.getCurrentItem());
    DataHolder.getInstance().setData(values);
    super.onBackPressed();
  }

  public void showGuidelines(View view) {
    extractValues(mViewPager.getCurrentItem());
    DataHolder.getInstance().setData(values);
    finish();
  }

  public void onRadioButtonClicked(View view) {
    RadioButton rb = (RadioButton)view;
    String tag = (String)rb.getTag();
    String[] parts = tag.split(":");
    if (parts.length == 2) {
      // Remove all possible values already added, so the new one replaces them
      String varName = parts[0];
      clickedRadioButtonTags.remove(varName + ":1");
      clickedRadioButtonTags.remove(varName + ":0");
      clickedRadioButtonTags.remove(varName + ":na");
    }
    clickedRadioButtonTags.add(tag);
  }

  public void onEditTextClicked(View view) {
    EditText rb = (EditText)view;
    String tag = (String)rb.getTag();
    clickedEditTextTags.add(tag);
  }

  public static Fragment newFragmentInstance(int sectionNumber) {
     Bundle args = new Bundle();
     args.putInt(PAGE_NUMBER, sectionNumber);
     PlaceholderFragment fragment = new PlaceholderFragment();
     fragment.setArguments(args);
     return fragment;
  }

  public static class PlaceholderFragment extends Fragment {
    public PlaceholderFragment() { }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
       int section = getArguments().getInt(PAGE_NUMBER, 0);

       final View rootView;
       if (section == 1) {
         rootView = inflater.inflate(R.layout.content_patient, container, false);
       } else if (section == 2) {
         rootView = inflater.inflate(R.layout.content_triage, container, false);
       } else if (section == 3) {
         rootView = inflater.inflate(R.layout.content_lab, container, false);
       } else if (section == 4) {
         rootView = inflater.inflate(R.layout.content_wellness, container, false);
      } else {
        rootView = null;
      }

      return rootView;
    }
  }

  public class SectionsPagerAdapter extends FragmentPagerAdapter {

    public SectionsPagerAdapter(FragmentManager fm) {
      super(fm);
    }

    @Override
    public Fragment getItem(int position) {
      // getItem is called to instantiate the fragment for the given page.
      // Return a PlaceholderFragment (defined as a static inner class below).
      return newFragmentInstance(position + 1);
    }

    @Override
    public int getCount() {
      return NUM_PAGES;
    }

    @Override
    public CharSequence getPageTitle(int position) {
      if (0 <= position && position < PAGE_TITLES.length) {
        return PAGE_TITLES[position];
      }
      return null;
    }
  }

  private void extractValues(int tab) {
    LinearLayout layout;
    if (tab == 0) layout = findViewById(R.id.patient_layout);
    else if (tab == 1) layout = findViewById(R.id.triage_layout);
    else if (tab == 2) layout = findViewById(R.id.lab_layout);
    else layout = findViewById(R.id.wellness_layout);

    // Get all the radio buttons and then check which ones were clicked
    HashMap<String, RadioButton> allRadioButtons = Utils.getRadioButtonsInLayout(layout, null);
    for (String var: clickedRadioButtonTags) {
      RadioButton rb = allRadioButtons.get(var);
      if (rb == null) continue;
      String tag = (String)rb.getTag();
      if (tag == null) continue;
      String[] parts = tag.split(":");
      if (parts.length == 2) {
        String varName = parts[0];
        String valStr = parts[1].toLowerCase();
        try {
          values.put(varName, Float.parseFloat(valStr));
        } catch (NumberFormatException e) {
          values.put(varName, Float.NaN);
        }
      }
    }

    // Same for edit texts
    HashMap<String, EditText> allEditTexts = Utils.getEditTextsInLayout(layout, null);
    for (String var: clickedEditTextTags) {
      EditText et = allEditTexts.get(var);
      if (et == null) continue;
      String tag = (String)et.getTag();
      if (tag == null) continue;
      String varName = tag;
      String valStr = et.getText().toString();
      try {
        values.put(varName, Float.parseFloat(valStr));
      } catch (NumberFormatException e) {
        values.put(varName, Float.NaN);
      }
    }
  }
}
