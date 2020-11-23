
import processing.event.*;

public class IFCheckBox extends GUIComponent {
  private int currentColor;
  private boolean selected = false;

  public IFCheckBox (String newLabel, int newX, int newY) {
    setLabel(newLabel);
    setPosition(newX, newY);
    setSize(14, 14);
  }

  public void initWithParent () {
    controller.parent.registerMethod("mouseEvent", this);
    
    if (lookAndFeel == null)
      return;
    
    controller.userState.saveSettingsForApplet(controller.parent);
    lookAndFeel.defaultGraphicsState.restoreSettingsToApplet(controller.parent);
    
    setSize((int) Math.ceil(controller.parent.textWidth(getLabel())) + getHeight() + 5, 14);

    controller.userState.restoreSettingsToApplet(controller.parent);
  }

  public void mouseEvent (MouseEvent e) {
    if (e.getAction() == MouseEvent.PRESS) {
      if (isMouseOver (e.getX(), e.getY())) {
         wasClicked = true;
      }
    } else if (e.getAction() == MouseEvent.RELEASE) {
      if (wasClicked && isMouseOver (e.getX(), e.getY())) {
        if (selected) {
          selected = false;
          fireEventNotification(this, "Unchecked");
        } else {
          selected = true;
          fireEventNotification(this, "Checked");
        }
        wasClicked = false;
      }
    }
  }
  
  public void keyEvent(KeyEvent e) {
    if (e.getAction() == KeyEvent.TYPE && e.getKey() == ' ') {
      fireEventNotification(this, "Selected");
      if (selected) {
        selected = false;
        fireEventNotification(this, "Unchecked");
      } else {
        selected = true;
        fireEventNotification(this, "Checked");
      }
    }
  }

  public void show () {
    if (isMouseOver (controller.parent.mouseX, controller.parent.mouseY)) {
      currentColor = lookAndFeel.highlightColor;
    } else if (controller.getFocusStatusForComponent(this)) {
      currentColor = lookAndFeel.highlightColor;
    } else {
      currentColor = lookAndFeel.baseColor;
    }

    int x = getX(), y = getY(), hgt = getHeight(), wid = getWidth();
    controller.parent.fill(100);
    controller.parent.stroke(0);
    controller.parent.rect(x+hgt+3,y-3,-textWidth(getLabel())-13-hgt,hgt+6);
    controller.parent.stroke(lookAndFeel.borderColor);
    controller.parent.fill(currentColor);
    controller.parent.rect(x, y, hgt, hgt);
    if (selected == true) {
      controller.parent.stroke (lookAndFeel.darkGrayColor);
      controller.parent.line (x + 3, y + 2, hgt + x - 3, hgt + y - 4);
      controller.parent.line (x + 3, y + 3, hgt + x - 4, hgt + y - 4);
      controller.parent.line (x + 4, y + 2, hgt + x - 3, hgt + y - 5);
      controller.parent.line (x + 3, hgt + y - 4, hgt + x - 3, y + 2);
      controller.parent.line (x + 4, hgt + y - 4, hgt + x - 3, y + 3);
      controller.parent.line (x + 3, hgt + y - 5, hgt + x - 4, y + 2);
    }
    
    controller.parent.fill (lookAndFeel.textColor);
    controller.parent.textAlign(RIGHT);
    controller.parent.text (getLabel(), x - 5, (hgt - 2) + y);
    
    if (controller.showBounds) {
      controller.parent.noFill();
      controller.parent.stroke(255,0,0);
      controller.parent.rect(x, y, wid, hgt);
    }
  }

  public boolean isSelected() {
    return selected;
  }

}
