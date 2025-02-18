Savana savana; // l'ensemble des agents (proies + prédateurs) //<>//
Box[] carre=new Box[3]; 
Button launchButton;
int Xmaxgraph = int(1280-(1280/4));
int nbInitWildebeest;
int nbInitZebra;
StatTracker statTracker;
static int desireAssociation;


/** Met en place l'interface et les agents*/
void setup() {
  size(640*2, 360*2);
  savana = new Savana();
  statTracker = new StatTracker( savana, 1 ); // permettra de suivre les donnees pour faire le graphe
  
  launchButton =  new Button(1020, 170);

  // Les trois "handles" pour choisir les populations initiales et l'association
  carre[0] = new Box(width*3/4 +20, 90, 0, 8, carre);
  carre[1] = new Box(width*3/4 +20, 140, 0, 8, carre);
  carre[2] = new Box(width*3/4 +20, 190, 0, 8, carre);
  launchButton =  new Button(1020, 220);
}

/** Dessine l'interface et les agents a chaque frame **/

void draw() {
  background(152, 190, 100);

  //Les polices d'ecriture pour les instructions
  PFont Titre = createFont("DevanagariMT-48", 30);
  PFont sousTitre = createFont("HiraginoSans-W1-48", 25);

  //La ligne démarquant les instructions de la simulation
  stroke(0);
  line(Xmaxgraph, 0, Xmaxgraph, height);

  // Populations initiales , couleurs a changer plus tard

  textSize(20);
  fill(0);
  textFont(Titre);
  text("Initial Population", width*3/4 +10, 30);
  launchButton.update();
  launchButton.dessin();

  //variable de regrouppement
  fill(0);//noir
  text("Association             (en %)", width*3/4 +10, 180);
  text(carre[2].AssociationPourcent(), width*3/4 +200, 180);

  //proies
  textFont(sousTitre);

  fill(245, 198, 215);//rose
  text("Wildebeest", width*3/4 +10, 70);

  fill(0, 128, 0);//rose
  text("Zebra", width*3/4 +10, 125);

  fill(0);
  text(carre[0].preyNumber(), width*0.75+200, 70);
  text(carre[1].preyNumber(), width*3/4 +200, 125);

  //partie bar pour avoir conditions initiales :
  fill(0);
  line(width*3/4 +20, 90, width*3/4 +300, 90);
  line(width*3/4 +20, 140, width*3/4 +300, 140);
  //line(width*3/4 +20, 190, width*3/4 +300, 190);

  for (int i =0; i<2; i++) {
    carre[i].update();
    carre[i].display();
  }
  
  //apres utilisation : false
  if (firstMousePress) {
    firstMousePress = false;
  }
  
  //instructions pour les prédateurs

  fill(0);
  textFont(Titre);
  text("Predator Population", width*3/4 +10, height*0.35+30);
  
  textFont(sousTitre);
  text("Right click to add", width*3/4 +10, height*0.35+80);
  text("a cheetah", width*3/4 +10, height*0.35+110);
  //text("Left click to add a zebra", width*3/4 +10, height*0.35+150);
  
  //Partie predateurs
  fill(0);
  textFont(Titre);
  text("Graphe et statistique", width*3/4 +10, height*0.35+210);
  
  stroke(0, 255, 0);

  //bouton de lancement
  if (boutonAppuye && click==1) {
    println("lancement");

    BoutonAppuye(carre[0].preyNumber(), carre[1].preyNumber());
    
    statTracker.startTracking();
    boutonAppuye=false;
  }

  //lancement des agents
  savana.run();
  
  //partie statistiques et data
  statTracker.refresh();
  statTracker.renderGraphs();
}

/**Lancement de la simulation lorsque le bouton "Launch" est appuyé
*@param nWildeBeest population de gnous rentrée dans la barre handle
*@param nZebra population de zebres
* ajoute 4 predateurs au debut 
**/

void BoutonAppuye(int nWildeBeest, int nZebra) {
  for (int i = 0; i <nWildeBeest; i++) {
    int r1=int(random(7));
    //int r2=int(random(7));
    savana.addBoid(new Wildebeest(r1*width/6, r1*height/6));
    //savana.addBoid(new Wildebeest(r2*width/6, r2*height/6));
  }
  for (int i = 0; i < 4; i++) {
    int r1=int(random(7));
    int r2=int(random(7));
    savana.addBoid(new Cheetah(r1*width/6, r2*height/6));
  }

  for (int i = 0; i < nZebra; i++) {
    int r1=int(random(7));
    //int r2=int(random(7));
    savana.addBoid(new Zebra(r1*width/6, r1*height/6));
  }
}


void mousePressed() {
  if (!firstMousePress) {
    firstMousePress = true;
  }
  launchButton.testSouris();
}


void mouseClicked() {
  if (mouseButton == RIGHT && mouseX<Xmaxgraph  ) {
    savana.addBoid(new Cheetah(mouseX, mouseY));
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      savana.addBoid(new StudyCheetah(mouseX, mouseY));
    } else if (keyCode == DOWN) {
      int total = savana.number();
  println("The total number of animals is: " + total);
    } 
  } else {
    savana.addBoid(new Zebra(mouseX, mouseY));
  }
}

void mouseReleased() {
  for (int i = 0; i < carre.length; i++) {
    carre[i].releaseEvent();
  }
}
