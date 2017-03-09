/**
 spiral drive
 
 The parametric equation for a circle is
 
 x = cx + r * cos(a)
 y = cy + r * sin(a)
 Where r is the radius, cx,cy the origin, and a the angle.
 
 // Convert from degrees to radians via multiplication by PI/180 
 */
PrintWriter txt;
import java.util.Locale;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


int angle = 20;//angle to determine how many blades,  divisible by 360
int radius = 50;
int centerX=200;
int centerY=200;
float rX=0;
float rY=0;
final float layerHeight = 0.2;
float currentLayer = 0;
float layerCount = 0; 
final float layersTotal = 150;
float finalHeight = 0;
float extrusionCoefficient = 0.3;
float PIXELPITCH = 0.343*1.02;//Printed adjustment for the Prusa
float DPMM = 1/PIXELPITCH;//dots per mm (OLD WAS 2.834646, then .277)
float ext = 0;
float speed = 600;
float travelSpeed = 2400;
int L = 3;//digits before dot for shortening the gCode results
int R = 1;//digits after dot

void setup() {
  size(1000, 1000);
  //noSmooth();
  background(0);
  //  translate(0, 0);
  finalHeight = layersTotal*layerHeight;
  centerX=width/2;
  centerY=height/2;
  SimpleDateFormat sdf = new SimpleDateFormat("-yyyy-MM-dd/HH-mm"); 
  Date now = new Date(); 
  println("write to files "SPIRAL"+sdf.format(now)+".gCode";
  txt = createWriter("spiral"+sdf.format(now) + ".gcode");
  
        }
        // Draw gray box
        
        
        //Line 
        void draw() {
          stroke(255);
          startGcode();
          while (finalHeight>currentLayer){
            layerStart();
            spiral();
            }
          generateGcode();
        }
        void spiral (){
          for (int i=0; i<360; i=i+angle) {
            rX=radius*cos((i+layerCount)*PI/180)+centerX;
            rY=radius*sin((i+layerCount)*PI/180)+centerY;
            ext = ext + dist(centerX, centerY, rX, rY)*extrusionCoefficient;
            line(centerX, centerY, rX, rY);
            txt.println(" G0 X"+ nf(centerX/DPMM, L, R) + " Y" + nf(centerY/ DPMM, L, R)+ " F" + travelSpeed);
            txt.println("G1 X" + nf(rX/DPMM, L, R) + " Y" + nf(rY/DPMM, L, R) + " E" + nf(ext/DPMM, L, R) + " F" + speed);
            println (rX + ", " + rY + ", " + i); 
          }
        } 
        
        void startGcode() {// currently for an Ultimaker 2 Extended.  Cut and Paste from Cura generated gCode
          txt.println("FLAVOR: UltiGCode");
          txt.println("; TIME:  400");
          txt.println("; MATERIAL:  160");
          txt.println("; MATERIAL2:   0");
          txt.println(";NOZZLE_DIAMETER:   0.800000");
          txt.println(";NOZZLE_DIAMETER2:   0.800000");
          txt.println(";Layer count:   " + layersTotal);
          txt.println(";LAYER:   0");
          txt.println("M109 S215");
          txt.println("G28");
          txt.println("M107");
          txt.println("M109 S215");
          txt.println("G0 F9000 X10 Y110");
          txt.println("G0  F" + speed +" Z"+ 15); //Start Layer
        }
        
        void endGcode() {// currently for an Ultimaker 2 Extended.  Cut and Paste from Cura generated gCode
          txt.println("M107");
          txt.println("G10");
          txt.println("G0 F9000 X110.000 Y126.900 Z15.000");
          txt.println("M109 S0");
          txt.println("M25 ; Stop reading from this point on.");
          txt.println(";CURA_PROFILE_STRING:  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");
        }
        
        void layerStart() {
          currentLayer = currentLayer + layerHeight;
          layerCount++;
          txt.println("G0  F"+speed +" Z"+currentLayer);
          txt.println("M117 "+ currentLayer/layerHeight + " out of " + layersTotal);
        }
        
        void generateGcode(){
          endGcode();
          txt.flush(); 
          txt.close(); 
          endRecord();
          exit(); 
        }
