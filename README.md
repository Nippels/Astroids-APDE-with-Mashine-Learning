# 🚀 Asteroids AI – A Neural Network for Asteroids

## **Description**

This project implements an Asteroids game with an AI controlled by a neural network. The player can switch between manual mode and AI-controlled mode. The AI uses reinforcement learning to optimize its control.
The Code is written in Processing - which is basicly a Java Library - on my Android phone, with the APDE app. I have no Idea of Neural Networks. The Code is far from optimal, but runs quite decently!

![Game Screenshot](images/Screenshot_1.jpg)
*Gameplay with AI learning enabled.*

![Neural Network Visualization](images/Screenshot_2.jpg)
*Neural network processing sensor data in real-time.*

## **Features**

- **Neural network** with a flexible architecture (input, hidden, and output layers).
- **Reinforcement learning mechanism** with adjustable learning rate, future weighting, and exploration rate.
- **Multiple sensors** to detect obstacles and movement.
- **Statistics & visualizations** to track learning progress.
- **Customizable network structure** for experimenting with different AI approaches.
- Code and Game written in German.

## **Installation & Requirements**

### Prerequisites:

- [Processing IDE](https://processing.org/download) (Java-based development environment)
- [APDE (Android Processing Development Environment)](https://github.com/Calsign/APDE) if running on Android
- Standard libraries for vectors and arrays

### Installation:

1. **Install Processing** (or APDE for Android)
2. **Download and open the project files**
3. **Start the game** by running `GameCode.pde`

## **Usage**

1. **Select game mode with Arrow Up Button**:
   - `Lernmodus: Aktiviert` → Player controls the spaceship
   - `Lernmodus: Deaktiviert` → AI takes over control
2. **Adjust parameters in Code** (learning rate, neural layers, sensor data, etc.)
3. **Toggle Neural Net View on and of with Arrow Down Button**
4. **Start the game** and observe how the AI improves 🚀

## **Porting to PC**

This game is originally developed for Android using APDE but can easily be ported to PC by replacing **touch input commands** with **keyboard controls** in `GameCode.pde`.

## **License**

This project is licensed under the MIT License. Free to use, modify, and distribute.

---

Have fun experimenting with AI-powered spaceships! 🚀😃
