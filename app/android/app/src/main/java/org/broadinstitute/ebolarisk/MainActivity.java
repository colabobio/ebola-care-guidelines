package org.broadinstitute.ebolarisk;

import android.support.design.widget.TabLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.widget.RadioButton;
import android.widget.EditText;
import android.text.TextWatcher;
import android.text.Editable;
import android.content.Intent;

import processing.core.PApplet;

public class MainActivity extends AppCompatActivity {

  static private final int NUM_PAGES = 4;
  static private final String[] PAGE_TITLES = {"INFO", "VITALS", "CLINICAL", "LAB"};
  static private final String PAGE_NUMBER = "page_number";

  /**
   * The {@link android.support.v4.view.PagerAdapter} that will provide
   * fragments for each of the sections. We use a
   * {@link FragmentPagerAdapter} derivative, which will keep every
   * loaded fragment in memory. If this becomes too memory intensive, it
   * may be best to switch to a
   * {@link android.support.v4.app.FragmentStatePagerAdapter}.
   */
  private SectionsPagerAdapter mSectionsPagerAdapter;

  /**
   * The {@link ViewPager} that will host the section contents.
   */
  private ViewPager mViewPager;

//    private static PredSketch sketch;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);

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
      }

      @Override
      public void onTabReselected(TabLayout.Tab tab) {
      }
    });

    DataHolder.loadModels(getAssets());
/*
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.risk_button);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
//                        .setAction("Action", null).show();
            }
        });
*/
    }

  public void riskButton(View view) {
    Intent i = new Intent(this, RiskActivity.class);
//    i.putExtra(InfoActivity.LAUNCH_MAIN, this);
    startActivity(i);
  }

  public void onRadioButtonClicked(View view) {
    boolean checked = ((RadioButton) view).isChecked();

    // Check which radio button was clicked
    int id = view.getId();

    // Triage data
    if (id == R.id.diaRadioButtonYes) {
      DataHolder.getInstance().setData("Diarrhoea", true);
    } else if (id == R.id.diaRadioButtonNo) {
      DataHolder.getInstance().setData("Diarrhoea", false);
    } else if (id == R.id.diaRadioButtonNA) {
      DataHolder.getInstance().remData("Diarrhoea");
    } else if (id == R.id.weakRadioButtonYes) {
      DataHolder.getInstance().setData("AstheniaWeakness", true);
    } else if (id == R.id.weakRadioButtonNo) {
      DataHolder.getInstance().setData("AstheniaWeakness", false);
    } else if (id == R.id.weakRadioButtonNA) {
      DataHolder.getInstance().remData("AstheniaWeakness");
    } else if (id == R.id.jaunRadioButtonYes) {
      DataHolder.getInstance().setData("Jaundice", true);
    } else if (id == R.id.jaunRadioButtonNo) {
      DataHolder.getInstance().setData("Jaundice", false);
    } else if (id == R.id.jaunRadioButtonNA) {
      DataHolder.getInstance().remData("Jaundice");
    } else if (id == R.id.bleedRadioButtonYes) {
      DataHolder.getInstance().setData("Bleeding", true);
    } else if (id == R.id.bleedRadioButtonNo) {
      DataHolder.getInstance().setData("Bleeding", false);
    } else if (id == R.id.bleedRadioButtonNA) {
      DataHolder.getInstance().remData("Bleeding");
    } else if (id == R.id.headRadioButtonYes) {
      DataHolder.getInstance().setData("Headache", true);
    } else if (id == R.id.headRadioButtonNo) {
      DataHolder.getInstance().setData("Headache", false);
    } else if (id == R.id.headRadioButtonNA) {
      DataHolder.getInstance().remData("Headache");
    } else if (id == R.id.vomRadioButtonYes) {
      DataHolder.getInstance().setData("Vomit", true);
    } else if (id == R.id.vomRadioButtonNo) {
      DataHolder.getInstance().setData("Vomit", false);
    } else if (id == R.id.vomRadioButtonNA) {
      DataHolder.getInstance().remData("Vomit");
    } else if (id == R.id.abdRadioButtonYes) {
      DataHolder.getInstance().setData("AbdominalPain", true);
    } else if (id == R.id.abdRadioButtonNo) {
      DataHolder.getInstance().setData("AbdominalPain", false);
    } else if (id == R.id.abdRadioButtonNA) {
      DataHolder.getInstance().remData("AbdominalPain");
    }

//      // Rounding data
//      } else if (id == R.id.disRRadioButtonYes) {
//          setData("DisorientationConfused_R", true);
//      } else if (id == R.id.disRRadioButtonNo) {
//          setData("DisorientationConfused_R", false);
//      } else if (id == R.id.disRRadioButtonNA) {
//          remData("DisorientationConfused_R");
//      } else if (id == R.id.bleedRRadioButtonYes) {
//          setData("Bleeding_R", true);
//      } else if (id == R.id.bleedRRadioButtonNo) {
//          setData("Bleeding_R", false);
//      } else if (id == R.id.bleedRRadioButtonNA) {
//          remData("Bleeding_R");
//      } else if (id == R.id.diaRRadioButtonYes) {
//          setData("Diarrhoea_R", true);
//      } else if (id == R.id.diaRRadioButtonNo) {
//          setData("Diarrhoea_R", false);
//      } else if (id == R.id.diaRRadioButtonNA) {
//          remData("Diarrhoea_R");
//      } else if (id == R.id.reyesRRadioButtonYes) {
//          setData("RedInjectedEyes_R", true);
//      } else if (id == R.id.reyesRRadioButtonNo) {
//          setData("RedInjectedEyes_R", false);
//      } else if (id == R.id.reyesRRadioButtonNA) {
//          remData("RedInjectedEyes_R");
//      } else if (id == R.id.otherRRadioButtonYes) {
//          setData("NoSymptoms_R", false);
//      } else if (id == R.id.otherRRadioButtonNo) {
//          setData("NoSymptoms_R", true);
//      } else if (id == R.id.otherRRadioButtonNA) {
//          remData("NoSymptoms_R");

      // Wellness data
//      } else if (id == R.id.ws0RadioButton && checked) {
//        setData("WellnessScale", 0);
//      } else if (id == R.id.ws1RadioButton && checked) {
//        setData("WellnessScale", 1);
//      } else if (id == R.id.ws2RadioButton && checked) {
//        setData("WellnessScale", 2);
//      } else if (id == R.id.ws3RadioButton && checked) {
//        setData("WellnessScale", 3);
//      } else if (id == R.id.ws4RadioButton && checked) {
//        setData("WellnessScale", 4);
//      } else if (id == R.id.ws5RadioButton && checked) {
//        setData("WellnessScale", 5);
//      } else if (id == R.id.wsNARadioButton) {
//        remData("WellnessScale");
//      }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    int id = item.getItemId();

    //noinspection SimplifiableIfStatement
    if (id == R.id.action_settings) {
      Intent i = new Intent(this, PrefActivity.class);
      startActivity(i);
    } else if (id == R.id.action_info) {
      Intent i = new Intent(this, InfoActivity.class);
      i.putExtra(InfoActivity.LAUNCH_MAIN, false);
      startActivity(i);
    }

    return super.onOptionsItemSelected(item);
  }

  /**
   * Returns a new instance of this fragment for the given section
   * number.
   */
  public static Fragment newFragmentInstance(int sectionNumber) {
     Bundle args = new Bundle();
     args.putInt(PAGE_NUMBER, sectionNumber);
     PlaceholderFragment fragment = new PlaceholderFragment();
     fragment.setArguments(args);
     return fragment;
//       if (sectionNumber < NUM_PAGES) {
//           PlaceholderFragment fragment = new PlaceholderFragment();
//           fragment.setArguments(args);
//           return fragment;
//       } else {
//           PFragment fragment = new PFragment();
//           if (sketch == null) {
//             sketch = new PredSketch();
//             Log.e("----->", "CREATE SKETCH");
//           }
//           fragment.setSketch(sketch);
//           fragment.setArguments(args);
//           return fragment;
//       }
  }

  /**
   * A placeholder fragment containing a simple view.
   */
  public static class PlaceholderFragment extends Fragment {
//    MainActivity listener;

    public PlaceholderFragment() { }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
       int section = getArguments().getInt(PAGE_NUMBER, 0);

       final View rootView;
       if (section == 1) {
         rootView = inflater.inflate(R.layout.fragment_info, container, false);
         setInfoChanges(rootView);
       } else if (section == 2) {
         rootView = inflater.inflate(R.layout.fragment_vitals, container, false);
         setVitalsChanges(rootView);
       } else if (section == 3) {
         rootView = inflater.inflate(R.layout.fragment_signs_symptoms, container, false);
       } else if (section == 4) {
         rootView = inflater.inflate(R.layout.fragment_lab, container, false);
         setLabChanges(rootView);
      } else {
        rootView = null;
      }

      return rootView;
    }

    private void setInfoChanges(final View rootView) {
      EditText ageYearsEditText = (EditText) rootView.findViewById(R.id.ageYearsEditText);
      ageYearsEditText.addTextChangedListener(new TextWatcher() {
        public void afterTextChanged(Editable s) {
          float value = PApplet.parseFloat(s.toString());
          DataHolder.getInstance().setData("PatientAge", value);
        }
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
      });

      EditText ageMonthsEditText = (EditText) rootView.findViewById(R.id.ageMonthsEditText);
      ageMonthsEditText.addTextChangedListener(new TextWatcher() {
        public void afterTextChanged(Editable s) {
          float value = PApplet.parseFloat(s.toString());
          DataHolder.getInstance().setDataExtra("PatientAgeMonths", value);
          if (!Float.isNaN(value)) {
            DataHolder.getInstance().setData("PatientAge", value / 12);
          }
        }
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
      });

      EditText weightEditText = (EditText) rootView.findViewById(R.id.weightEditText);
      weightEditText.addTextChangedListener(new TextWatcher() {
        public void afterTextChanged(Editable s) {
          float value = PApplet.parseFloat(s.toString());
          DataHolder.getInstance().setDataExtra("PatientWeight", value);
        }
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
      });
    }

    private void setVitalsChanges(final View rootView) {
      EditText tempEditText = (EditText) rootView.findViewById(R.id.tempEditText);
      tempEditText.addTextChangedListener(new TextWatcher() {
        public void afterTextChanged(Editable s) {
          float value = PApplet.parseFloat(s.toString());
          DataHolder.getInstance().setData("FeverTemperature", value);
        }
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
      });
    }

    private void setLabChanges(final View rootView) {
      EditText ctEditText = (EditText) rootView.findViewById(R.id.ctEditText);
      ctEditText.addTextChangedListener(new TextWatcher() {
        public void afterTextChanged(Editable s) {
          float value = PApplet.parseFloat(s.toString());
          DataHolder.getInstance().setData("cycletime", value);
        }
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
      });
    }

//    @Override
//    public void onAttach(Context context) {
//      super.onAttach(context);
//      if (context instanceof MainActivity) {
//        // onAttach() is called before onCreateView(), so the listener will be non-null by then.
//        listener = (MainActivity)context;
//      } else {
//        throw new RuntimeException(context.toString() + " context is not main activity");
//      }
//    }
  }

  /**
   * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
   * one of the sections/tabs/pages.
   */
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
}
