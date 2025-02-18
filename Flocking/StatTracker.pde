/**
 * Stores a bunch of stats
 */
class StatTracker {

  private boolean toggleLogging = false;

  /********** CORE FIELDS **********/

  Savana savana;
  private int frameDelta;        // Keeps track of the frames since last refresh
  private final int refreshRate; // Number of frames in between two information-fetching, adjust to prevent lag
  private FloatList graphAbsciss;
  boolean isStarted;

  /********** DATA FIELDS **********/

  private IntList entityCount;
  private IntList wildebeestCount;
  private IntList zebraCount;
  private IntList predatorCount;
  private FloatList lifetime;    // List of lifetime by each dead boids
  private IntList tmpLifetime;

  /********** CONSTRUCTORS **********/

  StatTracker (Savana savana, int refreshRate) {

    this.savana = savana;
    this.refreshRate = refreshRate;
    frameDelta = 0;
    graphAbsciss = new FloatList();
    isStarted = false;

    // Initializes data
    entityCount = new IntList();
    wildebeestCount = new IntList();
    zebraCount = new IntList();
    predatorCount = new IntList();
    lifetime = new FloatList();
    tmpLifetime = new IntList();
  }

  /********** REFRESH METHODS **********/

  // CORE METHODS

  void refresh () {

    if (!isStarted) return;
    
    frameDelta++;
    getLifetimes();

    if (frameDelta < refreshRate) return;
    else {

      if (toggleLogging) System.out.println( "STATTRACKER - Refreshing, interation " + str( int( frameCount/refreshRate ) ) );

      fetchData();
      frameDelta = 0;
      
      graphAbsciss.append( frameCount );
    }
  }

  void fetchData() {

    if (toggleLogging) System.out.println( "STATTRACKER - Fetching Data" );
    
    fetchEntityCount();
    fetchWildebeestCount();
    fetchZebraCount();
    fetchPredatorCount();

    fetchLifetime();
  }
  
  void startTracking() { isStarted = true; }

  /********** GRAPH MANAGEMENT **********/
  
  void renderGraphs() {
    
    if (!isStarted) return;
    
    // ENTITYCOUNT
    
    Graph entityCountGraph = new Graph( 1000 , 680 , 240 , 180 , 25 ); //<>//
    
    FloatList FLentityCount = new FloatList();
    for (int i=0 ; i<entityCount.size() ; i++) FLentityCount.append( (float) entityCount.get(i) );
    
    entityCountGraph.fillData ( graphAbsciss.copy() , FLentityCount );
    
    // WILDEBEESTS
    
    TransparentGraph wildebeestCountGraph = new TransparentGraph( 1000 , 680 , 240 , 180 , 25 , entityCountGraph );
    wildebeestCountGraph.setCurveColor( 245, 198, 215 );
    
    FloatList FLwildebeestCount = new FloatList();
    for (int i=0 ; i<entityCount.size() ; i++) FLwildebeestCount.append( (float) wildebeestCount.get(i) );
    
    wildebeestCountGraph.fillData ( graphAbsciss.copy() , FLwildebeestCount );
    
    // ZEBRAS
    
    TransparentGraph zebraCountGraph = new TransparentGraph( 1000 , 680 , 240 , 180 , 25 , entityCountGraph );
    zebraCountGraph.setCurveColor( 0, 128, 0 );
    
    FloatList FLzebraCount = new FloatList();
    for (int i=0 ; i<entityCount.size() ; i++) FLzebraCount.append( (float) zebraCount.get(i) );
    
    zebraCountGraph.fillData ( graphAbsciss.copy() , FLzebraCount );
    
    // PREDATORS
    
    TransparentGraph predatorCountGraph = new TransparentGraph( 1000 , 680 , 240 , 180 , 25 , entityCountGraph );
    predatorCountGraph.setCurveColor( 220 , 50 , 50 );
    
    FloatList FLpredatorCount = new FloatList();
    for (int i=0 ; i<entityCount.size() ; i++) FLpredatorCount.append( (float) predatorCount.get(i) );
    
    predatorCountGraph.fillData ( graphAbsciss.copy() , FLpredatorCount );
    
    // RENDERING
    
    entityCountGraph.render();
    wildebeestCountGraph.render();
    zebraCountGraph.render();
    predatorCountGraph.render();
    
  }

  /********** SAVING METHODS **********/

  boolean saveEntityCounts() {

    if (toggleLogging) System.out.println( "STATTRACKER - Saving Entity Counts" );

    System.out.println( "Saving" );

    JSONObject json = entityCountsToJSON();

    try {

      if (toggleLogging) System.out.println( "STATTRACKER - Attempting to save JSON Entity Counts file" );
      saveJSONObject( json, "data/entityCounts.json" );
    }
    catch (Exception ex) {

      return false;
    }

    return true;
  }

  private JSONObject entityCountsToJSON () {

    if (toggleLogging) System.out.println( "STATTRACKER - Converting Entity Counts to JSON" );

    if (toggleLogging) printCounts();

    JSONObject json = new JSONObject();

    for ( int i = 0; i < entityCount.size(); i ++ ) {

      json.setString( "entities" + str(i), str( entityCount.get(i) ) );
      json.setString( "preys" + str(i), str( wildebeestCount.get(i) ) );
      json.setString( "predators" + str(i), str( predatorCount.get(i) ) );
      json.setString( "lifetime" + str(i), str( lifetime.get(i) ) );
    }

    return json;
  }

  private void printCounts() {

    String entityCountStr = "entityCount : [ ";

    for (int i = 0; i<entityCount.size(); i++) entityCountStr += ( str(entityCount.get(i)) + " , " );

    System.out.println( entityCountStr );

    // *********************

    String wildebeestCountStr = "wildebeestCount : [ ";

    for (int i = 0; i<wildebeestCount.size(); i++) wildebeestCountStr += ( str(wildebeestCount.get(i)) + " , " );

    System.out.println( wildebeestCountStr );

    // *********************

    String predatorCountStr = "entityCount : [ ";

    for (int i = 0; i<predatorCount.size(); i++) predatorCountStr += ( str(predatorCount.get(i)) + " , " );

    System.out.println( predatorCount );
  }

  /********** REFRESH SUB-METHODS **********/

  void fetchEntityCount() {

    if (toggleLogging) System.out.println( "STATTRACKER - Fetching Data - entityCount" );
    entityCount.append( savana.boids.size() );
  }

  void fetchWildebeestCount() {

    if (toggleLogging) System.out.println( "STATTRACKER - Fetching Data - wildebeestCount" );

    wildebeestCount.append( savana.getWildebeests().size() );
  }
  
  void fetchZebraCount() {
    
    if (toggleLogging) System.out.println( "STATRACKER - Fetching Data - zebraCount" );
    
    zebraCount.append( savana.getZebras().size() );
    
  }

  void fetchPredatorCount() {

    if (toggleLogging) System.out.println( "STATTRACKER - Fetching Data - predatorCount" );

    predatorCount.append( savana.getPredators().size() );
  }

  /**
   * Stores the lifetimes of boids dead during the frame into the temporary list
   */
  void getLifetimes() {

    for (Boid boid : savana.boids) {

      if (!boid.isAlive()) tmpLifetime.append( boid.lifetime );
    }
  }

  /**
   * Empties the tmp lifetime list and stores its avergae in the lifetime IntList
   */
  void fetchLifetime() {

    if (toggleLogging) System.out.println( "STATRACKER - Fetching Data - lifeTime" );

    float avg = 0;

    for ( int i : tmpLifetime ) avg += i;

    avg /= tmpLifetime.size();

    int iterations = lifetime.size();

    if (iterations != 0) {

      lifetime.append( ( iterations * lifetime.get( iterations - 1 ) + avg ) / ( iterations + 1 ) );
    } else {
      lifetime.append ( avg );
    }

    tmpLifetime.clear();
  }
}
