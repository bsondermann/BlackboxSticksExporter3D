class RamTable{
  private String[]content;
  RamTable(String file){
    content = loadStrings(file);
  }
  RamTableRow getRow(int index){
    return new RamTableRow(content[index]);
  }
  int getRowCount(){return content.length;}
}
