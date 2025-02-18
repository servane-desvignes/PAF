/**
  * Custom class for displaying information in a graph format
  */
class Graph {
 
  boolean toggleLogging = false;
  
  /********** FIELDS **********/
  
  int graphWidth;          // Width of the graph
  int graphHeight;         // Height of the graph
  int margin;              // Margin around the graph
  PVector graphOrigin;     // Bottom left of the graph
  
  int red   = 50;          // RGB color of the curve
  int green = 50;          // 
  int blue  = 200;         //
  
  FloatList xData;         // Bottom axis data
  FloatList yData;         // Left axis data
  
  float xDistortion;       // How distorted the xData is for it to fit
  float yDistortion;       // How distorted the yData is for it to fit
  boolean[] axisToDistort;
  
  boolean dataFilled;
  
  /********** CONSTRUCTORS **********/
  
  Graph ( PVector graphOrigin , int graphWidth , int graphHeight , int margin) {
    
    this.graphOrigin = graphOrigin;
    this.graphWidth = graphWidth;
    this.graphHeight = graphHeight;
    this.margin = margin;
    dataFilled = false;
    
  }
  
  Graph ( int graphOriginX , int graphOriginY , int graphWidth , int graphHeight , int margin ) {

    this.graphOrigin = new PVector ( graphOriginX , graphOriginY );
    this.graphWidth = graphWidth;
    this.graphHeight = graphHeight;
    this.margin = margin;
    dataFilled = false;
    
  }
  
  /********** DATA SETTERS **********/
  
  /**
    * Sets the data fields with the given ArrayLists. If there's a dimension
    * problem, nothing happens and it returns false
    */
  boolean fillData ( FloatList xData , FloatList yData ) {
    
    if (toggleLogging) System.out.println(printType() + " - Filling data fields");
    
    if ( xData.size() != yData.size() ) return false;
    
    else {
      
      this.xData = xData;
      
      if (xData == yData) {
        
        FloatList tmp = new FloatList();
        tmp = yData.copy();
        this.yData = tmp;
        
      } else this.yData = yData;
      
      levelData();
      
      dataFilled = true;
      
      return true;
      
    }
    
  }
  
  /**
    * Sets the xData field with the given ArrayList. If there's a dimension
    * problem, nothing happens and it returns false
    */
  boolean fillXData ( FloatList xData ) { return fillData ( xData , this.yData ); }
  
  /**
    * Sets the yData field with the given ArrayList. If there's a dimension
    * problem, nothing happens and it returns false
    */
  boolean fillYData ( FloatList yData ) { return fillData ( this.xData , yData ); }
  
  /********** LEVELLING **********/
  
  /**
    * Makes sure all the data fits in the graph
    */
  private void levelData() {
    
    if (toggleLogging) System.out.println(printType() + " - Filling display data fields");
    
    if (xData.size() == 0 ||yData.size() == 0) return;
    
    distortData(refreshDistortion());
    
  }
  
  /**
    * Computes the required distortion values to make the data fit in the graph
    * Returns a bool[2] that informs weither the distrotion could be calculated
    * for x ([0]) and y ([1])
    */
   boolean[] refreshDistortion () {
    
    if (toggleLogging) System.out.println(printType() + " - Refreshing distortion fields");
    
    boolean[] res = new boolean[2];
    float maxX = xData.get(0);
    float maxY = yData.get(0);
    
    for (int i = 1 ; i < xData.size() ; i++) {
      
      if (xData.get(i) > maxX) maxX = xData.get(i);
      if (yData.get(i) > maxY) maxY = yData.get(i);
      
    }
    
    if ( maxX != 0 ) {
     
      xDistortion = graphWidth  / maxX ;
      res[0] = true;
      
    } else res[0] = false;
      
    if ( maxY != 0 ) {
     
      yDistortion = graphHeight  / maxY ;
      res[1] = true;
      
    } else res[1] = false;
    
    return res;
    
  }
  
  /**
    * Applies the current distortion settings to all elements of each data set
    */
  private void distortData(boolean[] axisToDistort) {
    
    if (toggleLogging) System.out.println(printType() + " - Refreshing display data fields");
    
    for (int i = 0; i < xData.size(); i++) {
      
      if (axisToDistort[0]) xData.mult( i , xDistortion );
      if (axisToDistort[1]) yData.mult( i , yDistortion );
      
    }
    
    this.axisToDistort = axisToDistort;
    
  }
  
  boolean[] getAxisToDistort() { return axisToDistort; }
  
  float[] getDistortion() {
    float[] tmp = new float[2];
    tmp[0] = xDistortion;
    tmp[1] = yDistortion;
    return tmp;
  }
  
  /********** RENDERING **********/
  
  /**
    * Displays the graph on the screen. It will just be a blank rectangle
    * if the data fields aren't set.
    */
  boolean render () {
    
    if (toggleLogging) System.out.println(printType() + " - Rendering");
    
    renderBackground();
           
    if ( dataFilled ) {
      
      renderCurve();
      
      return true;
      
    } else return false;
    
  }
  
  void renderCurve () {
    
    stroke ( red , green , blue );
      
      for ( int i = 0 ; i < xData.size() - 1 ; i++ ) {
        
        line ( (int) graphOrigin.x + xData.get(i)   ,
               (int) graphOrigin.y - yData.get(i)   ,
               (int) graphOrigin.x + xData.get(i+1) ,
               (int) graphOrigin.y - yData.get(i+1) );
        
      }
    
  }
  
  void renderBackground () {
    
    fill ( 255 );
    stroke ( 100 );
    
    rect ( (int) graphOrigin.x - margin , 
           (int) graphOrigin.y - graphHeight - margin ,
           graphWidth  + 2 * margin ,
           graphHeight + 2 * margin );
           
  }
  
  void setCurveColor ( int red , int green , int blue ) {
    
    this.red = red;
    this.green = green;
    this.blue = blue;
    
  }
  
  String printType() { return "Graph";}
 
}
