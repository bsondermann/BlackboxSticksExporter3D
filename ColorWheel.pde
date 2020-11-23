import java.awt.Color;
class ColorWheel{
  int w ,posx,posy;
  PImage ring;
  PImage rect;
  PVector posSelRing;
  PVector posSelRect;
  boolean ringSelected=false,rectSelected=false;
  Settings set;
  IFTextField f;
  ColorWheel(int w,int px,int py,Settings set,IFTextField f){
    
    posSelRing= new PVector(0,-1);
    posSelRect= new PVector(1,0);
    setColor(f.getValue());
    this.w = w;
    this.posx= px;
    this.posy = py;
    this.set = set;
    this.f =f;
    ring = createImage(w,w,ARGB);
    rect = createImage((int)(((w/2)*0.8)/sqrt(2)*2),(int)(((w/2)*0.8)/sqrt(2)*2),ARGB);
    ring.loadPixels();
    for(int x = 0; x<w; x++){
      for(int y = 0; y<w; y++){
        float d=dist(x,y,w/2,w/2);
        PVector vec = new PVector(x-w/2,y-w/2).normalize();
        float angle = vec.heading()/TWO_PI;
        if(d<w/2&&d>(w/2)*0.8){
          ring.pixels[x+y*w]=Color.HSBtoRGB(angle,1,1);
        }else{
          
          ring.pixels[x+y*w]=color(0,0,0,0);
        }
      }
    }
    ring.updatePixels();
    calcRect();
  }
  boolean prevrectSelected=false;
  boolean prevringSelected=false;
  void show(){
    if(rectSelected){
        posSelRect.x= constrain(map(mouseX,posx+w/2-rect.width/2,posx+w/2+rect.width/2,0,1),0,1);
        posSelRect.y =constrain( map(mouseY,posy+w/2-rect.height/2,posy+w/2+rect.height/2,0,1),0,1);
        
        prevrectSelected=true;
    }
    if(ringSelected){
      posSelRing = PVector.fromAngle(new PVector(mouseX-(posx+w/2),mouseY-(posy+w/2)).heading());
      prevringSelected=true;
    }
    imageMode(CORNER);
    image(ring,posx,posy);
    noFill();
    stroke(255);
    strokeWeight(w*0.015);
    ellipseMode(CENTER);
    ellipse(posSelRing.x*((w/2)*0.9)+w/2+posx,posSelRing.y*((w/2)*0.9)+w/2+posy,(w/2)*0.1,(w/2)*0.1);
    imageMode(CENTER);
    image(rect,posx+w/2,posy+w/2);
    ellipse(map(posSelRect.x,0,1,posx+w/2-rect.width/2,posx+w/2+rect.width/2),map(posSelRect.y,0,1,posy+w/2-rect.height/2,posy+w/2+rect.height/2),(w/2)*0.1,(w/2)*0.1);
    fill(255,0,0);
    stroke(0);
    strokeWeight(1);
    rect(posx+w,posy-w/12,w/12,w/12);
    strokeWeight(3);
    stroke(100,0,0);
    line(posx+w+4,posy-w/12+4,posx+w+w/12-4,posy-4);
    line(posx+w+w/12-4,posy-w/12+4,posx+w+4,posy-4);
    
  }
  
  void mousePress(){
    float d=dist(mouseX,mouseY,posx+w/2,posy+w/2);
    if(d<w/2&&d>(w/2)*0.8&&!rectSelected){
      ringSelected=true;
    }
    
    if(mouseX>posx+w/2-rect.width/2&&mouseX<posx+w/2+rect.width/2&&mouseY>posy+w/2-rect.height/2&&mouseY<posy+w/2+rect.height/2&&!ringSelected){
      rectSelected=true;
    }
    if(mouseX>posx+w&&mouseX<posx+w+4+w/12&&mouseY>posy-w/12&&mouseY<posy-w/12+w/12){
     
      set.disableCW();
    }
  }
  void mouseRel(){
    rectSelected=false;
    ringSelected=false;
    calcRect();
  }
  void calcRect(){
    rect.loadPixels();
    for(int x = 0; x <rect.width;x++){
      for(int y = 0; y <rect.height; y++){
        rect.pixels[x+y*rect.width]=Color.HSBtoRGB(posSelRing.heading()/TWO_PI,map(x,0,rect.width,0,1),map(y,0,rect.width,1,0));
      }
    }
    rect.updatePixels();
    f.setValue("#"+getHexColor());
  }
  color getColor(){
    return Color.HSBtoRGB(posSelRing.heading()/TWO_PI,posSelRect.x,1-posSelRect.y);
  }
  void setColor(String col){
    int r = Integer.parseInt(col.substring(1,3),16);
    int g = Integer.parseInt(col.substring(3,5),16);
    int b = Integer.parseInt(col.substring(5,7),16);
    float[] hsb = Color.RGBtoHSB(r,g,b,null);
    posSelRing = PVector.fromAngle(map(hsb[0],0,1,0,TWO_PI));
    posSelRect = new PVector(hsb[1],1-hsb[2]);
  }
  String getHexColor(){
    return hex(getColor()).substring(2);
  }
}
