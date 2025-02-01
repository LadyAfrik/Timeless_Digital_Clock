/*
This program creates a heartbeat-inspired digital clock that displays the current time using animated heart shapes. 
The clock consists of:

A dynamic central heart that represents the current hour, growing and shrinking in sync with time.
A ring of minute hearts that expands and contracts based on the current minute.
A second-hand circle of blue hearts that updates dynamically every second.
A digital time display in bold black font, ensuring easy readability.
A custom background image, making the clock visually appealing.
User interaction: Clicking the canvas toggles between heartbeat animation and static display.

This clock presents time in a non-traditional way by using heartbeats as a metaphor for time passage. 
The program is structured using object-oriented programming (OOP) with a HeartClock class to manage the animations and display logic.

*/

//Global Variables and Setup
HeartClock clock; // An instance of the HeartClock class that controls the animation.
PFont digitalFont; // Stores the font for the digital clock display.
PImage bgImage; // Stores the background image.

void setup() {
  size(800, 600); // Creates an 800x600-pixel canvas.
  colorMode(HSB, 360, 100, 100); //  Uses Hue-Saturation-Brightness for better color control.
  noStroke(); // Removes outlines for a smooth visual effect.

  // Load a bold font for digital clock effect
  digitalFont = createFont("Arial Black", 50, true); // Load bold font

  // Load background image
  bgImage = loadImage("house.jpg"); // Loads a background image from the Processing sketch folder.
  bgImage.resize(width, height); // Resizes the image to fit the canvas.

  clock = new HeartClock(); // Instantiates the HeartClock object.
}

void draw() {
  // Draw the background image
  image(bgImage, 0, 0, width, height); // Displays the background image.

  clock.update(); // Updates the heartbeat animation based on time.
  clock.display(); // Draws the hearts and the digital clock.
}

// Toggle heartbeat mode on mouse click, 
// allows users to toggle between heartbeat animation and static display when clicking the canvas.
void mousePressed() {
  clock.toggleHeartbeatMode();
}

// Class for the Heart-Based Clock
class HeartClock {
  boolean heartbeatMode = true; // Toggles between pulsating animation and static display.
  float baseSize = 50; // Base size of the hearts, dynamically modified based on time.
  float pulseSpeed = 1; // Controls how fast the hearts expand and contract.
  float heartBeat = 0; // Stores the pulsation effect.

  HeartClock() {}

  // Update logic: adjust pulsing speed and sizes
  void update() {
    int h = hour();
    pulseSpeed = map(h, 0, 23, 0.5, 2); // Heartbeats are faster at midday, slower at night.
    heartBeat += pulseSpeed; // Simulates a pulsating heart effect.
  }

  // Display the animated hearts. It retrieves the current hour, minute, and second.
  void display() {
    int h = hour();
    int m = minute();
    int s = second();

    float pulse = sin(radians(heartBeat)) * 10; // Pulsing effect
    float hourSize = baseSize + h * 10 + pulse; // Changes based on hour + pulse effect.
    float minuteSize = baseSize + m + pulse / 2; // Changes based on minute + small pulse.
    float secondSize = baseSize / 2 + s; // Grows with seconds.
    
    int heartColor = color(map(s, 0, 59, 0, 255), 100, 150); // Dynamic color change with seconds. Minute & hour hearts change color dynamically.
    int secondHeartColor = color(220, 100, 100); // Blue color for second hearts (HSB: 220° is blue). Seconds hearts are always blue.

    // Draw the central hour heart
    fill(heartColor);
    drawHeart(width / 2, height / 2, hourSize); // Draws the central (hour) heart.

    // The loop below draw minute hearts around the center. 
    // Surrounds the main heart with 60 minute hearts in a circular pattern.
    for (int i = 0; i < 60; i++) {
      float angle = map(i, 0, 60, 0, TWO_PI);
      float x = width / 2 + cos(angle) * 150;
      float y = height / 2 + sin(angle) * 150;
      fill(heartColor, 200 - i);
      drawHeart(x, y, minuteSize);
    }

    // The FOR loop draw second hearts in a smaller circle **with blue color**
    // Draws second hearts in a smaller ring, colored blue.
    for (int i = 0; i < s; i++) {
      float angle = map(i, 0, 60, 0, TWO_PI);
      float x = width / 2 + cos(angle) * 100;
      float y = height / 2 + sin(angle) * 100;
      fill(secondHeartColor); // Set fill to **blue** for second hearts
      drawHeart(x, y, secondSize);
    }

    // Display time as a **bold digital clock**
    fill(0); // Black color for text
    textFont(digitalFont); // Apply bold digital-style font
    textSize(50); // Set larger font size
    textAlign(CENTER, CENTER); // Center the text
    text(nf(h, 2) + ":" + nf(m, 2) + ":" + nf(s, 2), width / 2, height / 2 + hourSize + 40);
  }

  // Toggle heartbeat animation mode
  void toggleHeartbeatMode() {
    heartbeatMode = !heartbeatMode;
  }
}

// Function to draw a heart shape
void drawHeart(float x, float y, float size) {
  float s = size / 10.0; // Scale the heart shape
  beginShape();
  vertex(x, y);
  bezierVertex(x - s * 5, y - s * 5, x - s * 10, y + s * 2, x, y + s * 10);
  bezierVertex(x + s * 10, y + s * 2, x + s * 5, y - s * 5, x, y);
  endShape(CLOSE);
}
