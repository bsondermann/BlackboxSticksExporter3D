class Preview{
  int posy;
  float offset=20;
  float scrollPos=0.0;
  int scrollControlHeight=50;
  int windowHeight=0;
  int activeRenderers=0;
  RenderManager rm;
  Renderer[] renderers;
  Preview(int posy, RenderManager manager){
    this.posy=posy;
    this.rm = manager;
    renderers = rm.getRenderers();
    windowHeight=max((renderers.length+1)*50-(height-posy+10),0);
  }
  
  void show(){
    offset=-map(scrollPos,0,1,0,windowHeight)+25;
    fill(25);
    stroke(0);
    rect(0,posy,width,height-20-posy);
    fill(38);
    rect(width-15,posy,20,height-15);
    int posindex=0;
    for(int i = 0; i< renderers.length;i++){
      if(renderers[i].currentState.equals(lang.getTranslation("rendererStateDone"))){
        activeRenderers++;
      }
      if(renderers[i].running){
        fill(150);
        textAlign(LEFT,TOP);
        text(renderers[i].file.getName().substring(0,renderers[i].file.getName().length()-4),0,posy+posindex*50+offset);
        textAlign(RIGHT,TOP);
        text(renderers[i].currentState,width-100,posy+posindex*50+offset);
        textAlign(CENTER,TOP);
        String sec1;
        String sec2="00";
        String sec21="0:";
        if(renderers[i].getRuntime()%60<10){sec1="0"+renderers[i].getRuntime()%60;}else{sec1=renderers[i].getRuntime()%60+"";}
        if(renderers[i].getETA()!=MAX_INT){
        if(renderers[i].getETA()%60<10){sec2="0"+renderers[i].getETA()%60;}else{sec2=renderers[i].getETA()%60+"";}
        sec21=renderers[i].getETA()/60+":";
        }
        text(renderers[i].getRuntime()/60+":"+sec1+"    |    "+sec21+sec2,(width-100)/2,posy+posindex*50+offset);
        
        noFill();
        strokeWeight(3);
        stroke(0);
        rect(0,posy+posindex*50+offset+20,width-100,20);
        fill(255,0,0);
        rect(0,posy+posindex*50+offset+20,map(constrain(renderers[i].currentFrame,0,renderers[i].numFrames),0,renderers[i].numFrames,0,width-100),20);
        strokeWeight(1);
        fill(150);
        stroke(0);
        textAlign(CENTER,TOP);
        text((int)map(constrain(renderers[i].currentFrame,0,renderers[i].numFrames),0,renderers[i].numFrames,0,100)+"%",(width-100)/2,posy+posindex*50+offset+24);
        fill(50);
        strokeWeight(3);
        rect(width-97,posy+posindex*50+offset,80,40);
        strokeWeight(1);
        imageMode(CORNER);
        if(renderers[i].prevImage!=null){
          image(renderers[i].prevImage,width-97,posy+posindex*50+offset+2,80,40);
        }
        posindex++;
      }
      
    }
    int posindex2=0;
    for(int i = 0; i< renderers.length;i++){
      if(!renderers[i].running){
        fill(150);
        textAlign(LEFT,TOP);
        text(renderers[i].file.getName().substring(0,renderers[i].file.getName().length()-4),0,posy+(posindex+posindex2)*50+offset);
        textAlign(RIGHT,TOP);
        text(renderers[i].currentState,width-100,posy+(posindex+posindex2)*50+offset);
        posindex2++;
      }
    }
    fill(50);
    rect(0,0,width,posy);
    
    strokeWeight(3);
    stroke(0);
    fill(25);
    rect(0,posy+1,width-15,20);
    fill(255,0,0);
    rect(0,posy+1,map(constrain(activeRenderers,0,renderers.length),0,renderers.length,0,width-15),20);
    strokeWeight(1);
    fill(150);
    stroke(0);
    textAlign(CENTER,TOP);
    text(activeRenderers+" / "+renderers.length,(width-15)/2,posy+3);
    
    fill(60);
    rect(width-15,map(scrollPos,0,1,posy,height-20-scrollControlHeight),15,scrollControlHeight);
    activeRenderers=0;
  }
  void mouseDown(){
  if(mouseX>width-15&&mouseY>map(scrollPos,0,1,posy,height-20-scrollControlHeight)&&mouseY<map(scrollPos,0,1,posy,height-20-scrollControlHeight)+scrollControlHeight);{
    scrollPos=constrain(map(mouseY-scrollControlHeight/2,posy,height-20-scrollControlHeight,0,1),0,1);
  }
  }

}
