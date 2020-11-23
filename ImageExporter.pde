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
        
          for(int i = 0; i< queue.size();i++){
              queue.get(i).start();
              queue.remove(i);
          }
          
        Thread.sleep(10);
      }catch(Exception e){
      e.printStackTrace();
    }
    }
  }
}
