//neuronales Netz:

int inputNodes = numInputs; 
int generations =0;
float[] hiddenLayer; 

import java.util.Arrays;
float weightLimit = 1.0f; // Begrenzung der Gewichte


// Zufällige Gewichte initialisieren
void randomizeWeights(float[][] weights) { 
  for (int i = 0; i < weights.length; i++) { 
    for (int j = 0; j < weights[i].length; j++) { 
      weights[i][j] = random(-1, 1);
    }
  }
}


void clipWeights(float[][] weights) {
  for (int i = 0; i < weights.length; i++) {
    for (int j = 0; j < weights[i].length; j++) {
      weights[i][j] *= 0.999; // Sanfterer Dämpfungsfaktor
      weights[i][j] = constrain(weights[i][j], -0.5, 0.5);
    }
  }
}

// Feedforward mit mehreren Hidden-Layern
void feedForward(float[] inputs) { 

  // Erste Hidden-Layer berechnen
  for (int i = 0; i < hiddenNodes; i++) {
    float sum = 0;
    for (int j = 0; j < numInputs; j++) {
      sum += inputs[j] * weightsInputHidden[j][i];
    }
    hiddenLayers.get(0)[i] = leakyReLU(sum);
  }

  // Verbleibende Hidden-Layer berechnen
  for (int layer = 1; layer < networkDepth; layer++) {
    for (int i = 0; i < hiddenNodes; i++) {
      float sum = 0;
      for (int j = 0; j < hiddenNodes; j++) {
        sum += hiddenLayers.get(layer - 1)[j] * weightsHidden[layer - 1][j][i];
      }
      hiddenLayers.get(layer)[i] = leakyReLU(sum);
    }
  }

  // Ausgabe-Layer berechnen
  for (int i = 0; i < outputNodes; i++) { 
    float sum = 0;
    for (int j = 0; j < hiddenNodes; j++) { 
      sum += hiddenLayers.get(networkDepth - 1)[j] * weightsHiddenOutput[j][i];
    }
    outputLayer[i] = leakyReLU(sum);
  }
}
/*
float sigmoid(float x) { 
    return 1.0f / (1.0f + exp(-max(-10, min(10, x))));
}*/

float leakyReLU(float x) { 
    return x > 0 ? x : 0.01 * x;
}

void visualize(float[] inputs) {

  if (showStats) {
    float xSpacing = width /1.2/ (networkDepth + 2); // Abstand zwischen den Schichten
    float ySpacing = (height /2-50)/ (max(inputNodes, hiddenNodes, outputNodes) + 1); // Abstand zwischen den Neuronen
    float yOffset = height / 20;
    textSize(23);

    // Eingabeschicht zeichnen

    for (int i = 0; i < inputNodes; i++) {
      float x = xSpacing;
      float y = yOffset + ySpacing * (i + 1);
      fill(255);
      ellipse(x, y, 40, 40);
      fill(200);
      text(nf(inputs[i], 1, 2), x, y);
    }

    // Versteckte Schichten zeichnen

    for (int layer = 0; layer < networkDepth; layer++) {
      for (int i = 0; i < hiddenNodes; i++) {
        float x = xSpacing * (layer + 2);
        float y = yOffset + ySpacing * (i + 1);
        fill(100, 255, 100);
        ellipse(x, y, 40, 40);
        fill(200);
        float value = (hiddenLayers.get(layer) != null) ? hiddenLayers.get(layer)[i] : 0;
        text(nf(value, 1, 2), x, y);

        // Verbindungen zur vorherigen Schicht zeichnen

        if (layer == 0) {
          // Verbindung von Eingabeschicht zur ersten versteckten Schicht
          for (int j = 0; j < inputNodes; j++) {
            float prevX = xSpacing;
            float prevY = yOffset + ySpacing * (j + 1);
            stroke(255);
            line(prevX, prevY, x, y);
            fill(255);
            text(nf(weightsInputHidden[j][i], 1, 2), (prevX + x) / 2, (prevY + y) / 2);
          }
        } else {

          // Verbindung zwischen versteckten Schichten
          for (int j = 0; j < hiddenNodes; j++) {
            float prevX = xSpacing * (layer + 1);
            float prevY = yOffset + ySpacing * (j + 1);
            stroke(255);
            line(prevX, prevY, x, y);
            fill(255);
            text(nf(weightsHidden[layer - 1][j][i], 1, 2), (prevX + x) / 2, (prevY + y) / 2);
          }
        }
      }
    }

    // Ausgabeschicht zeichnen
    for (int i = 0; i < outputNodes; i++) {
      float x = xSpacing * (networkDepth + 2);
      float y = yOffset + ySpacing * (i + 1);
      fill(outputLayer[i] <= 0.51 ? 220 : 128);
      ellipse(x, y, 40, 40);
      fill(0);
      text(nf(outputLayer[i], 1, 2), x, y);

      // Verbindungen von der letzten versteckten Schicht zur Ausgabeschicht zeichnen
      for (int j = 0; j < hiddenNodes; j++) {
        float prevX = xSpacing * (networkDepth + 1);
        float prevY = yOffset + ySpacing * (j + 1);
        stroke(255);
        line(prevX, prevY, x, y);
        fill(255);
        text(nf(weightsHiddenOutput[j][i], 1, 2), (prevX + x) / 2, (prevY + y) / 2);
      }
    }
    // Stats nur anzeigen, wenn showStats aktiv ist

    // Tabelle zeichnen
    text("learning Rate: "+ alpha+" | Epsylon: "+epsilon, width/1.2+10, height/2+30);

    int y = 50;
    for (int i = scoreList.size() - 1; i >= 0; i--) { // Rückwärts durch die Liste
      text(scoreList.get(i), width/1.2+10, height/2+30 + y);
      y += 20;
    }
  }
}

// ** Reinforcement Learning Mechanik **

void train(float[] inputs) {

  //debug
  if (inputs == null || inputs.length < numInputs) {
    println("Fehler: inputs-Array ist nicht richtig initialisiert!");
    return;
  }
  if (hiddenLayers == null || hiddenLayers.size() < networkDepth || 
    weightsHidden == null || weightsHiddenOutput == null || 
    weightsInputHidden == null) {
    println("Fehler: Netzwerkstruktur ist unvollständig initialisiert!");
    return;
  }

  for (int i = 0; i < weightsHidden.length; i++) {
    if (weightsHidden[i] == null) {
      println("Fehler: weightsHidden[" + i + "] ist NULL!");
      return;
    }
    for (int j = 0; j < weightsHidden[i].length; j++) {
      if (weightsHidden[i][j] == null) {
        println("Fehler: weightsHidden[" + i + "][" + j + "] ist NULL!");
        weightsHidden[i][j] = new float[hiddenNodes]; // Notfallinitialisierung
      }
    }
  }

  for (int i = 0; i < hiddenLayers.size(); i++) {
    if (hiddenLayers.get(i) == null) {
      println("Fehler: hiddenLayers[" + i + "] ist NULL!");
      return;
    }
  }

  if (outputLayer == null) {
    println("Fehler: outputLayer ist NULL!");
    return;
  }

  //Falls alle Prüfungen bestanden wurden, kann das Training hier weitergehen.
  //println("Training beginnt...");
  //Gewichte zwischen Input und erster Hidden-Schicht NICHT aktualisieren

  updateInputs();
  // Gewichte zwischen Input und erster Hidden-Schicht NICHT aktualisieren

  feedForward(inputs);

  int action = (random(1) < epsilon) ? int(random(4)) : maxAction();

  switch (action) {
  case 0: 
    r1.fireThrusters(); 
    break;
  case 1: 
    r1.rotateCounterclockwise(); 
    break;
  case 2: 
    r1.rotateClockwise(); 
    break;
  case 3: 
    if (millis() - photonTime > 200) {
      photonTime = millis();
      photons[photonIndex].activate(r1.xPos, r1.yPos, r1.rotation);
      photonIndex = (photonIndex + 1) % maxShots;
    }
    break;
  }

  float reward = calculateReward();

  if (abs(r1.angularVelocity) > 0.05) reward -= 0.1; // Leichte Strafe für dauerhafte Drehung
  if (abs(r1.angleToNearestAsteroid) < radians(15)) reward += 0.5; // Belohnung für gute Ausrichtung


  float[] outputError = new float[outputNodes];

  for (int i = 0; i < outputNodes; i++) {
    float target = (i == action) ? (reward + gamma * maxQValue()) : outputLayer[i];
    outputError[i] = constrain(target - outputLayer[i], -2.0, 2.0);
  }

  if (weightsHiddenOutput == null) {
    println("Fehler: weightsHiddenOutput ist NULL!");
    return;
  }

  for (int i = 0; i < weightsHiddenOutput.length; i++) {
    if (weightsHiddenOutput[i] == null) {
      println("Fehler: weightsHiddenOutput[" + i + "] ist NULL!");
      return;
    }
  }

  if (hiddenLayers == null) {
    println("Fehler: hiddenLayer ist NULL!");
    return;
  }

  float[][] hiddenErrors = new float[hiddenLayers.size()][];

  // Fehler für die letzte versteckte Schicht (vor der Output-Schicht)
  hiddenErrors[hiddenLayers.size() - 1] = new float[hiddenLayers.get(hiddenLayers.size() - 1).length];

  for (int i = 0; i < hiddenLayers.get(hiddenLayers.size() - 1).length; i++) {
    float sum = 0;
    for (int j = 0; j < outputNodes; j++) {
      sum += outputError[j] * weightsHiddenOutput[i][j]; // Fehler von Output-Layer rückf��������hren
    }
   // hiddenErrors[hiddenLayers.size() - 1][i] = sum * hiddenLayers.get(hiddenLayers.size() - 1)[i] * (1 - hiddenLayers.get(hiddenLayers.size() - 1)[i]); // Sigmoid-Ableitung
 hiddenErrors[hiddenLayers.size() - 1][i] = sum * (hiddenLayers.get(hiddenLayers.size() - 1)[i] > 0 ? 1 : 0.01); // KORREKT für Leaky ReLU
  }

  for (int layer = hiddenLayers.size() - 2; layer >= 0; layer--) { // Rückwärts durch die Schichten
    hiddenErrors[layer] = new float[hiddenLayers.get(layer).length];

    for (int i = 0; i < hiddenLayers.get(layer).length; i++) {
      float sum = 0;
      for (int j = 0; j < hiddenLayers.get(layer + 1).length; j++) {
        sum += hiddenErrors[layer + 1][j] * weightsHidden[layer][j][i];
      }
      hiddenErrors[layer][i] = sum * (hiddenLayers.get(layer)[i] > 0 ? 1 : 0.01); // Ableitung von Leaky ReLU
    }
  }

  for (int i = 0; i < hiddenLayers.get(hiddenLayers.size() - 1).length; i++) {
    for (int j = 0; j < outputNodes; j++) {
      weightsHiddenOutput[i][j] += alpha * outputError[j] * hiddenLayers.get(hiddenLayers.size() - 1)[i];
    }
  }
  for (int layer = hiddenLayers.size() - 1; layer > 0; layer--) {
    for (int i = 0; i < hiddenLayers.get(layer - 1).length; i++) {
      for (int j = 0; j < hiddenLayers.get(layer).length; j++) {
        weightsHidden[layer - 1][i][j] += alpha * hiddenErrors[layer][j] * hiddenLayers.get(layer - 1)[i];
      }
    }
  }

  for (int i = 0; i < numInputs; i++) {
    for (int j = 0; j < hiddenLayers.get(0).length; j++) {
      weightsInputHidden[i][j] += alpha * hiddenErrors[0][j] * inputs[i];
    }
  }

  // **Gewichte begrenzen, damit sie nicht explodieren**
  clipWeights(weightsInputHidden);
  clipWeights(weightsHiddenOutput);
}

int previousLives = lives;

// Berechnet die Belohnung für die aktuelle Aktion
float calculateReward() {
  float reward = 1; // Standard-Belohnung für eine neutrale Aktion

  // Bonus für schnelle Level-Abschlüsse
  if (levelframeCount < 1200&&asteroidsRemaining == 0) {
    reward += 100;
    println("100 Bonus für schnelle Level-Abschlüsse");
    ticker ="100 Bonus für schnelle Level-Abschlüsse";
  }

  // Belohnung für das Abschließen eines Levels
  if (asteroidsRemaining == 0) {
    ticker="100 Belohnung für das Abschließen eines Levels";
    println((100*lives*level)+"Belohnung für das Abschließen eines Levels");
    return reward + 100*lives*level;
    
  }
if (hit&& levelframeCount< 600) {  
      reward += 50; // Belohnung für das Zerstören eines Asteroiden
      hit=false;
      println("Belohnung für das Zerstören eines Asteroiden");
      ticker = "50 Belohnung für schnelles Zerstören eines Asteroiden";
   }
  //for (Asteroid asteroid : a) {
    if (hit) {  
      reward += 10; // Belohnung für das Zerstören eines Asteroiden
      hit=false;
      println("Belohnung für das Zerstören eines Asteroiden");
      ticker = "10 Belohnung für das Zerstören eines Asteroiden";
   }
   // }
  

  // Bestrafung für Leben verlieren
  if (r1.health==0) {  
    println("Treffer eines Asteroiden. Leben verloren! -99 Bestrafung angewendet.");
    ticker ="-99 Treffer eines Asteroiden. Leben verloren! Bestrafung angewendet.";
    reward -= 99;  
    r1.health =100;
    previousLives = lives; // **Fix: previousLives wird korrekt gesetzt**
  }

  // Strafe für Game Over
  if (lives <1&&r1.health==0) {
    println("-99 Strafe für Game Over");
    ticker = "-99 Strafe für Game Over";
    return -99;
    
  }
  
  
  if (abs(r1.angleToNearestAsteroid) < radians(10)) reward += 1.5;
  reward += 0.01 * (r1.speed / 10); // Belohnt konstante Bewegung
  if (abs(r1.angularVelocity) > 0.1) reward -= 0.05;
  for (int i = 0; i < numAsteroids; i++) { 
  if (a[i] == null) continue ;
    
  float nDist = dist(r1.xPos, r1.yPos, a[i].xPos, a[i].yPos);
  
    if (a[i] != null && nDist < 40) { 
      //lineare Belohnung für Ausweichen
      reward += map(nDist, 0, maxVisionDistance, -50, 10);
      //eponenzielle Belohnung Distanz zu Asteroiden
      
      reward -= exp(-nDist / 100) * 50;
    }
  }
  //strafe für stehenbleiben
  if (r1.speed < 1) reward -= 5;
  return reward;
}

// Gibt den höchsten Q-Wert zurück
float maxQValue() {
  float maxQ = outputLayer[0];
  for (int i = 1; i < outputNodes; i++) {
    if (outputLayer[i] > maxQ) maxQ = outputLayer[i];
  }
  return maxQ;
}

// Wählt die beste Aktion basierend auf den Q-Werten
int maxAction() {
  int bestAction = 0;
  for (int i = 1; i < outputNodes; i++) {
    if (outputLayer[i] > outputLayer[bestAction]) {
      bestAction = i;
    }
  }
  return bestAction;
}

void aktivator() {
  text("Lernmodus: " + (learningMode ? "Aktiviert" : "Deaktiviert") + " | Generation: " + generation, 350, 100);
text("Ticker: " + ticker, width - 10, 100);
  if (learningMode == true) {
    train(inputs);
  };
}

float[] sensorDistances = new float[numSensors]; // Speichert die gemessenen Distanzen
float maxVisionDistance = 3000;

void updateInputs() {
  float angle = r1.angle * 180; // Von -180 bis 180

  if (angle < 0) angle += 360; // In den Bereich [0,360] bringen

  //sense Photons avtive
  int phoNum = 0;
  for (int i = 0; i < maxShots; i++) { 
    if (photons[i].active) { 
      phoNum += 1;
    }
  }

  //sense position, angle, speed
  inputs[0] = r1.angle;  
  inputs[1] = r1.xPos / width;  
  inputs[2] = r1.yPos / height;  
  inputs[3] = phoNum / (float)maxShots;  
  inputs[4] = r1.speed / 10;  

  pushMatrix();
  translate(r1.xPos, r1.yPos);
  rotate(r1.rotation);

  popMatrix();
  for (int i = 0; i < numSensors; i++) {
    float angleOffset = 360.0 / numSensors * i; // Winkel gleichmäßig verteilen
    float sensorDirX = sin(radians(angle + angleOffset));
    float sensorDirY = -cos(radians(angle + angleOffset));
    sensorDistances[i] = maxVisionDistance; // Standardwert

    for (Asteroid asteroid : a) {
      if (asteroid == null) continue;

      float toAsteroidX = asteroid.xPos - r1.xPos;
      float toAsteroidY = asteroid.yPos - r1.yPos;

      float projection = (toAsteroidX * sensorDirX + toAsteroidY * sensorDirY);
      float perpendicular = abs(toAsteroidX * sensorDirY - toAsteroidY * sensorDirX);

      if (projection > 0 && perpendicular < asteroid.numVertices * 6) { 
        sensorDistances[i] = min(sensorDistances[i], projection);
      }
    }
  }

  for (int i = 0; i < numSensors; i++) {
    inputs[i+numStatIn] = sensorDistances[i]/ maxVisionDistance;
  }

}

// Neural Network Ende
