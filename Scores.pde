// Score-Liste
ArrayList<String> scoreList = new ArrayList<String>();


// Funktion zum Speichern eines neuen Scores in der Liste
void addScore() {
    String newEntry = playerName + ", Level: " + level + ", Time: " + (levelframeCount / frameRate) + "s, " + 
                      "Score: " + score + ", Asteroids: " + asteroidsKilled + ", Generations: " + generation;
    
    scoreList.add(newEntry);
}

// Funktion zum Anzeigen aller gespeicherten Scores
void printScores() {
    println("----- Score List -----");
    for (String entry : scoreList) {
        println(entry);
    }
}

