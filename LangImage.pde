class LangImage{
  PImage image;
  PVector pos;
  String name;
  boolean mdown=false;
  XML xml;
  BlackboxSticksExporter3D bbse;
  LangImage(File f,PVector pos,BlackboxSticksExporter3D s){
    this.bbse=s;
    image = loadImage(f.getAbsolutePath());
    name = f.getName().substring(0,f.getName().length()-4);
    this.pos = pos;
    xml = loadXML(sketchPath()+"/assets/data.xml");
  }
  boolean update(){
    boolean ret = false;
    if(mouseY>pos.y-15&&mouseY<pos.y+15&&mouseX>pos.x-25&&mouseX<pos.x+25&&mousePressed&&mdown!=true){
      mdown=true;
      xml = loadXML(sketchPath()+"/assets/data.xml");
      xml.getChildren("data")[4].setContent(name);
      saveXML(xml,sketchPath()+"/assets/data.xml");
      setup();
      ret = true;
    }
    
      
    if(!mousePressed){mdown=false;}
    return ret;
  }
  PImage getImage(){
    return this.image;
  }
  
}
