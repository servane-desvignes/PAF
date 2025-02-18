class StudyCheetah extends Cheetah{
  
  
  StudyCheetah(float x,float y){
    super(x,y);}
    
    
    @Override
     void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    if(this.hasAPrey){
    fill(238, 241,22);
    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();}
    else{
       fill(136, 144,41);
    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    //le faisceau de vision
    vertex(0, -r*2);
    vertex(sin(alpha/2)*rangeVision,cos(alpha)*(-rangeVision)-r*2);
    vertex(-sin(alpha/2)*rangeVision,cos(alpha)*(-rangeVision)-r*2);
   
    endShape();
    popMatrix();}
    
   
  }
  
}
