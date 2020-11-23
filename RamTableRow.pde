class RamTableRow{
  private String[]content;
  RamTableRow(String row){
    content = row.split(",");
  }
  String getString(int index){return content[index];}
}
