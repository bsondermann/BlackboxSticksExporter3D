import java.nio.file.Files;
import java.nio.file.Path; 
import java.nio.file.Paths; 
import http.requests.*;
import processing.sound.*;
import java.io.PrintStream;
import java.io.FileOutputStream;
import java.util.LinkedList;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.InputStreamReader; 
import drop.*;
Selection s;
File inputPath,outputPath;
LinkedList<File> inputFiles = new LinkedList<File>();
int inputFilesNum=0;
XML data;
RenderManager rm;
float version;
boolean newVersion=false;
Language lang;
SDrop drop;
void setup(){
  size(800,600);
  useNativeSelect=false;
  println(System.getProperty("os.name"));
  final PImage icon = loadImage("assets/icon.png");
  surface.setIcon(icon);
  drop = new SDrop(this);
  data = loadXML(sketchPath()+"/assets/data.xml");
  if(data.getChildren("data")[0].getContent()!=""){
    inputPath=new File(data.getChildren("data")[0].getContent());
    inputFilesNum=getNumFiles(inputPath);
  }
  if(data.getChildren("data")[1].getContent()!=""){
    outputPath=new File(data.getChildren("data")[1].getContent());
  }if(data.getChildren("data")[2].getContent()!=""){
    version = Float.parseFloat(data.getChildren("data")[2].getContent());
  }if(data.getChildren("data")[3].getContent()!=""){
    int last = Integer.parseInt(data.getChildren("data")[3].getContent());
    if(last!=hour()){
      newVersion=checkUpdates();
      data.getChildren("data")[3].setContent(hour()+"");
      saveXML(data,"assets/data.xml");
    }
  }else{
      newVersion=checkUpdates();
      data.getChildren("data")[3].setContent(hour()+"");
      saveXML(data,"assets/data.xml");
  }
  lang = new Language(data.getChildren("data")[4].getContent());

  
  if(!newVersion){
    s=new Selection(this);
  }
  thread("clearTemp");
  frameRate(30);
}
void draw(){
  
  background(50);
  if(!newVersion){
    s.show();
    if(s.active()){
    if(inputPath!=null){
      String text=inputPath.getAbsolutePath()+" | "+inputFilesNum+" "+lang.getTranslation("infoNumLogsFound");
      textAlign(CENTER,BOTTOM);
      stroke(0);
      fill(100);
      rect(400-(textWidth(text)+20)/2,58,textWidth(text)+20,22);
      fill(0);
      text(text,400,76);
    }
    if(inputPath==null&&inputFiles.size()>0){
      String text=inputFiles.size()+" "+lang.getTranslation("infoNumLogsFound");
      textAlign(CENTER,BOTTOM);
      stroke(0);
      fill(100);
      rect(400-(textWidth(text)+20)/2,58,textWidth(text)+20,22);
      fill(0);
      text(text,400,76);
    }
    if(outputPath!=null){      
      textAlign(CENTER,BOTTOM);
      stroke(0);
      fill(100);
      rect(400-(textWidth(outputPath.getAbsolutePath())+20)/2,118,textWidth(outputPath.getAbsolutePath())+20,22);
      fill(0);
      text(outputPath.getAbsolutePath(),400,137);
    }
  }
  }else{
    fill(255);
    textAlign(CENTER,CENTER);
    text(lang.getTranslation("newVersionAlert"),width/2,height/2);
    
  }
}

void actionPerformed(GUIEvent e){
    s.actionPerformed(e);
}
void InputSelected(File selection){
  if(selection!=null){
    inputPath=selection;
    inputFilesNum=getNumFiles(inputPath);
    data.getChildren("data")[0].setContent(selection.getAbsolutePath());
    saveXML(data,"assets/data.xml");
  }
}
void OutputSelected(File selection){
  if(selection!=null){
    data.getChildren("data")[1].setContent(selection.getAbsolutePath());
    saveXML(data,"assets/data.xml");
    outputPath=selection;
  }
}
int getNumFiles(File path){
  int num=0;
  File[] files = path.listFiles();
  for(int i = 0; i<files.length; i++){
    if(files[i].getName().contains(".BFL")||files[i].getName().contains(".bbl")){
      num++;
    }else if(files[i].getName().contains(".TXT")){
      String []s = loadStrings(files[i]);
      if(s.length>0){
        if(s[0].equals("H Product:Blackbox flight data recorder by Nicholas Sherlock")){
          num++;
        }
      }
    }
  }
  return num;
}
void clearTemp(){
  deleteDir(new File(sketchPath()+"/temp/"));
  if(s!=null){
  s.tempClear=true;
  }
}
void deleteDir(File file) {
    File[] contents = file.listFiles();
    if (contents != null) {
        for (File f : contents) {
            if (! Files.isSymbolicLink(f.toPath())) {
                deleteDir(f);
            }
        }
    }
    file.delete();
}
void mouseDragged(){
  if(s!=null){
    s.mouseDown();
  }
}
void mousePressed(){
  if(newVersion){
    try{
    Desktop.getDesktop().browse(new URL("https://www.github.com/bsondermann/BlackboxSticksExporter/releases/").toURI());
    }catch(Exception e){e.printStackTrace();}
  }
if(s!=null){
    s.mousePress();
  }
}
void mouseReleased(){
if(s!=null){
    s.mouseRel();
  }
}
void exit(){
  if(s!=null){
    s.stop();
  }
  surface.setVisible(false);
  delay(2000);
  clearTemp();
  super.exit();
  
}
boolean checkUpdates(){
  /*GetRequest get = new GetRequest("https://api.github.com/repos/bsondermann/BlackboxSticksExporter/releases/latest");
  get.send();
  
  if(Float.parseFloat(parseJSONObject(get.getContent()).getString("tag_name").trim().substring(1))>version){return true;}
  else{return false;}
*/return false;}
void shutdown(){
  try{
  Runtime r = Runtime.getRuntime();
  Process proc = r.exec("shutdown -s -t 0");
  exit();
}
  catch(Exception e){}
}
void dropEvent(DropEvent e){
  if(e.isFile()){
    File f = e.file();
    if(f.isDirectory()){
      inputPath=f;
      inputFilesNum=getNumFiles(inputPath);
      
      data.getChildren("data")[0].setContent(f.getAbsolutePath());
      saveXML(data,"assets/data.xml");
    }else{
      if(f.getAbsolutePath().contains(".BFL")||f.getAbsolutePath().contains(".bbl")||f.getAbsolutePath().contains(".TXT")){
        boolean contains = false;
        for(File fi : inputFiles){
          if(fi.getAbsolutePath().equals(f.getAbsolutePath())){
            contains=true;
          }
        }
        if(!contains){
          String []s = loadStrings(f);
          if(s.length>0){
            if(s[0].equals("H Product:Blackbox flight data recorder by Nicholas Sherlock")){
              inputFiles.add(f);
              println(loadStrings(f)[0]);
              inputPath=null;
            }
          }
        }
      }
    }
  }
}
void savePreset(File f){
  if(s!=null){
    s.savePreset(f);
  }
}
void loadPreset(File f){
  if(s!=null){
    s.loadPreset(f);
  }
}
