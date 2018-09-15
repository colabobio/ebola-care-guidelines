package org.broadinstitute.ebola_care_guidelines;

import processing.core.PApplet;

import processing.core.PFont;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.SharedPreferences;
import android.util.Log;

public class SeverityChart extends PApplet implements DataTypes {
  // Model, score, etc.
  protected boolean highRiskPatient;
  protected float riskThreshold = 0;

  protected float risk = 0;
  protected LogRegModel model;
  protected HashMap<String, Float> data = null;
  protected HashMap<String, Float> extra = null;
  protected List<Map.Entry<String, Float[]>> details = null;

  // Variable and value labels
  protected HashMap<String, String> binLabels = null;
  protected HashMap<String, String> labels = null;

  // UI elements
  protected float scrollWidth = 5;
  protected float shadowHeight = 70;
  protected ScrollBar scrollbar;
  protected ScrollShadow topShadow;
  protected ScrollShadow botShadow;

  // Drawing parameters
  protected float marginGlobal = 20;
  protected float padding = 10;
  protected float riskHeight = 150;
  protected float varHeight = 85;
  protected float barHeight = 50;
  protected float lineWidth = 2;

  protected float maxDetailsWidth = -1;
  protected float totHeight = -1;

  // Fonts
  protected PFont noDataTitleFont;
  protected float noDataTitleFontSize = 28;

  protected PFont noDataMessageFont;
  protected float noDataMessageFontSize = 26;

  protected PFont riskMessageFont;
  protected float riskMessageFontSize = 20;

  protected PFont helpFont;
  protected float helpFontSize = 14;

  protected PFont contribsFont;
  protected float contribsFontSize = 18;

  // Interaction
  protected float translateY = 0;
  protected float translateY0 = 0;
  protected boolean dragging = false;
  protected boolean stopDraggingBot;
  protected boolean stopDraggingTop;
  protected int releaseTime;

  public void settings() {
    fullScreen(P2D);
  }

  public void setup() {
    orientation(PORTRAIT);

    initLocalizedLabels();

    scaleDimensions();

    noDataTitleFont = createFont("SansSerif", noDataTitleFontSize);
    noDataMessageFont = createFont("SansSerif", noDataMessageFontSize);
    riskMessageFont = createFont("SansSerif", riskMessageFontSize);
    contribsFont = createFont("SansSerif", contribsFontSize);
    helpFont = createFont("SansSerif", helpFontSize);

    scrollbar = new ScrollBar(scrollWidth);
    if (height < totHeight) scrollbar.open();
//    topShadow = new ScrollShadow(shadowHeight, false);
//    botShadow = new ScrollShadow(shadowHeight, true);

    releaseTime = millis();
  }

  public void draw() {
    background(245);
    if (model == null || data == null) {
      noDataMessage();
    } else {
      pushMatrix();
      updateLayout();
      translate(0, translateY);
      drawVisualization();
      popMatrix();
    }

    scrollbar.draw();
//    topShadow.draw();
//    botShadow.draw();

    if (2000 < millis() - releaseTime) {
      // Stop looping if there is no interaction after two seconds. This should save battery.
      noLoop();
    }
  }

  public void resume() {
    // Resuming app, need to refresh screen by looping again for a while.
    loop();
    releaseTime = millis();
  }

  public void update(SharedPreferences prefs) {
    model = DataHolder.getInstance().getSelectedModel();
    if (model != null) {
      riskThreshold = parseFloat(prefs.getString("riskThreshold", "0.5"));

      data = DataHolder.getInstance().getCurrentData();
      extra = DataHolder.getInstance().getExtraData();
      risk = model.eval(data);
      details = model.evalDetails(data);

      labels = new HashMap<String, String>();
      for (Map.Entry<String, Float[]> entry: details) {
        String var = entry.getKey();
        labels.put(var, Utils.getResString(getActivity(), var));
      }

      highRiskPatient = riskThreshold <= risk;

      totHeight = -1;
      maxDetailsWidth = -1;

      System.out.println("===================== Updated risk");
      Log.e("----->", "Risk: " + risk);
      Log.e("----->", "riskThreshold: " + riskThreshold);
      Log.e("----->", "data: " + data.size());
      Log.e("----->", "details: " + details.size());
      Log.e("----->", "totHeight: " + totHeight);
    }
  }

  private void noDataMessage() {
    String errorMsg1 = Utils.getResString(getActivity(), R.string.no_data_err1);
    String errorMsg2 = Utils.getResString(getActivity(), R.string.no_data_err2);

    float yBox = 0.25f * height;

    yBox = drawMessageBox(errorMsg1, noDataTitleFont, 0xFFD47272, 255, yBox);
    yBox += marginGlobal;

    drawMessageBox(errorMsg2, noDataMessageFont, 0xFF6F6F6F, yBox);
  }

  private void drawVisualization() {
    float yTop = marginGlobal;
    yTop = drawSeverityScore(yTop);
    yTop = drawMessageBox(Utils.getResString(getActivity(), R.string.predictor_contrib), helpFont, 0xFF00A79D, 240, yTop);
    for (Map.Entry<String, Float[]> entry: details) {
      String var = entry.getKey();
      String alias = labels.get(var);
      Float[] det = entry.getValue();
      float value = det[0];
      float scaledContrib = det[2];
      float scaledRange = det[3];
      yTop = drawContribBar(var, alias, value, scaledContrib, scaledRange, contribsFont, yTop);
    }
  }

  public void mousePressed() {
    loop();
    translateY0 = translateY;
  }

  public void mouseDragged() {
    loop();
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
    if (!dragging && height < totHeight) {
      scrollbar.open();
    }
    dragging = true;
  }

  public void mouseReleased() {
    if (dragging) {
      scrollbar.close();
      dragging = false;
      stopDraggingTop = false;
      stopDraggingBot = false;
    }
    releaseTime = millis();
  }

  private void initLocalizedLabels() {
    DataHolder data = DataHolder.getInstance();
    String[] variables = DataHolder.getInstance().getVariables();

    binLabels = new HashMap<String, String>();
    for (String var: variables) {
      String[] labels = data.getVarLabels(var);
      for (String label: labels) {
        if (!binLabels.containsKey(label)) {
          String key = "bin_label_" + label;
          String res = Utils.getResString(getActivity(), key);
          binLabels.put(label, res);
        }
      }
    }
  }

  private void scaleDimensions() {
    marginGlobal *= displayDensity;
    padding *= displayDensity;
    riskHeight *= displayDensity;
    varHeight *= displayDensity;
    barHeight *= displayDensity;
    lineWidth *= displayDensity;

    noDataTitleFontSize *= displayDensity;
    noDataMessageFontSize *= displayDensity;
    riskMessageFontSize *= displayDensity;
    contribsFontSize *= displayDensity;
    helpFontSize *= displayDensity;
  }

  private void updateLayout() {
    if (totHeight <= 0) {
      totHeight = marginGlobal + getRiskHeight() + getHelpHeight() + getMaxDetailsHeight();
    }
    if (maxDetailsWidth <= 0) {
      maxDetailsWidth = getMaxDetailsWidth();
    }
  }

  private float getRiskHeight() {
    if (noDataTitleFont == null || details == null) return -1;
    return 2 * padding + riskHeight + 2 * padding;
  }

  private float getHelpHeight() {
    textFont(helpFont);
    float wTot = textWidth(Utils.getResString(getActivity(), R.string.predictor_contrib));
    int nlines = PApplet.max(1, (int)(wTot/(width - 2 * marginGlobal)));
    return nlines * (textAscent() + textDescent() + g.textLeading);
  }

  private float getMaxDetailsHeight() {
    if (noDataTitleFont == null || details == null) return 0;
    return details.size() * varHeight;
  }

  private float getMaxDetailsWidth() {
    if (noDataTitleFont == null || details == null) return -1;

    textFont(contribsFont);
    float maxWidth = Float.MIN_VALUE;
    for (Map.Entry<String, Float[]> entry: details) {
      String var = entry.getKey();
      String alias = labels.get(var);
      Float[] det = entry.getValue();
      float value = det[0];

      String valueStr = DataHolder.getInstance().getStringValue(value, var, 1, binLabels);
      float w = textWidth(alias + ": " + valueStr);
      maxWidth = PApplet.max(maxWidth, w);
    }
    return maxWidth;
  }

  private float drawMessageBox(String msg, PFont font, int bckgColor, int textColor, float yBox) {
    textAlign(CENTER, CENTER);
    textFont(font);
    float wTot = textWidth(msg);
    int nlines = PApplet.max(1, (int)(wTot/(width - 2 * marginGlobal)));
    float hBox = nlines * (textAscent() + textDescent() + g.textLeading);

    // Draw background box
    noStroke();
    fill(bckgColor);
    rect(0, yBox, width, hBox);

    // Draw text message
    fill(textColor);
    text(msg, marginGlobal, yBox, width - 2 * marginGlobal, hBox);

    return yBox + hBox;
  }

  private void drawMessageBox(String msg, PFont font, int textColor,
                               float x, float y, float w, float h) {
    textAlign(CENTER, CENTER);
    textFont(font);
    // Draw text message
    fill(textColor);
    text(msg, x, y, w, h);
  }

  private float drawMessageBox(String msg, PFont font, int textColor, float yBox) {
    textAlign(CENTER, CENTER);
    textFont(font);
    float wTot = textWidth(msg);
    int nlines = PApplet.max(1, (int)(wTot/(width - 2 * marginGlobal)));
    float hBox = nlines * (textAscent() + textDescent() + g.textLeading);

    // Draw text message
    fill(textColor);
    text(msg, marginGlobal, yBox, width - 2 * marginGlobal, hBox);

    return yBox + hBox;
  }

  private float drawSeverityScore(float yTop) {
    float barWidth = (width - 2 * marginGlobal)/2;

    int score = PApplet.ceil(risk * 10);

    drawBarScale(marginGlobal, yTop, barWidth, riskHeight * 0.9f, 10, score - 1);

    String riskStr = (int)PApplet.round(risk * 100) + "%";
    String riskMsg = Utils.getResString(getActivity(), "death_risk") + "\n" + riskStr;
    if (riskThreshold < risk) riskMsg += " - " + Utils.getResString(getActivity(), "death_risk_high");

    drawMessageBox(riskMsg, riskMessageFont, 0xFF6F6F6F, marginGlobal + barWidth, yTop,
        width - (marginGlobal + barWidth) - padding, riskHeight * 0.9f);

    return yTop + riskHeight;
  }

  private float drawContribBar(String var, String alias, float value, float scaledContrib,
                               float scaledRange, PFont font, float yTop) {
    float barWidth = width - maxDetailsWidth - padding - 2 * marginGlobal;
    float barY = yTop + varHeight/2 - barHeight/2;

    textFont(font);
    textAlign(RIGHT, CENTER);

    fill(0xFF6F6F6F);
    String valueStr = DataHolder.getInstance().getStringValue(value, var, 1, binLabels);
    float tWidth = textWidth(alias + ": " + valueStr);
    text(alias + ": " + valueStr, marginGlobal, barY, maxDetailsWidth, barHeight);

    float barX = marginGlobal + maxDetailsWidth + padding;

    noStroke();
    fill(Utils.severityColor(getActivity(), 0.5f, false, 2));

    rect(barX, barY, scaledContrib * barWidth, barHeight);

    stroke(0xFF6F6F6F);
    strokeWeight(lineWidth);
    float lineX = barX + scaledRange * barWidth;
    float lineY = yTop + varHeight/2;
    line(barX, lineY, lineX, lineY);
    line(lineX, barY, lineX, barY + barHeight);
    line(barX, barY, barX, barY + barHeight);

    return yTop + varHeight;
  }

  private void drawBarScale(float x, float y, float w, float h, int n, int sel) {
    float tg = h/w;
    float rw = w/n;

    pushMatrix();
    translate(x + rw/2, y);

    for (int i = 0; i < n; i++) {
      float x0 = map(i, 0, n, 0, w);
      float x1 = x0 + rw;
      float y0 = tg * x1;

      noStroke();
      if (i <= sel) {
        float score = (float)(i) / (n - 1);
        fill(Utils.severityColor(getActivity(), score, false, 0));
      } else {
        fill(230);
      }
      rect(x0, h - y0, x1 - x0, y0);
    }
    popMatrix();
  }

  private class ScrollBar {
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

  private class ScrollShadow {
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
}