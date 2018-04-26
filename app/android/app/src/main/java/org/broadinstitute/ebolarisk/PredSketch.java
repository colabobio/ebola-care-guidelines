package org.broadinstitute.ebolarisk;

import processing.core.PApplet;

import android.content.Intent;

import processing.core.PFont;

import java.util.HashMap;
import android.content.SharedPreferences;
import android.util.Log;

public class PredSketch extends PApplet {
  static int FLOAT = 0;
  static int INT = 1;
  static int BINARY = 2;

  PFont titleFont;
  PFont labelFont;
  PFont valueFont;
  PFont textFont;

  float translateY = 0;
//  float density;

  // Some UI elements
  float scrollWidth = 5;
  float shadowHeight = 70;
  ScrollBar scrollbar;
  ScrollShadow topShadow;
  ScrollShadow botShadow;

  String[] varOrder = { "cycletime", "PatientAge", "FeverTemperature",
                        "Jaundice", "Bleeding", "Headache",
                        "Diarrhoea", "Vomit",
                        "AbdominalPain", "AstheniaWeakness",
                        "WellnessScale" };

  String[] varAlias = { "PCR CT", "Age", "Temperature",
                        "Jaundice", "Bleeding", "Headache",
                        "Diarrhoea", "Vomiting",
                        "Abdomen pain", "Weakness",
                        "Wellness" };

  String[] varSymptom = { "Viral load", "Age", "Fever",
                          "Jaundice", "Bleeding", "Headache",
                          "Diarrhoea", "Vomiting",
                          "Abdomen pain", "Weakness",
                          "Wellness" };

  int[] varTypes = { INT, INT, FLOAT,
                     BINARY, BINARY, BINARY,
                     BINARY, BINARY,
                     BINARY, BINARY,
                     INT };

  String[] binLabels = {"no", "yes"};

  HashMap<String, Float> data = null;
  HashMap<String, Float> extra = null;
  HashMap<String, Float[]> details = null;
  float score = 0;
  float risk = 0;
  float riskThreshold = 0;
  float contribThreshold = 0;
  float totHeight = 0;
  boolean showTreatment;
  LogRegModel model;

  public void update(LogRegModel selModel, HashMap<String, Float> floatVars,
                     HashMap<String, Float> floatExtra, SharedPreferences prefs) {
    model = selModel;
    if (model != null) {
      showTreatment = prefs.getString("vizOption", "treat").equals("treat");
      riskThreshold = parseFloat(prefs.getString("riskThreshold", "0.5"));
      contribThreshold = parseFloat(prefs.getString("contribThreshold", "0.1"));

      data = floatVars;
      extra = floatExtra;
      score = model.evalScore(data);
      risk = model.eval(data);
      details = model.evalDetails(data);

      highRisk = riskThreshold <= risk;
      riskMsg = highRisk ?
        "Based on presentation signs, symptoms, and PCR data, this patient has " +
        "more than " + (int)(100 * riskThreshold) + "% chance of dying. Reassess for emergency " +
        "clinical signs, monitor input and output by the bedside, and perform priority lab testing " +
        "if possible."
        :
        "Based on presentation signs, symptoms, and PCR data, this patient has " +
        "less than " + (int)(100 * riskThreshold) + "% chance of dying. Make sure the patient " +
        "remains stable, by keeping him or her hydrated and taking care of any clinical signs " +
        "with the appropriate procedure.";

      totHeight = getHeaderHeight() + getBodyHeight();
      marginRight = getMarginRight();
      System.out.println("===================== Updated risk");
      Log.e("----->", "Risk: " + risk);
      Log.e("----->", "riskThreshold: " + riskThreshold);
      Log.e("----->", "data: " + data.size());
      Log.e("----->", "details: " + details.size());
      Log.e("----->", "totHeight: " + totHeight);
    }
  }

  public void settings() {
//    parentLayout = R.layout.fragment_risk;
    fullScreen(P2D);
  }

  // Parameters of the symptoms viz
  float marginRight;

  float riskHeight = 50;
  float marginLeft = 20;
  float varHeight = 85;
  float barHeight = 50;
  float lineWidth = 2;
  float colSpacing = 5;

  // Parameters of the treatment viz
  float margin = 30;
  float margin2 = 50;
  float textTab = 10;
  float rowSpacing = 10;
  float padding = 10;
  float crossSize = 30;
  int numContrib;
  boolean highRisk;
  String riskMsg;

  // Fonts
  float titleFontSize = 28;
  float labelFontSize = 26;
  float valueFontSize = 20;
  float textFontSize = 18;

  private void scaleDimensions() {
    riskHeight *= displayDensity;
    marginLeft *= displayDensity;
    marginRight *= displayDensity;
    varHeight *= displayDensity;
    barHeight *= displayDensity;
    lineWidth *= displayDensity;
    colSpacing *= displayDensity;

    margin *= displayDensity;
    margin2 *= displayDensity;
    textTab *= displayDensity;
    rowSpacing *= displayDensity;
    padding *= displayDensity;
    crossSize *= displayDensity;

    titleFontSize *= displayDensity;
    labelFontSize *= displayDensity;
    valueFontSize *= displayDensity;
    textFontSize *= displayDensity;
  }

  public void setup() {
//    TabLayout toolbar = (TabLayout) surface.getResource(R.id.tabs);
//    Rect frame = surface.getVisibleFrame();
//    padding = frame.bottom - (int)(frame.top + toolbar.getY() + toolbar.getHeight() + height);
//    padding = 0;
//    navHeight = getNavBarHeight();
//    navHeight = 0;
    orientation(PORTRAIT);

//    density = getActivity().getResources().getDisplayMetrics().density;
    scaleDimensions();

    titleFont = createFont("Roboto", titleFontSize);
    labelFont = createFont("Roboto", labelFontSize);
    valueFont = createFont("Roboto", valueFontSize);
    textFont = createFont("Roboto", textFontSize);
    if (totHeight <= 0) {
      totHeight = getHeaderHeight() + getBodyHeight();
    }
    if (marginRight <= 0) {
      marginRight = getMarginRight();
    }

    scrollbar = new ScrollBar(scrollWidth);
    topShadow = new ScrollShadow(shadowHeight, false);
    botShadow = new ScrollShadow(shadowHeight, true);
  }

  public void draw() {
    background(245);
    if (model == null || data == null) {
      drawNoData();
    } else {
      pushMatrix();
      translate(0, translateY);

      if (showTreatment) {
        drawSimpTreat();
      } else {
        drawDetPred();
      }
      popMatrix(); // FIXME: popMatrix in PGraphicsAndroid2D crashes app when closing another activity
    }

    scrollbar.draw();
    topShadow.draw();
    botShadow.draw();

//      if (stopDraggingTop) {
//        fill(255, 0 , 0);
//        rect(0, 0, width, 100);
//      }
//      if (stopDraggingBot) {
//        fill(255, 0 , 0);
//        rect(0, height - 100, width, 100);
//      }

  }

  private void drawNoData() {
    String errorMsg1 = "Not enough information!";
    String errorMsg2 = "You need to provide at least patient's age and RT-PCR Cycle Threshold (CT) value.";

    noStroke();
    textAlign(CENTER, CENTER);
    textFont(titleFont);
    float hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
    float yBox = 0.3f * height - hBox/2;
    fill(0xFFD47272);
    rect(0, yBox, width, hBox);
    fill(255);
    text(errorMsg1, 0, yBox, width, hBox);

    yBox += hBox + 20 * displayDensity;

    textFont(labelFont);
    float wTot = textWidth(errorMsg2);
    int nlines = (int)(wTot/(width - 2 * margin));
    hBox = nlines * (textAscent() + textDescent() + g.textLeading);

    fill(0xFF6F6F6F);
    text(errorMsg2, margin, yBox, width - 2 * margin, hBox);
  }

  private void drawDetPred() {
    float yTop = 0;

    fill(0xFF00A79D);
    textAlign(CENTER, CENTER);
    textFont(labelFont);
    float hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
    rect(0, yTop, width, hBox);
    fill(240);
    text("Mortality risk of patient", 0, yTop, width, hBox);
    yTop += hBox + 2 * padding;

    float barWidth = width - marginLeft - marginRight;
    float cellW = PApplet.round(barWidth / 50);
    noStroke();
    float x = marginLeft;
    colorMode(HSB, 360, 100, 100);
    for (int i = 0; i < 50; i++) {
      fill(5, map(i, 0, 50, 0, 80), 67);
      rect(x, yTop, cellW, riskHeight);
      x += cellW;
    }
    if (x < marginLeft + barWidth) {
      fill(5, 80, 67);
      rect(x, yTop, marginLeft + barWidth - x, riskHeight);
    }
    colorMode(RGB, 255);

    float riskX = map(risk, 0, 1, marginLeft, marginLeft + barWidth);
    stroke(0);
    strokeWeight(lineWidth);
    line(riskX, yTop + 2 * displayDensity, riskX, yTop + riskHeight - 2 * displayDensity);

    textAlign(LEFT, CENTER);
    fill(0xFF6F6F6F);
    textFont(valueFont);
    String riskStr = (int)(risk * 100) + "%";
    text(riskStr, marginLeft + barWidth + cellW + colSpacing, yTop, marginRight - colSpacing, riskHeight);

    yTop += riskHeight + 2 * padding;

    stroke(0x606F6F6F);
    strokeWeight(lineWidth);
    line(marginLeft, yTop - riskHeight - 4 * padding, marginLeft, yTop);

    noStroke();
    fill(0xFF00A79D);
    textAlign(CENTER, CENTER);
    textFont(valueFont);
    hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
    rect(0, yTop, width, hBox);
    fill(240);
    text("Contribution from each predictor", 0, yTop, width, hBox);
    yTop += hBox + padding;

    stroke(0x606F6F6F);
    strokeWeight(lineWidth);
    line(marginLeft, yTop - padding, marginLeft, yTop);

    textFont(valueFont);
    textAlign(LEFT, CENTER);
    for (int i = 0; i < varOrder.length; i++) {
      String var = varOrder[i];
      if (details.containsKey(var)) {
        int type = varTypes[i];
        String alias = varAlias[i];
        Float[] det = details.get(var);
        float value = det[0];
        float scaledContrib = det[2];
        float scaledRange = det[3];

        noStroke();
        fill(160);
        float barY = yTop + varHeight/2 - barHeight/2;
        rect(marginLeft, barY, scaledContrib * barWidth, barHeight);

        stroke(0xFF6F6F6F);
        strokeWeight(lineWidth);
        float lineX = marginLeft + scaledRange * barWidth;
        float lineY = yTop + varHeight/2;
        line(marginLeft, lineY, lineX, lineY);
        line(lineX, lineY - barHeight/4, lineX, lineY + barHeight/4);

        fill(0xFF6F6F6F);
        String valueStr;
        if (type == BINARY) {
          valueStr = binLabels[(int)value];
        } else if (type == INT) {
          valueStr = new Integer((int)value).toString();
        } else {
          valueStr = PApplet.nfc(value, 1);
        }
        text(alias + " " + valueStr, marginLeft + barWidth + colSpacing, barY, marginRight - colSpacing, barHeight);

        yTop += varHeight;

        stroke(0x606F6F6F);
        strokeWeight(lineWidth);
        line(marginLeft, yTop - varHeight, marginLeft, yTop);
      }
    }
  }

  public void drawSimpTreat() {
    noStroke();
    if (highRisk) fill(0xFFE34242);
    else fill(0xFFEAA147);

    textAlign(CENTER, CENTER);
    textFont(titleFont);
    float yTop = 0;
    float hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
    rect(0, 0, width, hBox);
    fill(255);
    if (highRisk) text("HIGH RISK PATIENT", 0, 0, width, hBox);
    else text("LOW/MEDIUM RISK PATIENT", 0, 0, width, hBox);
    yTop += hBox + padding;

    textAlign(LEFT, CENTER);
    textFont(textFont);
    fill(0xFF4D4D4D);
    float wTot = textWidth(riskMsg);
    int nlines = (int)(wTot/(width - 2 * margin));
    hBox = nlines * (textAscent() + textDescent() + g.textLeading);
    text(riskMsg, margin, yTop, width - 2 * margin, hBox);
    yTop += hBox + padding;

    if (numContrib == 0) return;

    fill(0xFF6F6F6F);
    textAlign(CENTER, CENTER);
    textFont(labelFont);
    hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
    rect(0, yTop, width, hBox);
    fill(255);
    if (highRisk) text("This elevated risk is due to:", 0, yTop, width, hBox);
    else text("This risk is due to:", 0, yTop, width, hBox);
    yTop += hBox + padding;

    textFont(valueFont);
    textAlign(LEFT, CENTER);
    float mx = mouseX;
    float my = mouseY - translateY;
    for (int i = 0; i < varOrder.length; i++) {
      String var = varOrder[i];
      if (details.containsKey(var)) {
        int type = varTypes[i];
        String label = varSymptom[i];
        Float[] det = details.get(var);
//        float value = det[0];
        float scaledContrib = det[2];
        float scaledRange = det[3];
        float coeff0 = det[4];
        float frac = scaledContrib/scaledRange;
        if (contribThreshold < frac && (type != BINARY || coeff0 > 0)) {
          float x = margin2;
          float y = yTop + rowSpacing;
          float w = width - 2 * margin2;
          float h = varHeight - 2 * rowSpacing;
          stroke(0xFF6F6F6F);
          if (!dragging && mousePressed && x <= mx && mx <= x + w && y <= my && my <= y + h) {
            fill(0xFFD6D6D6);
          } else {
            noFill();
          }
          rect(x, y, w, h);
          fill(0xFF6F6F6F);
//          if (label.equals("Age")) {
//            if (value < 30) label = "Young age";
//            else label = "Advanced age";
//          }
          text(label, margin2 + textTab, yTop + rowSpacing, width - 2 * margin2, varHeight - 2 * rowSpacing);

          drawCross(width - margin2 - crossSize - textTab, yTop + varHeight/2, crossSize, highRisk ? 0xFFE34242 : 0xFFEAA147);
          yTop += varHeight;
        }
      }
    }
  }

  private void drawCross(float x, float y, float s, int c) {
    pushStyle();
    rectMode(CENTER);
    noStroke();
    fill(c);
    rect(x, y, s, s/2);
    rect(x, y, s/2, s);
    popStyle();
  }

  int pressSel = -1;
  int relSel = -1;
  boolean dragging = false;
  boolean stopDraggingBot;
  boolean stopDraggingTop;

  public void mousePressed() {
    if (showTreatment) {
      pressSel = selectSymptom();
    }
  }

  public void mouseDragged() {
    float dy = mouseY - pmouseY;
    if (totHeight + translateY + dy <= height) {
      if (dy > 0) {
        // Trying to drag up
        if (translateY >= 0) {
          // No need to drag anymore, already at the top
          stopDraggingTop = true;
        } else {
          translateY += dy;
          if (translateY > 0) translateY = 0;
        }
      } else {
        // No need to drag anymore, already at the bottom
        stopDraggingBot = true;
      }
    } else {
      if (dy > 0) {
        if (translateY >= 0) {
          // No need to drag anymore, already at the top
          stopDraggingTop = true;
        } else {
          translateY += dy;
          if (translateY > 0) translateY = 0;
        }
      } else {
        if (totHeight + translateY + dy < height) {
          // Constraining to end exactly at the bottom.
          dy = height - (totHeight + translateY);
        }
        translateY += dy;
      }
    }
    if (!dragging) {
      scrollbar.open();
    }
    dragging = true;
  }

  public void mouseReleased() {
    if (showTreatment) {
      relSel = selectSymptom();
      if (relSel != -1 && pressSel == relSel) {
        startTreatActivity(relSel);
      }
    }
    scrollbar.close();
    dragging = false;
    stopDraggingTop = false;
    stopDraggingBot = false;
  }

  private void startTreatActivity(int i) {
    String var = varOrder[i];
    Intent intent = new Intent(getActivity(), TreatActivity.class);

    if (var.equals("cycletime")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.HIGH_VLOAD);
    } else if (var.equals("PatientAge")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.AGE);
    } else if (var.equals("FeverTemperature")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.FEVER);
    } else if (var.equals("Jaundice")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.JAUNDICE);
    } else if (var.equals("Bleeding")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.BLEEDING);
    } else if (var.equals("Headache")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.HEADACHE);
    } else if (var.equals("Diarrhoea")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.DIARRHEA);
    } else if (var.equals("Vomit")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.VOMIT);
    } else if (var.equals("AbdominalPain")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.PAIN);
    } else if (var.equals("AstheniaWeakness")) {
      intent.putExtra(TreatActivity.SYMPTOM, TreatActivity.WEAKNESS);
    }

    Float ageYears = data.get("PatientAge");
    intent.putExtra(TreatActivity.AGE_YEARS, ageYears);
    Float ageMonths = extra.get("PatientAgeMonths");
    intent.putExtra(TreatActivity.AGE_MONTHS, ageMonths);
    Float weight = extra.get("PatientWeight");
    intent.putExtra(TreatActivity.WEIGHT, weight);

    startActivity(intent);

    Log.e("------>", "selected " + var);
  }

  private float getHeaderHeight() {
    if (titleFont == null || details == null) return -1;
    if (showTreatment) {
      textFont(titleFont);
      float yTop = 0;
      float hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
      yTop += hBox + padding;
      textFont(textFont);
      float wTot = textWidth(riskMsg);
      int nlines = (int)(wTot/(width - 2 * margin));
      hBox = nlines * (textAscent() + textDescent() + g.textLeading);
      yTop += hBox + padding;
      textFont(labelFont);
      hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
      yTop += hBox + padding;
      return yTop;
    } else {
      float yTop = 0;
      textFont(labelFont);
      float hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
      yTop += hBox + riskHeight + 4 * padding;
      textFont(valueFont);
      hBox = 1.2f * (textAscent() + textDescent() + g.textLeading);
      yTop += hBox + padding;
      return yTop;
    }
  }

  private float getBodyHeight() {
    if (titleFont == null || details == null) return 0;
    if (showTreatment) {
      numContrib = 0;
      textFont(valueFont);
      for (int i = 0; i < varOrder.length; i++) {
        int type = varTypes[i];
        String var = varOrder[i];
        if (details.containsKey(var)) {
          Float[] det = details.get(var);
          float scaledContrib = det[2];
          float scaledRange = det[3];
          float coeff0 = det[4];
          float frac = scaledContrib/scaledRange;
          if (contribThreshold < frac && (type != BINARY || coeff0 > 0)) {
            numContrib++;
          }
        }
      }
      return numContrib * varHeight;
    } else {
      return details.size() * varHeight;
    }
  }

  private float getMarginRight() {
    if (titleFont == null || details == null) return -1;
    textFont(valueFont);
    String riskStr = (int)(risk * 100) + "%";
    float margin = colSpacing + textWidth(riskStr) + colSpacing;
    for (int i = 0; i < varOrder.length; i++) {
      String var = varOrder[i];
      if (details.containsKey(var)) {
        int type = varTypes[i];
        String alias = varAlias[i];
        Float[] det = details.get(var);
        float value = det[0];

        String valueStr;
        if (type == BINARY) {
          valueStr = binLabels[(int)value];
        } else if (type == INT) {
          valueStr = new Integer((int)value).toString();
        } else {
          valueStr = PApplet.nfc(value, 1);
        }
        float w = colSpacing + textWidth(alias + " " + valueStr) + colSpacing;
        if (margin < w) margin = w;
      }
    }
    return margin;
  }

  private int selectSymptom() {
    float mx = mouseX;
    float my = mouseY - translateY;
    float yTop = getHeaderHeight();
    textFont(valueFont);
    for (int i = 0; i < varOrder.length; i++) {
      int type = varTypes[i];
      String var = varOrder[i];
      if (details.containsKey(var)) {
        Float[] det = details.get(var);
        float scaledContrib = det[2];
        float scaledRange = det[3];
        float coeff0 = det[4];
        float frac = scaledContrib/scaledRange;
        if (contribThreshold < frac && (type != BINARY || coeff0 > 0)) {
          float x = margin2;
          float y = yTop + rowSpacing;
          float w = width - 2 * margin2;
          float h = varHeight - 2 * rowSpacing;
          if (x <= mx && mx <= x + w && y <= my && my <= y + h) {
            return i;
          }
          yTop += varHeight;
        }
      }
    }
    return -1;
  }

  class ScrollBar {
    float opacity;
    float size;

    ScrollBar(float siz) {
      opacity = 0;
      size = siz;
    }

    void open() {
      opacity = 150;
    }

    void close() {
      opacity = 0;
    }

    void draw() {
      if (0 < opacity) {
        float frac = (height / totHeight);

        float x = width - 2 * size * displayDensity;
        float y = PApplet.map(translateY / totHeight, -1, 0, height, 0);
        float w = size * displayDensity;
        float h = frac * height;

        noStroke();
        fill(150, opacity);
        rect(x, y, w, h);
      }
    }
  }

  class ScrollShadow {
    boolean bottom;
    float size;

    ScrollShadow(float siz, boolean bot) {
      bottom = bot;
      size = siz;
    }

    void draw() {
      float h = displayDensity * size;
      noStroke();
      if (bottom) {
        if (totHeight + translateY > height + 5) {
//          Log.e("SCROLL SHADOW", totHeight + translateY + " " + height);
          beginShape(QUAD);
          fill(150, 0);
          vertex(0, height - h);
          vertex(width, height - h);
          fill(150, 255);
          vertex(width, height);
          vertex(0, height);
          endShape();
        }
      } else {
        if (translateY < 0 && totHeight + translateY > height) {
          beginShape(QUAD);
          fill(150, 255);
          vertex(0, 0);
          vertex(width, 0);
          fill(150, 0);
          vertex(width, h);
          vertex(0, h);
          endShape();
        }
      }
    }
  }

//  private int getNavBarHeight() {
//    Resources resources = surface.getContext().getResources();
//    int resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
//    if (resourceId > 0) {
//      return resources.getDimensionPixelSize(resourceId);
//    }
//    return 0;
//  }
}