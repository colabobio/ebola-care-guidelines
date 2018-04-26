package org.broadinstitute.ebolarisk;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TableRow;
import android.widget.TextView;

public class TreatFragment extends Fragment {
  private static final String ARG_SYMPTOM = "SYMPTOM";
  private static final String ARG_AGE_YEARS = "AGE_YEARS";
  private static final String ARG_AGE_MONTHS = "AGE_MONTHS";
  private static final String ARG_WEIGHT = "WEIGHT";

  private String symptom;
  private float ageYears;
  private float ageMonths;
  private float weight;

  private OnFragmentInteractionListener mListener;

  public static TreatFragment newInstance(String symptom, float ageYears, float ageMonths, float weight) {
    TreatFragment fragment = new TreatFragment();
    Bundle args = new Bundle();
    args.putString(ARG_SYMPTOM, symptom);
    args.putFloat(ARG_AGE_YEARS, ageYears);
    args.putFloat(ARG_AGE_MONTHS, ageMonths);
    args.putFloat(ARG_WEIGHT, weight);
    fragment.setArguments(args);
    return fragment;
  }

  public TreatFragment() {
    // Required empty public constructor
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    if (getArguments() != null) {
      symptom = getArguments().getString(ARG_SYMPTOM);
      ageYears = getArguments().getFloat(ARG_AGE_YEARS);
      ageMonths = getArguments().getFloat(ARG_AGE_MONTHS);
      weight = getArguments().getFloat(ARG_WEIGHT);
    }

    Log.e("------>", "create treatment fragment " + ageYears + " " + ageMonths + " " + weight);
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
                           Bundle savedInstanceState) {
    // Inflate the layout for this fragment
    Log.e("------>", "create view treatment fragment");
    TableRow row;
    View view = null;
    if (symptom.equals(TreatActivity.HIGH_VLOAD)) {
      view = inflater.inflate(R.layout.fragment_highvload, container, false);
    } else if (symptom.equals(TreatActivity.AGE)) {
      view = inflater.inflate(R.layout.fragment_age, container, false);
    } else

    if (symptom.equals(TreatActivity.JAUNDICE)) {
      view = inflater.inflate(R.layout.fragment_jaundice, container, false);
    } else if (symptom.equals(TreatActivity.BLEEDING)) {
      view = inflater.inflate(R.layout.fragment_bleeding, container, false);
    } else if (symptom.equals(TreatActivity.FEVER)) {
      view = inflater.inflate(R.layout.fragment_fever, container, false);
      row = getParacetamolRow(view, ageYears, ageMonths);
      selectRow(row);
      row = getAS_AQRow(view, ageYears, ageMonths, weight);
      selectRow(row);
      row = getALRow(view, ageYears, ageMonths, weight);
      selectRow(row);
      row = getDHP_PQPRow(view, weight);
      selectRow(row);
    } else if (symptom.equals(TreatActivity.DIARRHEA)) {
      view  = inflater.inflate(R.layout.fragment_diarrhea, container, false);
      row = getORSRow(view, ageYears, ageMonths, weight);
      selectRow(row);
      row = getZincRow(view, ageYears, ageMonths);
      selectRow(row);
    } else if (symptom.equals(TreatActivity.WEAKNESS)) {
      view = inflater.inflate(R.layout.fragment_weakness, container, false);
      row = getIVFluidRow(view, ageYears, ageMonths);
      selectRow(row);
    }

    // Negatively-correlated predictors (won't show up anyways)
    else if (symptom.equals(TreatActivity.HEADACHE)) {
      view = inflater.inflate(R.layout.fragment_headache, container, false);
    } else if (symptom.equals(TreatActivity.PAIN)) {
      view = inflater.inflate(R.layout.fragment_pain, container, false);
    } else if (symptom.equals(TreatActivity.VOMIT)) {
      view = inflater.inflate(R.layout.fragment_vomit, container, false);
    }

    return view;
  }

  // TODO: Rename method, update argument and hook method into UI event
  public void onButtonPressed(Uri uri) {
    if (mListener != null) {
      mListener.onFragmentInteraction(uri);
    }
  }

  @Override
  public void onAttach(Context context) {
    super.onAttach(context);
    if (context instanceof OnFragmentInteractionListener) {
      mListener = (OnFragmentInteractionListener) context;
    } else {
      throw new RuntimeException(context.toString()
              + " must implement OnFragmentInteractionListener");
    }
  }

  @Override
  public void onDetach() {
    super.onDetach();
    mListener = null;
  }

  private TableRow getORSRow(View view, Float ageYears, Float ageMonths, Float weight) {
    TableRow row = null;
    if (0 < weight) {
      if (weight < 5) {
        row = (TableRow) view.findViewById(R.id.ors_rowLess4Months_Less5Kg);
      } else if (5 <= weight && weight < 8) {
        row = (TableRow) view.findViewById(R.id.ors_row4To11Months_5To7_9Kg);
      } else if (8 <= weight && weight < 11) {
        row = (TableRow) view.findViewById(R.id.ors_row12To23Months_8To10_9Kg);
      } else if (11 <= weight && weight < 16) {
        row = (TableRow) view.findViewById(R.id.ors_row2To4Years_11To15_9Kg);
      } else if (16 <= weight && weight < 30) {
        row = (TableRow) view.findViewById(R.id.ors_row5To15Years_16To29_9Kg);
      } else {
        row = (TableRow) view.findViewById(R.id.ors_rowOver15Years_Over30Kg);
      }
    } else if (0 < ageMonths) {
      if (ageMonths < 4) {
        row = (TableRow) view.findViewById(R.id.ors_rowLess4Months_Less5Kg);
      } else if (4 <= ageMonths && ageMonths < 12) {
        row = (TableRow) view.findViewById(R.id.ors_row4To11Months_5To7_9Kg);
      } else if (12 <= ageMonths && ageMonths < 24) {
        row = (TableRow) view.findViewById(R.id.ors_row12To23Months_8To10_9Kg);
      } else if (12 * 2 <= ageMonths && ageMonths < 12 * 5) {
        row = (TableRow) view.findViewById(R.id.ors_row2To4Years_11To15_9Kg);
      } else if (12 * 5 <= ageMonths && ageMonths < 12 * 16) {
        row = (TableRow) view.findViewById(R.id.ors_row5To15Years_16To29_9Kg);
      } else {
        row = (TableRow) view.findViewById(R.id.ors_rowOver15Years_Over30Kg);
      }
    } else if (0 < ageYears) {
      if (1 <= ageYears && ageYears < 2) {
        row = (TableRow) view.findViewById(R.id.ors_row12To23Months_8To10_9Kg);
      } else if (2 <= ageYears && ageYears < 5) {
        row = (TableRow) view.findViewById(R.id.ors_row2To4Years_11To15_9Kg);
      } else if (5 <= ageYears && ageYears < 16) {
        row = (TableRow) view.findViewById(R.id.ors_row5To15Years_16To29_9Kg);
      } else if (16 <= ageYears) {
        row = (TableRow) view.findViewById(R.id.ors_rowOver15Years_Over30Kg);
      }
    }
    return row;
  }

  private TableRow getZincRow(View view, Float ageYears, Float ageMonths) {
    TableRow row = null;
    if (0 < ageMonths) {
      if (ageMonths <= 6) {
        row = (TableRow) view.findViewById(R.id.zinc_under6Months);
      } else {
        row = (TableRow) view.findViewById(R.id.zinc_over6Months);
      }
    } else if (0 < ageYears) {
      row = (TableRow) view.findViewById(R.id.zinc_over6Months);
    }
    return row;
  }

  private TableRow getIVFluidRow(View view, Float ageYears, Float ageMonths) {
    TableRow row = null;
    if (0 < ageMonths) {
      if (ageMonths <= 1) {
        row = (TableRow) view.findViewById(R.id.ivfluid_under12Months);
      } else {
        row = (TableRow) view.findViewById(R.id.ivfluid_older12Months);
      }
    } else if (0 < ageYears) {
      if (1 <= ageYears) {
        row = (TableRow) view.findViewById(R.id.ivfluid_older12Months);
      } else {
        row = (TableRow) view.findViewById(R.id.ivfluid_under12Months);
      }
    }
    return row;
  }

  private TableRow getParacetamolRow(View view, Float ageYears, Float ageMonths) {
    TableRow row = null;
    if (0 < ageMonths) {
      if (6 <= ageMonths && ageMonths < 2 * 12) {
        row = (TableRow) view.findViewById(R.id.param_row6monthsTo2years);
      } else if (12 * 2 <= ageMonths && ageMonths < 12 * 6) {
        row = (TableRow) view.findViewById(R.id.param_row2To5years);
      } else if (12 * 6 <= ageMonths && ageMonths < 12 * 10) {
        row = (TableRow) view.findViewById(R.id.param_row6To9years);
      } else if (12 * 10 <= ageMonths && ageMonths < 12 * 16) {
        row = (TableRow) view.findViewById(R.id.param_row10To15years);
      } else if (12 * 16 <= ageMonths) {
        row = (TableRow) view.findViewById(R.id.param_rowOver15years);
      }
    } else if (0 < ageYears) {
      if (0.5 <= ageYears && ageYears < 2) {
        row = (TableRow) view.findViewById(R.id.param_row6monthsTo2years);
      } else if (2 <= ageYears && ageYears < 6) {
        row = (TableRow) view.findViewById(R.id.param_row2To5years);
      } else if (6 <= ageYears && ageYears < 10) {
        row = (TableRow) view.findViewById(R.id.param_row6To9years);
      } else if (10 <= ageYears && ageYears < 16) {
        row = (TableRow) view.findViewById(R.id.param_row10To15years);
      } else if (16 <= ageYears) {
        row = (TableRow) view.findViewById(R.id.param_rowOver15years);
      }
    }
    return row;
  }

  private TableRow getAS_AQRow(View view, Float ageYears, Float ageMonths, Float weight) {
    TableRow row = null;
    if (0 < weight) {
      if (5 <= weight && weight < 9) {
        row = (TableRow) view.findViewById(R.id.asaq_row2To11Months_5To9kg);
      } else if (9 <= weight && weight < 19) {
        row = (TableRow) view.findViewById(R.id.asaq_row1To5Years_9To18kg);
      } else if (19 <= weight && weight < 35) {
        row = (TableRow) view.findViewById(R.id.asaq_row6To13Years_19To35kg);
      } else if (35 <= weight) {
        row = (TableRow) view.findViewById(R.id.asaq_rowOver14Years_Over35kg);
      }
    } else if (0 < ageMonths) {
      if (2 <= ageMonths && ageMonths < 12) {
        row = (TableRow) view.findViewById(R.id.asaq_row2To11Months_5To9kg);
      } else if (12 <= ageMonths && ageMonths < 12 * 6) {
        row = (TableRow) view.findViewById(R.id.asaq_row1To5Years_9To18kg);
      } else if (12 * 6 <= ageMonths && ageMonths < 12 * 14) {
        row = (TableRow) view.findViewById(R.id.asaq_row6To13Years_19To35kg);
      } else if (12 * 14 <= ageMonths) {
        row = (TableRow) view.findViewById(R.id.asaq_rowOver14Years_Over35kg);
      }
    } else if (0 < ageYears) {
      if (1 <= ageYears && ageYears < 6) {
        row = (TableRow) view.findViewById(R.id.asaq_row1To5Years_9To18kg);
      } else if (6 <= ageYears && ageYears < 14) {
        row = (TableRow) view.findViewById(R.id.asaq_row6To13Years_19To35kg);
      } else if (14 <= ageYears) {
        row = (TableRow) view.findViewById(R.id.asaq_rowOver14Years_Over35kg);
      }
    }
    return row;
  }

  private TableRow getALRow(View view, Float ageYears, Float ageMonths, Float weight) {
    TableRow row = null;
    if (0 < weight) {
      if (5 <= weight && weight < 15) {
        row = (TableRow) view.findViewById(R.id.al_row2To24Months_5To15kg);
      } else if (15 <= weight && weight < 25) {
        row = (TableRow) view.findViewById(R.id.al_row2To7Years_15To25kg);
      } else if (25 <= weight && weight < 35) {
        row = (TableRow) view.findViewById(R.id.al_row8To13Years_25To35kg);
      } else if (35 <= weight) {
        row = (TableRow) view.findViewById(R.id.al_rowOver14Years_Over35kg);
      }
    } else if (0 < ageMonths) {
      if (2 <= ageMonths && ageMonths < 24) {
        row = (TableRow) view.findViewById(R.id.al_row2To24Months_5To15kg);
      } else if (2 * 12 <= ageMonths && ageMonths < 12 * 8) {
        row = (TableRow) view.findViewById(R.id.al_row2To7Years_15To25kg);
      } else if (12 * 8 <= ageMonths && ageMonths < 12 * 14) {
        row = (TableRow) view.findViewById(R.id.al_row8To13Years_25To35kg);
      } else if (12 * 14 <= ageMonths) {
        row = (TableRow) view.findViewById(R.id.al_rowOver14Years_Over35kg);
      }
    } else if (0 < ageYears) {
      if (1 <= ageYears && ageYears < 2) {
        row = (TableRow) view.findViewById(R.id.al_row2To24Months_5To15kg);
      } else if (2 <= ageYears && ageYears < 8) {
        row = (TableRow) view.findViewById(R.id.al_row2To7Years_15To25kg);
      } else if (8 <= ageYears && ageYears < 14) {
        row = (TableRow) view.findViewById(R.id.al_row8To13Years_25To35kg);
      } else if (14 <= ageYears) {
        row = (TableRow) view.findViewById(R.id.al_rowOver14Years_Over35kg);
      }
    }
    return row;
  }

  private TableRow getDHP_PQPRow(View view, Float weight) {
    TableRow row = null;
    if (0 < weight) {
      if (11 <= weight && weight < 17) {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_row11o16kg);
      } else if (17 <= weight && weight < 25) {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_row17o24kg);
      } else if (25 <= weight && weight < 36) {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_row25o35kg);
      } else if (36 <= weight && weight < 60) {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_row36o59kg);
      } else if (60 <= weight && weight < 80) {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_row60o79kg);
      } else {
        row = (TableRow) view.findViewById(R.id.dhp_pqp_rowOver80kg);
      }
    }
    return row;
  }

  private void selectRow(TableRow row) {
    if (row != null) {
      int colorBck = ContextCompat.getColor(getContext(), R.color.table_selection_background);
      int colorTxt = ContextCompat.getColor(getContext(), R.color.table_selection_text);
      for (int index = 0; index < row.getChildCount(); index++) {
        TextView text = (TextView) row.getChildAt(index);
        text.setBackgroundColor(colorBck);
        text.setTextColor(colorTxt);
      }
    }
  }

  /**
   * This interface must be implemented by activities that contain this
   * fragment to allow an interaction in this fragment to be communicated
   * to the activity and potentially other fragments contained in that
   * activity.
   * <p/>
   * See the Android Training lesson <a href=
   * "http://developer.android.com/training/basics/fragments/communicating.html"
   * >Communicating with Other Fragments</a> for more information.
   */
  public interface OnFragmentInteractionListener {
    // TODO: Update argument type and name
    void onFragmentInteraction(Uri uri);
  }
}
