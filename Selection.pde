
class Selection{
  Preview p;
  boolean active = false;
  boolean rendering=false;
  boolean tempClear=false;
  GUIController c1;
  IFButton settings,btnInputFolder,btnOutputFolder,btnStart,addRenderer,btnCredits;
  IFCheckBox checkSound, checkShutdown,checkLogger,checkAutoFolder;
  BlackboxSticksExporter3D bbse;
  PApplet applet;
  Settings set;
  Credits credits;
  SoundFile sound;

  String console="";
  boolean readyToRender =false;
  
PrintStream stdout=System.out;
PrintStream stderr=System.err;
  Selection(BlackboxSticksExporter3D applet){
    active = true;
    this.applet = applet;
    createSelectionGui();
    try{
   sound = new SoundFile(applet,sketchPath()+"/assets/done.wav");
    }catch(Exception e){e.printStackTrace();}  
}
  void show(){
    
    if(set!=null){set.show();}
    if(credits!=null){credits.show();}
    if(rendering){
      p.show();
    }
    
    textAlign(CENTER,BOTTOM);
    fill(100);
    stroke(0);
    rect(0,height-20,width,20);
    fill(0);
    text(console,width/2,height-2);
    if(c1 != null){
    c1.show();
    }
  }
  
  void actionPerformed(GUIEvent e){
    if(this.active){
      if(e.getSource()==btnCredits){
        if(rm!=null&&rm.rendering){
          console=lang.getTranslation("consoleErrorOpenCreditsWhileRendering");
        }else{
        removeSelectionGui();
        credits = new Credits(this,applet);
        }
      }
      if(e.getSource()==checkAutoFolder){
        if(checkAutoFolder.isSelected()){
        if(inputPath!=null){
          outputPath=new File(inputPath.getAbsolutePath()+"/Output/");
          createImage(1, 1, RGB).save(outputPath.getAbsolutePath()+"/temp.png");
          new File(outputPath.getAbsolutePath()+"/temp.png").delete();
        }
      }else{
        outputPath=new File(data.getChildren("data")[1].getContent());
      }
      }
      if(e.getSource()==checkLogger){
        if(checkLogger.isSelected()){
          try{
            saveStrings(sketchPath()+"/assets/logs/log.txt",new String[]{""});
            saveStrings(sketchPath()+"/assets/logs/errlog.txt",new String[]{""});
            PrintStream err = new PrintStream(new FileOutputStream(sketchPath()+"/assets/logs/errlog.txt",true),true);
            System.setErr(err);
            PrintStream out = new PrintStream(new FileOutputStream(sketchPath()+"/assets/logs/log.txt",true),true);
            System.setOut(out);
          }catch(Exception ex){
            ex.printStackTrace();
          }
        }else{
          System.setOut(stdout);
          System.setErr(stderr);
          
        }
      }
      if(e.getSource()==settings){
        if(rm!=null&&rm.rendering){
          console=lang.getTranslation("consoleErrorOpenSettingsWhileRendering");
        }else{
        removeSelectionGui();
        set = new Settings(applet,this,bbse);
        }
      }
      if(e.getSource() == btnInputFolder){
        if(inputPath!=null){
          selectFolder(lang.getTranslation("selectInputFolder"),"InputSelected",new File(inputPath.getAbsolutePath()));
        }else{
          selectFolder(lang.getTranslation("selectInputFolder"),"InputSelected");
        }
      }
      if(e.getSource() == btnOutputFolder){
        if(outputPath!=null){
          selectFolder(lang.getTranslation("selectOutputFolder"),"OutputSelected",new File(outputPath.getAbsolutePath()));
        }else{
          selectFolder(lang.getTranslation("selectOutputFolder"),"OutputSelected");
        }
      }if(e.getSource()==addRenderer){
        if(rm!=null){
          rm.simultRenderNum++;
          XML xml = loadXML("assets/settings.xml");
          XML[] children = xml.getChildren("setting");
          children[9].setContent(rm.simultRenderNum+"");
          saveXML(xml,"assets/settings.xml");
        }
      }
      if(e.getSource()==btnStart){
        readyToRender = true;
        if(inputPath==null&&inputFiles.size()==0){
          console=lang.getTranslation("consoleErrorSelectInputFolder");
          readyToRender = false;
        }
        if(outputPath==null){
          console=lang.getTranslation("consoleErrorSelectOutputFolder");
          readyToRender = false;
        }
        if(outputPath==null&&inputPath==null&&inputFiles.size()==0){
          console=lang.getTranslation("consoleErrorSelectInputAndOutputFolder");
          readyToRender = false;
        }
        if(outputPath!=null&&inputPath!=null){
          if(outputPath.getAbsolutePath().equals(inputPath.getAbsolutePath())){
            console=lang.getTranslation("consoleErrorInputOutputEqual");
            readyToRender = false;
          }
        }
        if(inputPath!=null){
          if(getNumFiles(inputPath)<=0){
            console=lang.getTranslation("consoleErrorEmptyInput");
            readyToRender=false;
          }
        }
        if(!tempClear){
          console=lang.getTranslation("consoleErrorTempNotEmpty");
          readyToRender=false;
        }
        if(readyToRender==true&&rm==null){
          
          console=lang.getTranslation("consoleInfoStartRender");
          if(inputPath!=null){
            rm=new RenderManager(inputPath.listFiles(),getCurrentSettings(),this);
          }else{
            File[] files = new File[inputFiles.size()];
            for(int i = 0; i< inputFiles.size();i++){
              files[i] = inputFiles.get(i);
            }
            rm = new RenderManager(files,getCurrentSettings(),this);
            
          }
          rendering = true;
          p = new Preview(200,rm);
        }
      }
    }
    if(set!=null){
      set.actionPerformed(e);
    }if(credits!=null){
      credits.actionPerformed(e);
    }
  }
  
  boolean active(){
    return this.active;
  }
  void createSelectionGui(){
    c1 = new GUIController(applet);
    
    settings = new IFButton(lang.getTranslation("btnChangeSettings"),50,30,150,20);
    settings.addActionListener(applet);
    btnInputFolder = new IFButton(lang.getTranslation("btnSelectInputFolder"),300,30,200,20);
    btnInputFolder.addActionListener(applet);
    btnOutputFolder = new IFButton(lang.getTranslation("btnSelectOutputFolder"),300,90,200,20);
    btnOutputFolder.addActionListener(applet);
    btnStart = new IFButton(lang.getTranslation("btnStart"),300,150,200,20);
    btnStart.addActionListener(applet);
    btnCredits = new IFButton(lang.getTranslation("btnCredits"),50,90,150,20);
    btnCredits.addActionListener(applet);
    checkSound = new IFCheckBox(lang.getTranslation("checkBoxFinishSound"),750,30);
    c1.add(checkSound);
    checkShutdown = new IFCheckBox(lang.getTranslation("checkBoxShutdown"),750,70);
    checkLogger = new IFCheckBox(lang.getTranslation("checkBoxLogger"),750,110);
    checkLogger.addActionListener(applet);
    checkAutoFolder = new IFCheckBox(lang.getTranslation("checkBoxAutoFolder"),750,150);
    checkAutoFolder.addActionListener(applet);
    addRenderer = new IFButton(lang.getTranslation("btnAddRenderer"),50,150,150,20);
    addRenderer.addActionListener(applet);
    c1.add(btnCredits);
    c1.add(addRenderer);
    c1.add(checkAutoFolder);
    c1.add(checkShutdown);
    c1.add(checkLogger);
    c1.add(btnInputFolder);
    c1.add(btnStart);
    c1.add(btnOutputFolder);
    c1.add(settings);
    active = true;
  }
  void removeSelectionGui(){
    c1.remove(settings);
    c1.remove(btnCredits);
    c1.remove(btnInputFolder);
    c1.remove(btnOutputFolder);
    settings.addActionListener(null);
    btnInputFolder.addActionListener(null);
    btnOutputFolder.addActionListener(null);
    btnCredits.addActionListener(null);
    c1.setVisible(false);
    c1=null;
    settings = null;
    btnCredits=null;
    active=false;
  }
  
  String[]getCurrentSettings(){
    XML xml = loadXML("assets/settings.xml");
    XML[] children = xml.getChildren("setting");
    String[]settings = new String[children.length];
    for(int i = 0; i< children.length; i++){
      settings[i] = children[i].getContent();
    }
    return settings;
  }
  void mouseDown(){
    if(rendering){
      p.mouseDown();
    }
  }
  void stop(){
    if(rm!=null){
      rm.stopRender();
    }
  }
  void doneRendering(){
    if(checkShutdown.isSelected()){
      shutdown();
    }
    if(checkSound.isSelected()){
      if(sound!=null){
        sound.play();
      }
    }
    clearTemp();
    rm=null;
    setup();
  }
  void mousePress(){
    if(set!=null){
      set.mousePress();
      
    }
    if(credits!=null){
      credits.mousePress();
    }
  }
  void mouseRel(){
    if(set!=null){
      set.mouseRel();
      
    }
  }
  void savePreset(File f){
    if(set!=null){set.savePreset(f);}
  }
  void loadPreset(File f){
    if(set!=null){set.loadPreset(f);}
  }
}
