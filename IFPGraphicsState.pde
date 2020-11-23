import processing.core.*;
 class IFPGraphicsState {
  int smooth;
  
  int rectMode, ellipseMode;

  PFont textFont;
  int textAlign;
  float textSize;
  int textMode;
  
  boolean tint;
  int tintColor;
  boolean fill;
  int fillColor;
  boolean stroke;
  int strokeColor;
  float strokeWeight;
  
  int cMode;
  float cModeX, cModeY, cModeZ, cModeA;
  
  IFPGraphicsState() {
  }
  
  
  /**
  * Convenience contstructor saves the applet's graphics state into
  * the newly created IFPGraphicsState object.
  *
  * @param applet the PApplet instance whose state we're saving
  */
  IFPGraphicsState(PApplet applet) {
    saveSettingsForApplet(applet);
  }
  
  
  /**
  * saves the graphics state for the specified PApplet
  *
  * @param applet the PApplet instance whose state we're saving
  */
  
   void saveSettingsForApplet(PApplet applet) {
    smooth = applet.g.smooth;
    
    rectMode = applet.g.rectMode;
    ellipseMode = applet.g.ellipseMode;
    
    textFont = applet.g.textFont;
    textAlign = applet.g.textAlign;
    textSize = applet.g.textSize;
    textMode = applet.g.textMode;
    
    tint = applet.g.tint;
    fill = applet.g.fill;
    stroke = applet.g.stroke;
    tintColor = applet.g.tintColor;
    fillColor = applet.g.fillColor;
    strokeColor = applet.g.strokeColor;
    strokeWeight = applet.g.strokeWeight;
    cMode = applet.g.colorMode;
    cModeX = applet.g.colorModeX;
    cModeY = applet.g.colorModeY;
    cModeZ = applet.g.colorModeZ;
    cModeA = applet.g.colorModeA;
  }

  
  /**
  * restores the saved graphics state to the specified PApplet
  *
  * @param applet the PApplet instance whose state we're restoring
  */
  
  void restoreSettingsToApplet(PApplet applet)
  { 

    try {
      if (smooth > 0) {
        applet.smooth();
      } else {
        applet.noSmooth();
      }
    } catch (RuntimeException e) {
      // Can't smooth in P3D, throws exception
    }
    
    applet.rectMode(rectMode);
    applet.ellipseMode(ellipseMode);
    
    if(textFont != null){ 
      applet.textFont(textFont);
      applet.textSize(textSize);
    }
    applet.textAlign(textAlign);
    applet.textMode(textMode);
    
    // ***** I THINK YOU CAN SET A COLOR FOR A PROPERTY THAT'S NOT ENABLED *****
    if(tint) applet.tint(tintColor);
    else applet.noTint();
    
    if(fill) applet.fill(fillColor);
    else applet.noFill();
    
    if(stroke) applet.stroke(strokeColor);
    else applet.noStroke();
    
    applet.strokeWeight(strokeWeight);
    applet.colorMode(cMode, cModeX, cModeY, cModeZ, cModeA);    
  }
  
}
