class RenderImage extends Thread{
  PImage image;
  String path;
  boolean done=false;
  boolean started=false;
  RenderImage(PImage image, String path){
    this.image =image;
    this.path= path;
  }
  @Override
  void run(){
    started=true;
    try{
      File f = new File(sketchPath()+"/"+path);
      f.getParentFile().mkdirs();
      ImageIO.write((BufferedImage)image.getImage(),"png",f);
    }catch(Exception e){e.printStackTrace();}
    done=true;
  }
}
