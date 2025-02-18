static boolean boutonAppuye=false;
static int click=0;

/**Classe des boutons appuyables  **/

class Button {

  boolean rectOver=false ;

  int rectX, rectY; // coordonnees du bouton

  int largeur=70;
  int longueur=200;

  color rectHighlight=color(65, 147, 81); // couleur quand on passe la souris dessus

  color rectColor = color(28, 103, 42); // couleur normale sinon

  PFont sousTitre = createFont("HiraginoSans-W1-48", 17); // police du texte au dessus


  /** Constructeur de la classe **/

  Button(int rectX, int rectY) {
    this.rectX=rectX;
    this.rectY=rectY;
  }

  /** Met a jour l'apparence du bouton **/

  void update() {
    if (overRect(rectX, rectY, longueur, largeur) ) {
      rectOver = true;
    } else {
      rectOver=false;
    }
  }

  /** Indique si la souris est au dessus du bouton **/

  boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width &&
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  /** Dessine le bouton lorsque la méthode est appelée a chaque frame **/

  void dessin() {
    if (rectOver) {
      fill(rectHighlight);
    } else {
      fill(rectColor);
    }
    stroke(153);
    rect(rectX, rectY, longueur, largeur);
    fill(255);
    textFont(sousTitre);
    text("Launch Simulation", rectX +20, rectY + 41);
  }

  /** Verifie et compte le nombre de fois ou l'utilisateur clique sur le bouton, afin de ne lancer la simulation qu'une fois **/

  void testSouris() {
    if (rectOver) {
      //currentColor = rectColor;
      boutonAppuye=true;
      click+=1;
    }
  }
}
