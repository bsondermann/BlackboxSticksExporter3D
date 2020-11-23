class Language{
  String name;
  XML[] content;
  String[]contentstring;
  PImage langImage;
  Language(String name){
    this.name=name;
    langImage = loadImage(sketchPath()+"/assets/lang/images/"+name+".png");
    if(name.equals("ru")||name.equals("ua")){
      contentstring = loadStrings(sketchPath()+"/assets/lang/lang/"+name+".xml");
    }
    loadLang();
  }
  void loadLang(){
    content = loadXML(sketchPath()+"/assets/lang/lang/"+name+".xml").getChildren("text");
  }
  String getTranslation(String id){
    String ret = "NO TRANSLATION!";
    for(int i = 0; i< content.length; i++){
      if(content[i].getString("id").equals(id)){
        if(name.equals("ru")||name.equals("ua")){
            ret= contentstring[i+1].substring(contentstring[i+1].length()-7-content[i].getContent().length(),contentstring[i+1].length()-7);

          
        }else{
          ret = content[i].getContent()+"";
        }
      }
    }
    return ret;
  }
  PImage getImage(){
    return langImage;
  }
}
