class Settings{
  boolean active = false;
  GUIController c;
  PApplet applet;
  XML xml;
  String explanations[]={
    lang.getTranslation("descFPS"),
lang.getTranslation("descTraillength"),
lang.getTranslation("descWidth"),
lang.getTranslation("descBorderThickness"),
lang.getTranslation("descBorderAngle"),
lang.getTranslation("descBorderDistance"),
lang.getTranslation("descBorderBlur"),
lang.getTranslation("descBackgroundColor"),
lang.getTranslation("descBackgroundOpacity"),
lang.getTranslation("descSticksMode"),
lang.getTranslation("descSticksModeVertPos"),
lang.getTranslation("descStickColor"),
lang.getTranslation("descSimultaneousRenderers")
};
  IFLabel labels[];
  String labelstext[];
  IFLabel explain;
  IFTextField fields[];
  IFLookAndFeel look;
  IFButton back;
  IFButton save;
  IFButton defaults;
  IFButton savePreset;
  IFButton loadPreset;
  Selection selection;
  ColorWheel cw;
  LangImage[] langImage;
  BlackboxSticksExporter3D bbse;
  String activeLang;
  PImage icocw;
  Settings(PApplet applet,Selection selection,BlackboxSticksExporter3D bbse){
    this.bbse = bbse;
    this.applet = applet;
    this.look = look;
    this.selection = selection;
    icocw = loadImage(sketchPath()+"/assets/cw.png");
    c = new GUIController(applet);
    initXML();
    createSettingsGui();
    File[] languages = new File(sketchPath()+"/assets/lang/images").listFiles();
    langImage = new LangImage[languages.length];
    for(int i = 0; i<langImage.length; i++){
      langImage[i] = new LangImage(languages[i],new PVector(width/2+80*i-40*(languages.length-1),height-50),bbse);
    }
    activeLang = loadXML(sketchPath()+"/assets/data.xml").getChildren("data")[4].getContent();
  }
  
  boolean active(){return this.active;}
  void show(){
    explain.setLabel("");

    if(labels.length!=0){
      fill(100);
      rect(40,70,720,30*labels.length+10);
      for(int i =0; i< labels.length-1; i++){
        line(50,105+30*i,750,105+30*i);
      }
      for(int i = 0; i<fields.length;i++){
        fill(0);
        textAlign(LEFT,TOP);
        text(labelstext[i],50,85+30*i);

        if(fields[i].getLabel().contains("col")){
          imageMode(CORNER);
          fill(80);
          stroke(50);
          rect(568,78+30*i,24,24);
          image(icocw,570,80+30*i);
        }
      }
      for(int i = 0; i<fields.length;i++){

        if(labels[i].isMouseOver(mouseX,mouseY)&&cw==null){
          fill(255);
          rectMode(CORNER);
          stroke(0);
          String temp = trimString(explanations[i],40);
          rect(5+mouseX,mouseY-5,textWidth(temp)+10,textHeight(temp)+23);
          explain.setLabel(temp);
          explain.setPosition(10+mouseX,mouseY);
        }
      }
      for(int i = 0; i<langImage.length;i++){
      if(langImage[i].name.equals(activeLang)){
        rectMode(CENTER);
        noFill();
        stroke(255,0,0);
        strokeWeight(5);
        rect(langImage[i].pos.x,langImage[i].pos.y,50,30);
        strokeWeight(1);
        rectMode(CORNER);}
    }
    for(int i = 0; i<langImage.length;i++){
      boolean temp = langImage[i].update();
      if(temp){activeLang=langImage[i].name;}
      imageMode(CENTER);
    
      image(langImage[i].getImage(),langImage[i].pos.x,langImage[i].pos.y,50,30);
    }
    }
    if(cw!=null){
      stroke(0);
      fill(100);
      rect(cw.posx-20,cw.posy-20,cw.w+40,cw.w+40);
      cw.show();
      strokeWeight(1);
      
    }
    if(c!=null){c.show();}
  }
  void actionPerformed(GUIEvent e){
    if(this.active){
      if(e.getSource()==savePreset){
        selectOutput(lang.getTranslation("btnSavePreset"),"savePreset",new File(sketchPath()+"/presets/ "));
      }
      if(e.getSource()==loadPreset){
        selectInput(lang.getTranslation("btnLoadPreset"),"loadPreset",new File(sketchPath()+"/presets/ "));
      }
    if(e.getSource()==back){
      removeSettingsGui();
    }else if(e.getSource()==save){
      checkColor();
      writeXML();
   }else if(e.getSource()==defaults){
     XML[] newchildren=loadXML("assets/data.xml").getChildren("setting");
     XML[] children = xml.getChildren("setting");
     for(int i = 0; i< children.length; i++){
       children[i].setContent(newchildren[i].getContent());
     }
     saveXML(xml,"assets/settings.xml");
     initXML();
   }else{
      IFTextField temp = (IFTextField)e.getSource();
      String type = temp.getLabel();
      String content = temp.getValue();
      if(type.contains("num")){
        String[]args=type.split(",");
        content = content.replaceAll("[^0-9]","");
        int numcontent = Integer.parseInt(content);
        float floatcontent = 0.0f;
        if(args.length==3){
          numcontent = constrain(Integer.parseInt(content),Integer.parseInt(args[1]),Integer.parseInt(args[2]));
        }else if(args.length==2){
            numcontent = max(Integer.parseInt(content),Integer.parseInt(args[1]));

            floatcontent = max(Float.parseFloat(content),Float.parseFloat(args[1]));
          
        }
        temp.setValue(""+abs(numcontent));
        if(floatcontent!=0){
          temp.setValue(""+abs(floatcontent));
        }
      }else if(type.contains("col")){
        if(!content.contains("#")){
          content = "#"+content;
        }
        content = content.toUpperCase();
        content = content.replaceAll("[^A-F0-9#]","");
        content = content.substring(0,Math.min(content.length(),7));
        temp.setValue(content);
      }
   }}
    
  }
  void createSettingsGui(){
    back = new IFButton(lang.getTranslation("btnBack"),50,30,100,20);
    back.addActionListener(applet);
    if(lang.name.equals("ua")){
      savePreset = new IFButton(lang.getTranslation("btnSavePreset"),50,500,150,40);
      savePreset.addActionListener(applet);
    
      loadPreset = new IFButton(lang.getTranslation("btnLoadPreset"),width-200,500,150,40);
      loadPreset.addActionListener(applet);
    }else{   
      savePreset = new IFButton(lang.getTranslation("btnSavePreset"),50,500,150,20);
      savePreset.addActionListener(applet);
    
      loadPreset = new IFButton(lang.getTranslation("btnLoadPreset"),width-200,500,150,20);
      loadPreset.addActionListener(applet);
    }   
    save = new IFButton(lang.getTranslation("btnSave"),width-150,30,100,20);
    save.addActionListener(applet);
    explain = new IFLabel("",-100,-100);
    defaults = new IFButton(lang.getTranslation("btnLoadDefaults"),width/2-75,30,150,20);
    defaults.addActionListener(applet);
    c.add(defaults);
    c.add(back);
    c.add(save);
    c.add(loadPreset);
    c.add(savePreset);
    
        c.add(explain);
    active = true;
  }
  void removeSettingsGui(){
    for(int i = 0; i< labels.length;i++){
      c.remove(labels[i]);
      c.remove(fields[i]);
    }
    c.remove(save);
    save.addActionListener(null);
    save=null;
    fields=new IFTextField[0];
    labels = new IFLabel[0];
    c.remove(back);
    back.addActionListener(null);
    back=null;
    c.setVisible(false);
    c=null;
    active = false;
    selection.createSelectionGui();
    cw=null;
  }
  void initXML(){
    
    xml=loadXML("assets/settings.xml");
    XML[] children = xml.getChildren("setting");
    labelstext = new String[children.length]; 
    labels = new IFLabel[children.length];
    fields = new IFTextField[children.length];
    for(int i = 0; i< children.length;i++){
      labels[i] = new IFLabel("",50,85+30*i);
      labels[i].setWidth(150);
      labels[i].setHeight(20);
      labelstext[i] = children[i].getString("id").trim();
      c.add(labels[i]);
      fields[i] = new IFTextField(children[i].getString("type").trim(),600,80+30*i,150);
      fields[i].setValue( children[i].getContent());
      fields[i].addActionListener(applet);
      c.add(fields[i]);
      //labels[i].setLabel(children[i].getString("id").trim());
    }
  }
  void writeXML(){
    XML[] children = xml.getChildren("setting");
    for(int i = 0; i<children.length;i++){
      children[i].setContent(fields[i].getValue());
    }
    saveXML(xml,"assets/settings.xml");
    s.console = lang.getTranslation("consoleInfoSettingsSaved");
  }
  void checkColor(){
    for(int i = 0; i< fields.length;i++){
      if(fields[i].getValue().contains("#")){
        String cont = fields[i].getValue();
        int l = cont.length();
        
        for(int j = 0; j<7-l;j++){
          cont=cont+"0";
        }
        fields[i].setValue(cont);
      }
    }
  }
  int textHeight(String text){
    return (text.split("\n", -1).length-1)*18;
  }
  void mousePress(){
    if(mouseButton == 37){
      for(int i = 0; i< fields.length; i++){
        if(fields[i].getLabel().contains("col")&&mouseX>570&&mouseX<590&&mouseY>80+30*i&&mouseY<100+30*i){
          cw = new ColorWheel(200,width/2-100,mouseY-100,this,fields[i]);
        }
      }
    }
    if(cw!=null){
      cw.mousePress();
    }
  }
  void mouseRel(){
    if(cw!=null){
      cw.mouseRel();
    }
  }
  void disableCW(){
    cw=null;
  }
  
  String trimString(String s, int l){
    String ret="";
    int index=0;
    for(int i = 0; i< s.length();i++){
      ret+=s.charAt(i);
      if(index>l&&s.charAt(i)==' '){
        ret+='\n';
        index=0;
      }
      index++;
    }
    return ret;
  }
  void savePreset(File f){
    writeXML();
    if(f.getAbsolutePath().contains(".bbconf")){
      
    saveXML(xml,f.getAbsolutePath());
    }else{
    saveXML(xml,f.getAbsolutePath()+".bbconf");
    }
  }
  void loadPreset(File f){
    if(f.getAbsolutePath().contains(".bbconf")){
      saveXML(loadXML(f.getAbsolutePath()),sketchPath()+"/assets/settings.xml");
      xml=loadXML("assets/settings.xml");
    XML[] children = xml.getChildren("setting");
    for(int i = 0; i< children.length;i++){
      labels[i] = new IFLabel("",50,85+30*i);
      labels[i].setWidth(150);
      labels[i].setHeight(20);
      labelstext[i] = children[i].getString("id").trim();
      c.add(labels[i]);
      fields[i] = new IFTextField(children[i].getString("type").trim(),600,80+30*i,150);
      fields[i].setValue( children[i].getContent());
      fields[i].addActionListener(applet);
      c.add(fields[i]);
      //labels[i].setLabel(children[i].getString("id").trim());
    }
    }
  }
}
