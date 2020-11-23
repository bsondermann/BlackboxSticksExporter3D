

public class IFLabel extends GUIComponent {
  private int textSize = 13;

  public IFLabel (String argLabel, int argX, int argY) {
    this (argLabel, argX, argY, 13);
  }
  
  public IFLabel (String newLabel, int newX, int newY, int size) {
    setLabel(newLabel);
    setPosition(newX, newY);
    
    if (size > 8 && size < 20) 
      textSize = size;
    else
      textSize = 13;
  }

  // ***** SET THE LABEL'S SIZE SO WE CAN GET ITS BOUNDING BOX *****
  
  public boolean canReceiveFocus() {
    return false;
  }
  
  public void setTextSize(int size) {
    if (size > 8 && size < 20) 
      textSize = size;
    else
      textSize = 13;
  }
  
  public int getTextSize() {
    return textSize;
  }

  public void show () {
    controller.parent.fill (lookAndFeel.textColor);
    controller.parent.text (getLabel(), getX(), getY() + textSize - 3);
  }

}
