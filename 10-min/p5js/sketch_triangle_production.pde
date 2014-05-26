/**
 * Représentation interactive d'un ‹Project Management Triangle› avec Processing.
 * cf. https://github.com/gongfuio/Girafe/blob/master/sketch_triangle_production/README.md
 */
float offsetX, offsetY;
PVector s1, s2, s3; 
PFont fontForAxis;
Scenarios scenarios;
PVector scenario, actual, direction;
float vitesse;
boolean freezed;

// Affiche un triangle dans l'espace 3D sur les trois sommets s1, s2 et s3,
// ces derniers étant des tuples contenant des coordonnées ‹x;y;z› */
void triangle3D( PVector sommet1, PVector sommet2, PVector sommet3) {
  beginShape();
  vertex( sommet1.x, sommet1.y, sommet1.z);
  vertex( sommet2.x, sommet2.y, sommet2.z);
  vertex( sommet3.x, sommet3.y, sommet3.z);
  endShape( CLOSE);
}

// Affiche un jeu d'axes correspondant aux 3 contraintes
// sur les axes X, -Y et Z du système de coordonnées,
// ainsi que les libellés des contraintes
void drawAxis() {
  PVector axisConstraintGood = new PVector( width/3 + 11.0, 0, 0);
  PVector axisConstraintCheap = new PVector( 0, -height/3 - 11.0, 0);
  PVector axisConstraintFast = new PVector( 0, 0, width/3 + 11.0);
  PVector origin = new PVector( 0, 0, 0);
  pushMatrix();
  noFill();
  stroke( 32, 224, 32, 128);  // Rouge, 50% opacité
  strokeWeight( 2); 
  triangle3D( origin, axisConstraintCheap, axisConstraintFast);
  triangle3D( origin, axisConstraintCheap, axisConstraintGood);
  triangle3D( origin, axisConstraintFast, axisConstraintGood);
  textFont( fontForAxis);
  fill( 255);
  text( "Good", axisConstraintGood.x + 20.0, axisConstraintGood.y, axisConstraintGood.z);
  text( "Cheap", axisConstraintCheap.x, axisConstraintCheap.y - 20.0, axisConstraintCheap.z);
  text( "Fast", axisConstraintFast.x, axisConstraintFast.y, axisConstraintFast.z + 20.0);
  popMatrix();
}

// Affiche un ‹Project Management Triangle› sur trois sommets placés
// sur les axes des contraintes, à une hauteur proportionnelle aux
// valeurs des arguments x, y et z. Ceux-ci doivent contenir une
// valeur entre 0.0 et 1.0.
void drawProdTriangle( PVector scenario) {
  PVector sommetGood = new PVector( map( scenario.x, 0.0, 1.0, 0.0, width/3), 0, 0);
  PVector sommetCheap = new PVector( 0, - map( scenario.y, 0.0, 1.0, 0.0, height/3), 0);
  PVector sommetFast = new PVector( 0, 0, map( scenario.z, 0.0, 1.0, 0.0, width/3));

  pushMatrix();
  stroke( 255, 255, 255, 255); // Blanc, 100% opacité
  strokeWeight( 8); 
  fill( 192, 192, 192, 35); // Gris clair, 35% opacité
  triangle3D( sommetGood, sommetCheap, sommetFast);
  popMatrix();
}

// Affiche légende sous le triangle de production
void textProdTriangle( String s) {
  fill( 255);  // Rouge, 50% opacité
  textAlign( CENTER);
  textSize( 56);
  text( s, 0, height/3, 0.0);
}

// Initialisation du canevas Processing (espace en 3D)
void setup() {
  size(800, 600, P3D);
  smooth();
  lights();
  fontForAxis = loadFont( "AvenirNextCondensed-Heavy-24.vlw");

  scenarios = new Scenarios();
  actual = new PVector( 0.0, 0.0, 0.0);
  vitesse = 0.05;
  freezed = false;
}

void draw() {
  // Fond rouge foncé, avec 15% transparence
  background( 0, 0, 0);
  textFont( fontForAxis);

  // Déplace origine du système de coordonnées au centre du canevas
  translate( width/2, height/2, 0);
  scale( 0.80);

  // Rotation légère de l'ensemble du tracé, pour le voir en perspective
  pushMatrix(); 
  rotateX( -PI/9);
  rotateY( -PI/6 * millis() / 1000);

  // Mise à jour du dessin pour tendre vers le scénario cible
  if ( freezed) {
    fill( 224, 32, 32);  // Rouge, 50% opacité
    text( "[paused]", width/4, -height/4, 0.0);
  } 
  else {
    scenario = scenarios.getScenario();
    direction = PVector.sub( scenario, actual);
    direction.mult( vitesse);
    actual.add( direction);
  }  

  // Tracé des axes et du triangle de production, en variant position 
  // des sommets X et Y du triangle selon position du pointeur de la souris
  drawAxis();  
  drawProdTriangle( actual);
  popMatrix();
  textProdTriangle( scenarios.getText());
}

void keyReleased() {
  if ( key == TAB) {
    freezed = !freezed;
  } 
  
  if (String.fromCharCode(keyCode) == "M") {
    scenarios.next();
  } 

  if (String.fromCharCode(keyCode) == "N") {
      scenarios.previous();
  }
}

