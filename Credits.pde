import java.net.URL;
import java.awt.Desktop;
class Credits{
  Selection sele;
  GUIController cont;
  IFButton backbtn;
  boolean active = false;
  PImage icomail,icoinsta,icoyt,icopp;
  PApplet app;
  String[][] data={
    {"Name","Job","Role"},
  {"Bastian Sondermann","Developer","Developing / Testing / German translation","http://www.instagram.com/batifpv/","bastian.sondermann@web.de"},
  {"Fabio Pansera","Video Editor","Testing / Italian, Ukrainian, Russian translation","http://www.instagram.com/thelollerz/","fabiopanseratcb@gmail.com"},
  {"Joshua Bardwell","FPV Know-It-All","Testing","http://www.youtube.com/joshuabardwell","joshuabardwell@gmail.com"}
  };
  Credits(Selection s,PApplet applet){
    sele=s;
    app = applet;
    cont = new GUIController(app);
    createSettingsGui();
    icomail = loadImage(sketchPath()+"/assets/email.png");
    icoinsta = loadImage(sketchPath()+"/assets/ig.png");
    icoyt = loadImage(sketchPath()+"/assets/yt.png");
    icopp=loadImage(sketchPath()+"/assets/pp.png");
  }
  void show(){
    if(this.active){
      imageMode(CORNER);
      textAlign(TOP,LEFT);
      fill(100);
      rect(40,70,720,30*(data.length)+10);
      fill(0);
      for(int i = 0; i< data.length; i++){
        if(i==0){
          textSize(15);
        }else{
          textSize(13);
        }
        for(int j = 0; j<3;j++){
          text(data[i][j],50+(720/5)*j,90+30*i);
        }
        if(i!=0){
            if(data[i][3].contains("instagram")){
            image(icoinsta,700,73+30*i);}
            if(data[i][3].contains("youtube")){
            image(icoyt,700,78+30*i);}
            if(data[i][4].contains("@")){
            image(icomail,730,76+30*i);}
           }
        }
        
      image(icopp,670,73+30);
      }
      if(cont != null){cont.show();}
    }
  
  void mousePress(){
    
    if(this.active){
    for(int i = 1; i< data.length;i++){
      if(mouseX>700&&mouseX<725&&mouseY>73+30*i&&mouseY<73+30*i+25){
        try{
          Desktop.getDesktop().browse(new URL(data[i][3]).toURI());
        }catch(Exception e){e.printStackTrace();}
        sele.console = data[i][3];
      }
      if(mouseX>730&&mouseX<755&&mouseY>76+30*i&&mouseY<76+30*i+25){
        try{
          Desktop.getDesktop().mail(new URL("mailto:"+data[i][4]).toURI());
        }catch(Exception e){e.printStackTrace();}
        sele.console = data[i][4];
      }
    }
    if(mouseX>670&&mouseX<670+25&&mouseY>73+30&&mouseY<73+30+25){
      try{
          Desktop.getDesktop().browse(new URL("https://www.paypal.me/bsondermann581").toURI());
        }catch(Exception e){e.printStackTrace();}
    }
  }
  }
   void actionPerformed(GUIEvent e){
    if(this.active){
    if(e.getSource()==backbtn){
      
      this.removeSettingsGui();
    }
    }
  }
  void createSettingsGui(){
   backbtn = new IFButton(lang.getTranslation("btnBack"),50,30,100,20);
    backbtn.addActionListener(app);
    this.cont.add(backbtn);
    this.active=true;
  }
  
  void removeSettingsGui(){

    cont.remove(backbtn);
    backbtn.addActionListener(null);
    backbtn=null;
    cont.setVisible(false);
    cont=null;
    active = false;
    sele.createSelectionGui();
  }
}
