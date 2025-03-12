// game Code:

Rocket r1; 
Asteroid[] a; 
Photon[] photons; 
int numAsteroids; 
int maxShots = 5; 
int photonIndex = 0; 
long photonTime = 0; 
//Scores
String playerName = "Player1";
int level = 1; 
int levelframeCount = 0; // Frame-Zähler für den Level
int score = 0; 
int asteroidsKilled;


int lives = 3;
int asteroidsRemaining;
int roundFrames = 0; // Zählt die Frames pro Runde
String ticker ="";

void setupGame() { 
  r1 = new Rocket(width / 2, height / 2, 0, 100); 
  photons = new Photon[maxShots]; 
  for (int i = 0; i < maxShots; i++) { 
    photons[i] = new Photon();
  } 
  startNewLevel();
}

void startNewLevel() { 
  numAsteroids = 5 + level; 
  asteroidsRemaining = numAsteroids; 
  a = new Asteroid[numAsteroids]; 
  for (int i = 0; i < numAsteroids; i++) { 
    a[i] = new Asteroid();
  }
}
boolean hit = false;
void checkCollisions() { 
  for (int i = 0; i < maxShots; i++) { 
    if (photons[i].active) { 
      for (int j = 0; j < numAsteroids; j++) { 
        if (a[j] != null && dist(photons[i].xPos, photons[i].yPos, a[j].xPos, a[j].yPos) < 20) { 
          photons[i].active = false; 
          a[j].health -= 10;
          if (a[j].health <= 0) {
            a[j] = null;
            hit = true;
            score += 10; 
            asteroidsRemaining--; 
            if (asteroidsRemaining <= 0) { 
              roundFrames = 0;
              // levelframeCount = 0;
              r1.xPos = width/2;
              r1.yPos = height/2;
              r1.rotation =0;
              r1.velocityX = 0;
              r1.velocityY = 0;
              generation++;
              level++; 
              startNewLevel();
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < numAsteroids; i++) { 
    if (a[i] != null && dist(r1.xPos, r1.yPos, a[i].xPos, a[i].yPos) < 40) { 
      r1.health = 0;
      lives--; 
    
      roundFrames = 0;
      generation++;

      epsilon *= 0.99; // Langsam reduzieren
      epsilon = max(epsilon, 0.01); // Aber nicht unter 1% fallen lassen
      if (lives <= 0) { 
        addScore();    
        printScores(); 
        score = 0; 
        lives = 3; 
        level = 1; 
        levelframeCount = 0;
        startNewLevel();
      } 
      r1 = new Rocket(width / 2, height / 2, 0, 0);
    }
  }
}

void drawHUD() { 
  fill(255); 
  textSize(40); 
  textAlign(LEFT, TOP); 
  text("Level: " + level, 10, 10); 
  textAlign(CENTER, TOP); 
  text("Score: " + score, width / 2, 10); 
  textAlign(RIGHT, TOP); 
  text("Lives: " + lives, width - 10, 10);
  //text("Ticker: " + ticker, width - 10, 60);
  // Zeit in Sekunden berechnen und anzeigen
  float timeElapsed = levelframeCount / frameRate;
  text("Time: " + floor(timeElapsed) + "s", width/2, 60);
  // Timer hochzählen
  levelframeCount++;
}

void updateGame() {
  roundFrames++; // Jede Frame-Iteration erhöht den Zähler

  if (asteroidsRemaining == 0 || lives < 1) {  
    resetRound();
  }
}

void resetRound() {
  text("Runde beendet. Frames: " + roundFrames, width/2, height/2);

  roundFrames = 0; // Zähler zurücksetzen
  // startNewRound();
}
void drawGame() { 

  r1.drawMe(); 
  for (int i = 0; i < maxShots; i++) { 
    if (photons[i].active) { 
      photons[i].move(); 
      photons[i].drawMe();
    }
  } 
  for (int i = 0; i < numAsteroids; i++) { 
    if (a[i] != null) { 
      a[i].drawMe();
    }
  } 
  checkCollisions(); 
  drawHUD();
}

class Asteroid { 
  float rotation; 
  float xPos, yPos; 
  float velocityX, velocityY;
  int numVertices;
  float[] radii;
  int health;

  Asteroid() {
    do {
      xPos = random(0, width);
      yPos = random(0, height);
    } while (dist(xPos, yPos, width / 2, height / 2) < 500); // Abstand checken

    rotation = random(0, TWO_PI);
    velocityX = sin(rotation) * 1;
    velocityY = -cos(rotation) * 1;
    numVertices = int(random(6, 12));
    radii = new float[numVertices];
    health =8 + level;

    for (int i = 0; i < numVertices; i++) {
      radii[i] = random(8, 64);
    }
  }

  void drawMe() { 
    xPos += velocityX; 
    yPos += velocityY; 
    if (xPos > width) xPos -= width; 
    if (xPos < 0) xPos += width; 
    if (yPos > height) yPos -= height; 
    if (yPos < 0) yPos += height; 
    pushMatrix(); 
    translate(xPos, yPos); 
    rotate(rotation); 
    beginShape();
    for (int i = 0; i < numVertices; i++) {
      float angle = map(i, 0, numVertices, 0, TWO_PI);
      float vx = cos(angle) * radii[i];
      float vy = sin(angle) * radii[i];
      vertex(vx, vy);
    }
    endShape(CLOSE); 
    popMatrix();
  }
}


class Rocket { 
  float rotation = 0;  
  float angularVelocity = 0; // NEU: Drehgeschwindigkeit
  float xPos;  
  float yPos;  
  final int halfWidth = 25;  
  final int halfHeight = 25;  
  float velocityX = 0;  
  float velocityY = 0;  
  float speed = 0;
  long lastDrawMillis = 0;
  boolean thrust = false;
  float nearestDistance = width;  
  float angleToNearestAsteroid = 0;  
  float nearestAsteroidVelocity = 0;  
  int health;
  float angle;

  Rocket(float initialX, float initialY, float initialRot, int h) { 
    xPos = initialX; 
    yPos = initialY; 
    rotation = initialRot;
    health = h;
  }

  void drawMe() { 
    angle = (rotation / PI) % 2; 
    if (angle > 1) angle -= 2; // Hält es im Bereich [-1, 1]
    if (angle < -1) angle += 2; // Hält es im Bereich [-1, 1]

    for (Asteroid asteroid : a) {
      if (asteroid == null) continue;  

      float distance = dist(r1.xPos, r1.yPos, asteroid.xPos, asteroid.yPos);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        angleToNearestAsteroid = atan2(asteroid.yPos - r1.yPos, asteroid.xPos - r1.xPos) - radians(r1.rotation);
        nearestAsteroidVelocity = dist(0, 0, asteroid.velocityX, asteroid.velocityY);
      }
    }
    xPos += velocityX; 
    yPos += velocityY; 
    updateSpeed();
    // Bildschirmrand-Wrap
    if (xPos > width) xPos -= width; 
    if (xPos < 0) xPos += width; 
    if (yPos > height) yPos -= height; 
    if (yPos < 0) yPos += height; 

    // Rotation mit Trägheit
    rotation += angularVelocity;
    angularVelocity *= 0.98; // NEU: Dämpfung der Drehgeschwindigkeit

    pushMatrix(); 
    translate(xPos, yPos);  
    rotate(rotation);  
    triangle(0, -halfHeight, -halfWidth, halfHeight, halfWidth, halfHeight);  
    rectMode(CORNERS);  
    if (thrust) {  
      stroke(250, 24, 7);
    }
    thrust = false;

    rect(-halfWidth + 15, halfHeight, -halfWidth + 18, halfHeight + 13);  
    rect(halfWidth - 18, halfHeight, halfWidth - 15, halfHeight + 13);  
    fill(255);   
    //Sensors
    if (showStats) {
      for (int i = 0; i < numSensors; i++) {
        float angleOffset = 360.0 / numSensors * i;
        float sensorDirX = sin(radians(angleOffset));
        float sensorDirY = -cos(radians(angleOffset));

        stroke(255, 255, 0); // Gelbe Linien für die Sensoren
        line(0, 0, 
          0 + sensorDirX * sensorDistances[i], 
          0 + sensorDirY * sensorDistances[i]);
      }
    }

    popMatrix();
  }

  void togglePlayer() {

    learningMode = !learningMode;
  }

  void updateSpeed() {
    speed = sqrt(velocityX * velocityX + velocityY * velocityY);
  }
  float maxRotation = 0.1;
  void rotateClockwise() { 
    if (abs(angularVelocity) < maxRotation) {
      angularVelocity += 0.01; // NEU: Sanfte Drehung gegen Uhrzeigersinn
    }
  }

  void rotateCounterclockwise() { 
    if (abs(angularVelocity) < maxRotation) {
      angularVelocity -= 0.01; // NEU: Sanfte Drehung gegen Uhrzeigersinn
    }
  }

  void fireThrusters() { 
    thrust = true;
    float maxSpeed = 10; // Maximale Geschwindigkeit
    velocityX += sin(rotation) * 0.4; 
    velocityY -= cos(rotation) * 0.4;

    // Geschwindigkeit begrenzen
    float speed = sqrt(velocityX * velocityX + velocityY * velocityY);
    if (speed > maxSpeed) {
      velocityX = (velocityX / speed) * maxSpeed;
      velocityY = (velocityY / speed) * maxSpeed;
    }
  }
}

class Photon { 
  boolean active; 
  float xPos, yPos; 
  float deltaX, deltaY; 
  long activationTime; // Zeitpunkt der Aktivierung speichern

  void activate(float shipX, float shipY, float shipRotation) { 
    active = true; 
    xPos = shipX; 
    yPos = shipY; 
    deltaX = 20 * -sin(shipRotation); 
    deltaY = 20 * cos(shipRotation);
    activationTime = millis(); // Zeitstempel setzen
  }

  void move() { 
    if (millis() - activationTime > 2000) { // Nach 2 Sekunden deaktivieren
      active = false;
      return;
    }
    
    xPos -= deltaX; 
    yPos -= deltaY; 
    if (xPos > width) xPos = 0; 
    if (xPos < 0) xPos = width; 
    if (yPos > height) yPos = 0; 
    if (yPos < 0) yPos = height;
  }

  void drawMe() { 
    if (!active) return;
    stroke(255); 
    line(xPos, yPos, xPos + deltaX, yPos + deltaY);
  }
}
//game code Ende.
