// Astroids with Neural network Code;
float screenW, screenH; 
boolean learningMode = false; // Umschaltung zwischen Spieler & KI
boolean showStats = false;

float alpha = 0.1; // Lernrate
float gamma = 0.9; // Zukunftsgewichtung
float epsilon = 0.03; // Explorationsrate

int numStatIn = 5;
int numSensors = 16;
int networkDepth = 3; // Anzahl der versteckten Schichten
int numInputs = numStatIn+numSensors; // Anzahl der Eingangsneuronen

float[] inputs = new float[numInputs];
int hiddenNodes = 12; // Neuronen pro versteckter Schicht
int outputNodes = 4; // Anzahl der Ausgangsneuronen

float[][][] weightsHidden; // Gewichte zwischen den Hidden-Layern
float[][] weightsInputHidden; // Gewichte von Eingabe zu erster Hidden-Layer
float[][] weightsHiddenOutput; // Gewichte von letzter Hidden-Layer zu Ausgabe

int generation = 0;
ArrayList<float[]> hiddenLayers = new ArrayList<float[]>();
float[] outputLayer; 

void setup() { 
  fullScreen();
  for (int i = 0; i < numInputs; i++) {
    inputs[i] = random(1);
  }

  screenW = width; 
  screenH = height;
  setupGame();

  // Verhindert NullPointerException  
  if (hiddenLayers == null) hiddenLayers = new ArrayList<float[]>();
  else hiddenLayers.clear();

  for (int i = 0; i < networkDepth; i++) {
    
    hiddenLayers.add(new float[hiddenNodes]);
    Arrays.fill(hiddenLayers.get(i), random(-1, 1)); // Setzt Werte auf 0, um sicherzugehen
  }

  if (outputLayer == null) outputLayer = new float[outputNodes];
  Arrays.fill(outputLayer, 0);

  if (weightsInputHidden == null) weightsInputHidden = new float[numInputs][hiddenNodes];
  if (weightsHidden == null) weightsHidden = new float[networkDepth - 1][hiddenNodes][hiddenNodes]; 
  if (weightsHiddenOutput == null) weightsHiddenOutput = new float[hiddenNodes][outputNodes];

  // Gewichte setzen
  randomizeWeights(weightsInputHidden);
  for (int i = 0; i < networkDepth - 1; i++) {
    randomizeWeights(weightsHidden[i]);
  }
  randomizeWeights(weightsHiddenOutput);
  
  //Debugging 
  println("Debug: hiddenLayers.size() = " + hiddenLayers.size());
for (int i = 0; i < hiddenLayers.size(); i++) {
  println("Debug: hiddenLayers[" + i + "] = " + Arrays.toString(hiddenLayers.get(i)));
}
  println("Debug: weightsHidden.length = " + (weightsHidden != null ? weightsHidden.length : "null"));
  if (weightsHidden != null) {
    for (int i = 0; i < weightsHidden.length; i++) {
      println("Debug: weightsHidden[" + i + "].length = " + weightsHidden[i].length);
    }
  }
  println("Debug: weightsInputHidden = " + (weightsInputHidden != null ? "OK" : "NULL"));
  println("Debug: weightsHidden = " + (weightsHidden != null ? "OK" : "NULL"));
  println("Debug: weightsHiddenOutput = " + (weightsHiddenOutput != null ? "OK" : "NULL"));

  if (weightsHidden != null) {
    println("Debug: weightsHidden.length = " + weightsHidden.length);
    for (int i = 0; i < weightsHidden.length; i++) {
      println("Debug: weightsHidden[" + i + "].length = " + (weightsHidden[i] != null ? weightsHidden[i].length : "NULL"));
    }
  }
}
void draw() { 
  background(40); 
  frameRate(60);
  fill(255); 
  textSize(32); 
  textAlign(CENTER, CENTER); 
  //text(photonIndex, screenW / 2, screenH / 2);
  drawGame();
  drawControls();
  aktivator();
  feedForward(inputs); 
  visualize(inputs);
}
