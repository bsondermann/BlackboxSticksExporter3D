public class GUIEvent {
   GUIComponent source;
   String message;

  GUIEvent (GUIComponent argSource, String argMessage) {
     source = argSource;
    message = argMessage;
   }

  GUIComponent getSource() {
     return source;
   }

   String getMessage() {
    return message;
   }

}
