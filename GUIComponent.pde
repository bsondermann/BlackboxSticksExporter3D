import processing.event.*;

 abstract class GUIComponent {
  private int x, y, wid, hgt;
  private String label;
  
  // TODO Can I get rid of this?
  protected boolean wasClicked = false;
  
  protected Object listener;
  protected IFLookAndFeel lookAndFeel;
  protected GUIController controller;
  //protected PFont meta;
  // May not need this
  protected int index;

  
  public GUIComponent () {
  }
  
  public void setIndex(int i) {
    index = i;
  }
  
  public int getIndex() {
    return index;
  }
  
  public void update(int argX, int argY) {
  }
  
  public void show() {
  }
  
  public void setController (GUIController c) {
    controller = c;
  }
  
  public GUIController getController() {
    return controller;
  }
  
  public void initWithParent () {
  }
  
  public void setLookAndFeel(IFLookAndFeel lf) {
    lookAndFeel = lf;
  }
  
  public IFLookAndFeel getLookAndFeel() {
    return lookAndFeel;
  }
  
  public String getLabel() {
    return label;
  }
  
  public void setLabel (String argLabel) {
    label = argLabel;
  }
  
  public boolean canReceiveFocus() {
    return true;
  }
  
  public int getWidth() {
    return wid;
  }
  
  public void setWidth(int newWidth) {
    if (newWidth > 0) wid = newWidth;
  }
  
  public int getHeight() {
    return hgt;
  }
  
  public void setHeight(int newHeight) {
    if (newHeight > 0) hgt = newHeight;
  }
  
  public void addActionListener (Object newListener) {
    listener = newListener;
  }
  
  public void setSize(int newWidth, int newHeight) {
    if (newHeight > 0 && newWidth > 0) {
      hgt = newHeight;
      wid = newWidth;
    }
  }
  
  //public IFSize getSize() {
  //  return new IFRect(wid, hgt);
  //}
  
  public void setPosition(int newX, int newY) {
    if (newX >= 0 && newY >= 0) {
      x = newX;
      y = newY;
    }
  }
  
  //public IFPoint getPosition() {
  //  return new IFPoint(x, y);
  //}
    
  public void setX(int newX) {
    if (newX >= 0) x = newX;
  }

  public int getX() {
    return x;
  }
  
  public int getAbsoluteX() {
    if (controller != null) 
      return controller.getAbsoluteX() + x;
    else
      return x;
  }

  public void setY(int newY) {
    if (newY >= 0) y = newY;
  }
  
  public int getY() {
    return y;
  }
  
  public int getAbsoluteY() {
    if (controller != null)
      return controller.getAbsoluteY() + y;
    else
      return y;
  }

  public void mouseEvent (MouseEvent e) {
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
  
  public void keyEvent (KeyEvent e) {
  }
  
  public void actionPerformed (GUIEvent e) {
    
  }

  
  public void fireEventNotification (GUIComponent argComponent, String argMessage) {
    if (listener == null)
      return;
    
    GUIEvent e = new GUIEvent(argComponent, argMessage);
    IFDelegation.callDelegate(listener, "actionPerformed", new Object[] { e });
      
  }
  
  public boolean isMouseOver (int mouseX, int mouseY) {
    return ((mouseX >= x) && (mouseY >= y) && (mouseX <= (x + wid)) && (mouseY <= (y + hgt)));
  }
  
}
