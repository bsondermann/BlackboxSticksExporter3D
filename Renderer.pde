class Renderer extends Thread{
File file;
  File[] logs;
  boolean running = false,stop=false;
  float numFrames, currentFrame=0;
  String[]settings;
  String currentState="";
  int number;
  int tailLength,vidWidth,bgOpacity,sticksMode,sticksModeVertPos,borderAngle,borderDistance,borderBlur;
  float borderThickness;
  float fps;
  int bgColor;
  int[]sticksColor;
  PImage prevImage;
  int starttime=0;
  boolean betaflight=true;
  ImageExporter ie;
  Renderer(File f,String[]s,int number){
    currentState="Idle";
    this.number= number;
    settings = s;
    file = f;
    String []temp = loadStrings(f);
    println(temp[22]);
      if(temp.length>0){
        if(temp[22].contains("INAV")){
          betaflight = false;
        }
      }
    parseSettings();
    
  }
  void convertLog(){
    
    if(stop){return;}
    currentState=lang.getTranslation("rendererStateConverting");
    createImage(1, 1, RGB).save(sketchPath()+"/temp/"+number+"/csv/temp.png");
    new File(sketchPath()+"/temp/"+number+"/csv/temp.png").delete();
    ProcessBuilder pb;
    if(System.getProperty("os.name").contains("Mac")){
    pb = new ProcessBuilder(sketchPath()+"/assets/blackbox_decode","--merge-gps",""+file.getAbsolutePath());
    }else{
      pb = new ProcessBuilder(sketchPath()+"/assets/blackbox_decode.exe","--merge-gps",""+file.getAbsolutePath());
    }
    try {
    Process process = pb.start();
    InputStream is = process.getErrorStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    String line = reader.readLine();
    while (line !=null) {
      println(line);

      line= reader.readLine();
    }

    logs = getLogs(file);
    }catch(Exception e) {
    e.printStackTrace();
    }
  }



  void renderLog(int sublog){
    if(stop){return;}
    
    int colthrottle=16;
    int colpitch = 14;
    int colyaw=15;
    int colroll=13;
    if(!betaflight){
      colroll=22;
      colpitch=23;
      colyaw=24;
      colthrottle=25;
    }
    
    
    
    currentState=lang.getTranslation("rendererStateRendering");
    int w = vidWidth;
    int h = int(w*(1.0f/3));
    println(h);
    RamTable table = new RamTable(file.getAbsolutePath());
    if(table.getRowCount()<=2){return;}
    PGraphics tailL=createGraphics(int(vidWidth*(1.0f/3)),int(vidWidth*(1.0f/3)));
    PGraphics tailR=createGraphics(int(vidWidth*(1.0f/3)),int(vidWidth*(1.0f/3)));
    int startindex=1;
    float lengthus=(PApplet.parseFloat(table.getRow(table.getRowCount()-1).getString(1).trim())-PApplet.parseFloat(table.getRow(startindex).getString(1).trim()));
    int lengthlist = table.getRowCount()-startindex;
    numFrames=((lengthus/1000000.0f)*fps);
    float space=PApplet.parseFloat(lengthlist)/((lengthus/1000000.0f)*fps);
  int where=0;
  for (float i = startindex; i<table.getRowCount(); i+=space) {
    if(stop){return;}
    RamTableRow row = table.getRow(int(i));
    currentFrame++;

    tailL.beginDraw();
    tailL.clear();
    tailL.noStroke();
    tailR.beginDraw();
    tailR.clear();
    tailR.noStroke();
    float taillength=(fps/30)*tailLength;

    for (float j = 0; j< space*taillength; j++) {
      RamTableRow trailrow = table.getRow(constrain(int(i-j), 0, table.getRowCount()-1));
      //alphaG.fill(sticksColor[0],sticksColor[1], sticksColor[2], map(j, 0, space*taillength, 100, 0));
      tailL.fill(255);
      tailR.fill(255);
      float r = map(j, 0, space*taillength, ((w/3)/7.3f)/1.5f, ((w/3)/7.3f)/10);
      float x=0, y=0, x1=0, y1=0;
      
      
      float valthrottletrail=0;
      float valrolltrail=0;
      float valpitchtrail=0;
      float valyawtrail=0;
    
    
    if(betaflight){
      valthrottletrail=-map(int(trailrow.getString(colthrottle).trim()), 1000, 2000, -1, 1);
      valpitchtrail = map(-int(trailrow.getString(colpitch).trim()), -500, 500, -1, 1);
      valyawtrail=map(int(trailrow.getString(colyaw).trim()),-500,500,1,-1);
      valrolltrail=map(int(trailrow.getString(colroll).trim()),-500,500,-1,1);
    }
      
      if (sticksMode==2) {
        //yaw
        x =h/2+valyawtrail*int(vidWidth*(1.0f/6))*0.4+1;
        //throttle
        y = h/2+valthrottletrail*int(vidWidth*(1.0f/6))*0.4;
        //roll
        x1= h/2+valrolltrail*int(vidWidth*(1.0f/6))*0.4-2;
        //pitch
        y1 = h/2+valpitchtrail*int(vidWidth*(1.0f/6))*0.4;
      }
        tailL.ellipse(x, y, r, r);

        tailR.ellipse(x1, y1, r, r);

      trailrow=null;
    }
    tailL.endDraw();
    tailR.endDraw();
    
    PGraphics outL = createGraphics(tailL.width, tailL.height, JAVA2D);
    outL.beginDraw();
    outL.clear();
    outL.image(tailL,0,0);
    outL.endDraw();
    PGraphics outR = createGraphics(tailR.width, tailR.height, JAVA2D);
    outR.beginDraw();
    outR.clear();
    outR.image(tailR,0,0);
    outR.endDraw();

    ie.addImage(outL,"temp/"+number+"/"+sublog+"/Images/L/in_"+("0000000000"+where).substring((where+"").length())+".png");
    ie.addImage(outR,"temp/"+number+"/"+sublog+"/Images/R/in_"+("0000000000"+where).substring((where+"").length())+".png");
    prevImage = outL;
    where++;
    row = null;
  }
  table = null;
  }
  void compileLog(int sublog){
    if(stop){return;}
    currentState=lang.getTranslation("rendererStateCompiling");
    ProcessBuilder processBuilder;
    if(System.getProperty("os.name").contains("Mac")){
    processBuilder = new ProcessBuilder(sketchPath()+"/assets/ffmpeg", "-r", fps+"", "-i", sketchPath()+"/temp/"+number+"/"+sublog+"/out/out%04d.png", "-vcodec", "prores_ks","-pix_fmt", "yuva444p10le", "-profile:v", "4444", "-q:v", "20", "-r", fps+"", "-y", outputPath.getAbsolutePath()+"/"+file.getName().substring(0,file.getName().length()-4)+".mov");
    }else{
    processBuilder = new ProcessBuilder(sketchPath()+"/assets/ffmpeg.exe", "-r", fps+"", "-i", sketchPath()+"/temp/"+number+"/"+sublog+"/out/out%04d.png", "-vcodec", "prores_ks","-pix_fmt", "yuva444p10le", "-profile:v", "4444", "-q:v", "20", "-r", fps+"", "-y", outputPath.getAbsolutePath()+"/"+file.getName().substring(0,file.getName().length()-4)+".mov");
    }
  try {
    Process process = processBuilder.start();
    InputStream is = process.getErrorStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    String line = reader.readLine();
    while (line !=null) {
      if (line.contains("frame")&&line.charAt(0)=='f') {
        String s = line+"";
        s = s.replaceAll("[A-Z,a-z,=]","");
        String []split = s.split(" ");
        String out="";
        for(int i = 0; i<split.length; i++){
          if(out.equals("")){out=split[i];}
        }        
        currentFrame=Integer.parseInt(out);
      }
      println(line);
      line= reader.readLine();
    }
  }
  catch(Exception e) {
  }
  }
  void startRender(){
    running=true;
    start();
  }
  void parseSettings(){
    fps=Float.parseFloat(settings[0]);
    tailLength=Integer.parseInt(settings[1]);
    vidWidth=Integer.parseInt(settings[2]);
    sticksMode=Integer.parseInt(settings[3]);
    sticksColor = new int[]{Integer.parseInt(settings[4].substring(1, 3), 16), Integer.parseInt(settings[4].substring(3, 5), 16), Integer.parseInt(settings[4].substring(5, 7), 16)};
    
  }
  void prepBlender(int sublog){
    currentState="prepping 3D animation";
    try{
      new File(sketchPath()+"/temp/"+number+"/"+sublog+"/").mkdir();
    Path source =Paths.get(sketchPath()+"/assets/template.blend");
    Path newDir = Paths.get(sketchPath()+"/temp/"+number+"/"+sublog);
    Files.copy(source, newDir.resolve(source.getFileName()));
    source = Paths.get(sketchPath()+"/assets/script.py");
    newDir = Paths.get(sketchPath()+"/temp/"+number+"/"+sublog);
    Files.copy(source, newDir.resolve(source.getFileName()));

    String[] blenderSettings = new String[7];
    blenderSettings[0]=file.getName();
    blenderSettings[1]=vidWidth+"";
    blenderSettings[2]=""+sticksColor[0];
    blenderSettings[3]=""+sticksColor[1];
    blenderSettings[4]=""+sticksColor[2];
    
    blenderSettings[5]=fps+"";
    saveStrings(sketchPath()+"/temp/"+number+"/"+sublog+"/settings.txt",blenderSettings);
    ProcessBuilder processBuilder= new ProcessBuilder(sketchPath()+"/assets/blender2.90.1/blender.exe" ,sketchPath()+"/temp/"+number+"/"+sublog+"/template.blend","--python",sketchPath()+"/temp/"+number+"/"+sublog+"/script.py","-b");

    Process process = processBuilder.start();InputStream is = process.getInputStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    String line = reader.readLine();
    while (process.isAlive()) {
      line = reader.readLine();
      }
    }catch(Exception e){e.printStackTrace();}
  }
  
  void renderBlender(int sublog){
    currentState = "rendering 3D sticks";
    ProcessBuilder processBuilder= new ProcessBuilder(sketchPath()+"/assets/blender2.90.1/blender.exe" ,sketchPath()+"/temp/"+number+"/"+sublog+"/template.blend","-b","-a");
    try {
    Process process = processBuilder.start();
    InputStream is = process.getInputStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    String line = reader.readLine();
    while (process.isAlive()) {
      
        String[] t = reader.readLine().split(" ");
        String s= t[0];
        int temp = int((s.replaceAll("Fra:","")).trim());
        if(temp!=0&&currentFrame!=temp){
          String num = int(currentFrame)+"";
          while(num.length()<4){
            num="0"+num;
          }
          prevImage= loadImage(sketchPath()+"/temp/"+number+"/"+sublog+"/out/out"+num+".png");
          currentFrame=temp;
          
        }
        
    }
  }
  catch(Exception e) {
  }
  }
  @Override void run(){
    starttime=millis();
    if(stop){return;}
    convertLog();
    
    if(stop){return;}
        
        for(int i = 0; i< logs.length; i++){
          starttime=millis();
          file = logs[i];
          ie = new ImageExporter();
          if(tailLength>0){
          renderLog(i);
          }
          while(ie.queue.size()>0){
          try{Thread.sleep(10);}catch(Exception e){}}
          ie.done=true;
          starttime=millis();
          prepBlender(i);
          starttime=millis();
          renderBlender(i);
          starttime=millis();
          
          compileLog(i);
        }
    

    deleteDir(new File(sketchPath()+"/temp/"+number+"/"));
    running=false;
    currentState="Done";
  }
  int getETA(){
    float percent = currentFrame/numFrames;
    int dt = millis()-starttime;
    return (int)max(((dt/percent-millis()+starttime)/1000),0);
  }
  int getRuntime(){
    return (int)((millis()-starttime)/1000);
  }
  void stopRender(){
    stop=true;
  }
  File[] getLogs(File f){
    File[] files = new File(f.getParent()).listFiles();
    LinkedList<File> files2 = new LinkedList<File>();
    for(int i = 0; i< files.length;i++){
      if(files[i].getAbsolutePath().contains(".csv")&&files[i].getAbsolutePath().contains(f.getName().substring(0,f.getName().length()-4))){

        File del = new File(files[i].getAbsolutePath().substring(0,files[i].getAbsolutePath().length()-4)+".event");
        del.delete();
        del = new File(files[i].getAbsolutePath().substring(0,files[i].getAbsolutePath().length()-4)+".gps.csv");
        del.delete();
        del = new File(files[i].getAbsolutePath().substring(0,files[i].getAbsolutePath().length()-4)+".gps.gpx");
        del.delete();
        files[i].renameTo(new File(sketchPath()+"/temp/"+number+"/csv/"+files[i].getName()));
        files[i] = new File(sketchPath()+"/temp/"+number+"/csv/"+files[i].getName());
        files2.add(files[i]);
      }
    }
    files = new File[files2.size()];
    for(int i = 0; i< files.length;i++){
      files[i] = files2.get(i);
    }
    return files;
  }
}
