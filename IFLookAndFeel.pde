import processing.core.*;

 class IFLookAndFeel {
   int baseColor, borderColor, highlightColor, selectionColor, 
        activeColor, textColor, lightGrayColor, darkGrayColor;
   IFPGraphicsState defaultGraphicsState;
   static final char DEFAULT = 1;
  
   IFLookAndFeel(char type) {
    defaultGraphicsState = new IFPGraphicsState();
  }
  
   IFLookAndFeel(PApplet parent, char type) {
    defaultGraphicsState = new IFPGraphicsState();
    
    if (type == DEFAULT) {
      // Play nicely with other people's draw methods. They
      // may have changed the color mode.
      IFPGraphicsState temp = new IFPGraphicsState(parent);
      
      parent.colorMode(PApplet.RGB, 255);

      baseColor = color(153, 153, 204);
      highlightColor = color(102, 102, 204);
      activeColor = color (255, 153, 51);
      selectionColor = color (255, 255, 0);
      borderColor = color (255);
      textColor = color (0);
      lightGrayColor = color(100);
      darkGrayColor = color(50);

      /*
      System.out.println("===== DEFAULT GRAPHICS STATE =====\ntextAlign:\t" + parent.g.textAlign +
          "\nrectMode:\t" + parent.g.rectMode +
          "\nellipseMode:\t" + parent.g.ellipseMode +
          "\ncolorMode:\t" + parent.g.colorMode + ", " + parent.g.colorModeX + 
          "\nsmooth:\t" + parent.g.smooth);
      */
      
      PFont tempFont = parent.createFont ("Arial",12);
      parent.textFont(tempFont, 13);
      parent.textAlign(PApplet.LEFT);
      
      parent.rectMode(PApplet.CORNER);
      parent.ellipseMode(PApplet.CORNER);
      
      parent.strokeWeight(1);
      
      parent.colorMode(PApplet.RGB, 255);
      
      try {
        parent.smooth();
      } catch (RuntimeException e) {
        // Can't smooth in P3D, throws exception
      }

      /*
      System.out.println("\n===== INTERFASCIA SETUP ======\ntextAlign:\t" + parent.g.textAlign +
          "\nrectMode:\t" + parent.g.rectMode +
          "\nellipseMode:\t" + parent.g.ellipseMode +
          "\ncolorMode:\t" + parent.g.colorMode + ", " + parent.g.colorModeX +
          "\nsmooth:\t" + parent.g.smooth);
      */
      
      defaultGraphicsState.saveSettingsForApplet(parent);
      // System.out.println("Class: " + parent.g.getClass() + "/n");
      // Set the color mode back
      temp.restoreSettingsToApplet(parent);
    }
  }
}
