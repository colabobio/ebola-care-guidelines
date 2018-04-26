package org.broadinstitute.ebolarisk;

import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

public class TreatActivity extends FragmentActivity implements TreatFragment.OnFragmentInteractionListener {
  final static public String SYMPTOM    = "SYMPTOM_EXTRA";
  final static public String AGE_YEARS  = "AGE_YEARS_EXTRA";
  final static public String AGE_MONTHS = "AGE_MONTHS_EXTRA";
  final static public String WEIGHT     = "WEIGHT_EXTRA";

  final static public String HIGH_VLOAD = "high_vload";
  final static public String AGE        = "age";
  final static public String FEVER      = "fever";
  final static public String DIARRHEA   = "diarrhea";
  final static public String VOMIT      = "vomit";
  final static public String JAUNDICE   = "jaundice";
  final static public String BLEEDING   = "bleeding";
  final static public String HEADACHE   = "headache";
  final static public String PAIN       = "pain";
  final static public String WEAKNESS   = "weakness";

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_treatment);

    String symptom;
    Float ageYears, ageMonths;
    Float weight;
    if (savedInstanceState == null) {
      Bundle extras = getIntent().getExtras();
      if(extras == null) {
        symptom = null;
        ageYears = null;
        ageMonths = null;
        weight = null;
      } else {
        symptom = extras.getString(SYMPTOM);
        ageYears = (Float)extras.get(AGE_YEARS);
        ageMonths = (Float)extras.get(AGE_MONTHS);
        weight = (Float)extras.get(WEIGHT);
      }
    } else {
      symptom = (String) savedInstanceState.getSerializable(SYMPTOM);
      ageYears = (Float) savedInstanceState.getSerializable(AGE_YEARS);
      ageMonths = (Float) savedInstanceState.getSerializable(AGE_MONTHS);
      weight = (Float) savedInstanceState.getSerializable(WEIGHT);
    }
    float fageYears, fageMonths, fweight;
    fageYears = ageYears == null ? 0 : ageYears.floatValue();
    fageMonths = ageMonths == null ? 0 : ageMonths.floatValue();
    fweight = weight == null ? 0 : weight.floatValue();

    FragmentManager fragmentManager = getSupportFragmentManager();
    FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
    TreatFragment fragment = TreatFragment.newInstance(symptom, fageYears, fageMonths, fweight);
    fragmentTransaction.add(R.id.treatment_content, fragment);
    fragmentTransaction.commit();
  }

  public void onFragmentInteraction(Uri uri) {

  }
}
