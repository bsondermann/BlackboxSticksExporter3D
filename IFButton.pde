import processing.core.*;
import processing.event.*;

public class IFButton extends GUIComponent {
  private int currentColor;

  public IFButton (String newLabel, int newX, int newY) {
    this (newLabel, newX, newY, 100, 21);
  }

  public IFButton (String newLabel, int newX, int newY, int newWidth) {
    this (newLabel, newX, newY, newWidth, 21);
  }

  public IFButton (String newLabel, int newX, int newY, int newWidth, int newHeight) {
    setLabel(newLabel);
    setPosition(newX, newY);
    setSize(newWidth, newHeight);
  }

  public void initWithParent () {
    controller.parent.registerMethod("mouseEvent", this);
  }

  public void mouseEvent(MouseEvent e) {
    if (e.getAction() == MouseEvent.PRESS) {
      if (isMouseOver (e.getX(), e.getY())) {
        wasClicked = true;
      }
    } else if (e.getAction() == MouseEvent.RELEASE) {
      if (wasClicked && isMouseOver (e.getX(), e.getY())) {
        fireEventNotification(this, "Clicked");
        wasClicked = false;
      }
    }
  }

  public void show () {
    boolean hasFocus = controller.getFocusStatusForComponent(this);
  
    if (wasClicked) {
       currentColor = lookAndFeel.activeColor;
    } else if (isMouseOver (controller.parent.mouseX, controller.parent.mouseY) || hasFocus) {
       currentColor = lookAndFeel.highlightColor;
    } else {
       currentColor = lookAndFeel.baseColor;
    }

    int x = getX(), y = getY(), hgt = getHeight(), wid = getWidth();
  
    controller.parent.stroke(lookAndFeel.borderColor);
    controller.parent.fill(currentColor);
    controller.parent.rect(x, y, wid, hgt);
    controller.parent.fill (lookAndFeel.textColor);

    controller.parent.textAlign (PApplet.CENTER);
    controller.parent.text (getLabel(), x, y + 3, wid, hgt);
    controller.parent.textAlign (PApplet.LEFT);

    if (controller.showBounds) {
      controller.parent.noFill();
      controller.parent.stroke(255,0,0);
      controller.parent.rect(x, y, wid, hgt);
    }
  }
    
  public void keyEvent(KeyEvent e) {
    if (e.getAction() == KeyEvent.TYPE && e.getKey() == ' ') {
      fireEventNotification(this, "Selected");
    }
  }

}
