class ImageExporter extends Thread{
  LinkedList<RenderImage> queue = new LinkedList<RenderImage>();
  boolean done =false;
  ImageExporter(){
    this.start();
  }
  void addImage(PImage image, String path){
    queue.add(new RenderImage(image,path));
  }
  @Override
  void run(){
    while(!done){
      try{

          if(queue.size()>0){
          queue.getFirst().start();
          queue.removeFirst();
          }
        Thread.sleep(1);
      }catch(Exception e){
      e.printStackTrace();
    }
    }
  }
}
