// User Interface Code:
float btnW = 6.6;
float btnM = 1.9;
boolean firePressed = false;
boolean fireLocked = false;
boolean upPressed = false;
boolean upLocked = false;
boolean downPressed = false;
boolean downLocked = false;
void drawControls() { 

  float btnSize = screenW / btnW;
  float margin = btnSize / btnM;

  // Steuerkreuz 
  float dpadX = margin; 
  float dpadY = screenH - 3 * btnSize - margin;

  drawButton(dpadX + btnSize, dpadY, "UP"); 
  drawButton(dpadX, dpadY + btnSize, "LEFT"); 
  drawButton(dpadX + 2 * btnSize, dpadY + btnSize, "RIGHT"); 
  drawButton(dpadX + btnSize, dpadY + 2 * btnSize, "DOWN");

  // Action-Knöpfe 
  float actionX = screenW - 2 * btnSize - margin; 
  float actionY = screenH - 2 * btnSize - margin;

  drawButton(actionX, actionY, "A"); 
  drawButton(actionX + btnSize, actionY + btnSize, "B");

  // Touch Eventlistener. Steuerung des Spielers basierend auf den Touch-Positionen

  for (int i = 0; i < touches.length; i++) {
    if (touchingThrust(i)) {
      r1.fireThrusters();
    } 
    if (touchingLeft(i)) {
      r1.rotateCounterclockwise();
    }
    if (touchingRight(i)) {
      r1.rotateClockwise();
    }

    // Hoch (mit Lock)
    if (touchingUp(i)) {
      if (!upLocked) { 
        upPressed = true;
        upLocked = true; 
        r1.togglePlayer();
      }
    }

    // Runter (mit Lock)
    if (touchingDown(i)) {
      if (!downLocked) { 
        downPressed = true;
        downLocked = true; 
        showStats = !showStats;
      }
    }

    // Schießen (mit Lock)
    if (touchingFire(i)) {
      if (!fireLocked) { 
        firePressed = true;
        fireLocked = true; 
        fireShot();
      }
    }
  }


  // Falls kein Finger mehr den jeweiligen Knopf berührt, wird der Lock gelöst
  if (touches.length == 0) {
    fireLocked = false;
    upLocked = false;
    downLocked = false;
  }
}
void fireShot() {
  if (millis() - photonTime > 200) {
    photonTime = millis();
    photons[photonIndex].activate(r1.xPos, r1.yPos, r1.rotation);
    photonIndex++;
    if (photonIndex >= maxShots) {
      photonIndex = 0;
    }
  }
}
void drawButton(float x, float y, String label) { 

  float btnSize = screenW / btnW;

  fill(150, 150, 150, 150); 
  ellipse(x + btnSize / 2, y + btnSize / 2, btnSize, btnSize); 
  fill(255); 
  textSize(20); 
  text(label, x + btnSize / 2, y + btnSize / 2);
}

boolean touchingThrust(int i) {

  float x = touches[i].x;
  float y = touches[i].y;
  float btnSize = screenW / btnW;
  float margin = btnSize / btnM; 
  float actionX = screenW - 2 * btnSize - margin; 
  float actionY = screenH - 2 * btnSize - margin;

  return (dist(x, y, actionX + 0.5 * btnSize, actionY + 0.5 * btnSize)< btnSize / 2);
}

boolean touchingLeft(int i) {
  float x = touches[i].x;
  float y = touches[i].y;
  float btnSize = screenW / btnW;
  float margin = btnSize / btnM; 
  float dpadX = margin; 
  float dpadY = screenH - 3 * btnSize - margin; 

  return (dist(x, y, dpadX + 0.5 * btnSize, dpadY + 1.5 * btnSize) < btnSize / 2);
}

boolean touchingRight(int i) {
  float x = touches[i].x;
  float y = touches[i].y;
  float btnSize = screenW / btnW;
  float margin = btnSize / btnM; 
  float dpadX = margin; 
  float dpadY = screenH - 3 * btnSize - margin; 

  return (
    dist(x, y, dpadX + 2.5 * btnSize, dpadY + 1.5 * btnSize) < btnSize / 2

    );
}
boolean touchingUp(int i) {
  float x = touches[i].x;
  float y = touches[i].y;

  float btnSize = screenW / btnW;
  float margin = btnSize / btnM;
  float dpadX = margin;
  float dpadY = screenH - 3 * btnSize - margin;

  return (dist(x, y, dpadX + 1.5 * btnSize, dpadY + 0.5 * btnSize) < btnSize / 2);
}
boolean touchingDown(int i) {
  float x = touches[i].x;
  float y = touches[i].y;

  float btnSize = screenW / btnW;
  float margin = btnSize / btnM;
  float dpadX = margin;
  float dpadY = screenH - 3 * btnSize - margin;

  return (dist(x, y, dpadX + 1.5 * btnSize, dpadY + 2.5 * btnSize) < btnSize / 2);
}
boolean touchingFire(int i) {
  float x = touches[i].x;
  float y = touches[i].y;

  float btnSize = screenW / btnW;
  float margin = btnSize / btnM; 
  float actionX = screenW - 2 * btnSize - margin; 
  float actionY = screenH - 2 * btnSize - margin;

  return ( dist(x, y, actionX + 1.5 * btnSize, actionY + 1.5 * btnSize) < btnSize / 2);
}

// User Interface Code Ende.
