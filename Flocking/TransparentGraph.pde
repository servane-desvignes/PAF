class TransparentGraph extends Graph {
  
  Graph leadGraph;
  
  TransparentGraph( PVector graphOrigin , int graphWidth , int graphHeight , int margin , Graph leadGraph) {
    super ( graphOrigin , graphWidth , graphHeight , margin );
    this.leadGraph = leadGraph;
  }
  
  TransparentGraph( int xCoord , int yCoord , int graphWidth , int graphHeight , int margin , Graph leadGraph) {
    super ( xCoord , yCoord , graphWidth , graphHeight , margin );
    this.leadGraph = leadGraph;
  }
  
  @Override
  void renderBackground() { return; }
  
  @Override
  boolean[] refreshDistortion() {
    if (toggleLogging) System.out.println(printType() + " - Fetching distortion fields");
    float[] tmp = leadGraph.getDistortion();
    
    xDistortion = tmp[0];
    yDistortion = tmp[1];
    
    return leadGraph.getAxisToDistort();
    
  }
  
  @Override
  String printType() { return "TransparentGraph"; }
  
}
