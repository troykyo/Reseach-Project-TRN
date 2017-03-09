
// Graphing sketch


// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023, followed by a newline, or newline and carriage return

// Created 20 Apr 2005
// Updated 24 Nov 2015
// by Tom Igoe
// This example code is in the public domain.

import processing.serial.*;
PrintWriter txt;
import java.util.Locale;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int oneV = 0;
float inByte1 = 0;
float prevInByte1 = 0;
float inByte2 = 0;
float prevInByte2 = 0;
String[] list = {"troy was here"," and here"," and here"};
String inString = "0";


void setup () {
  // set the window size:
  size(1000, 300);
  oneV = height/5;
  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[2], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0);
}

void draw () {
  // draw the line:
  list = split(inString, ',');
  // convert to an int and map to the screen height:
  inByte1 = float(list[1]);
  //inByte1 = constrain(inByte1, prevInByte2 - 30, prevInByte2 + 30);
  prevInByte1 = inByte1;
  inByte1 = map(inByte1, 0, 1023, 0, height);
  stroke(127, 34, 255);
  line(xPos, height, xPos, height - inByte1);//graph  

  inByte2 = float(list[2]);
  inByte2 = constrain(inByte2, prevInByte2 - 30, prevInByte2 + 30);
  prevInByte2 = inByte2;
  inByte2 = map(inByte2, 0, 1023, 0, height);
  stroke(34, 255, 127);
  line(xPos, height, xPos, height - inByte2);//graph

  
 println(list[0]+ "' " + list[1]+ "' " + list[2]);

  stroke(255);  
  for (int i = 1; i<5; i++) {
    line(0, height-i*oneV, width, height-i*oneV);
  }
  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    saveFrame("line-######.png");
    background(0);
  } else {
    // increment the horizontal position:
    xPos++;
  }
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  inString = myPort.readStringUntil('\n');
  
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
  }
}

