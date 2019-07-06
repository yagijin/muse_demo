import cc.arduino.*;
import org.firmata.*;

import oscP5.*;
  
// OSC PARAMETERS & PORTS
int recvPort = 7000;
OscP5 oscP5;
  
// DISPLAY PARAMETERS
int WIDTH = 1100;
int HEIGHT = 1100;

public static final int TIME_WIDTH = 10000;

float[][] eegdata;
  
void settings(){
   size(WIDTH,HEIGHT);
}


void setup(){
  frameRate(20);
  background(0);
  
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  eegdata = new float[4][TIME_WIDTH];
  for(int j = 0; j < 4; j++){
    for(int i = 0; i < TIME_WIDTH; i++) {
      eegdata[j][i] = 0;
    }
    draw_graph(j);
  }
}

void draw(){
  
   background(0);
   for(int i = 0; i < 4; i++){
     draw_graph(i);
   }
}
 
void update_data(int electrode,float data){
  float[][] newdata;
  newdata = eegdata;
  
  newdata[electrode][0] = data;
  
  for(int i = 0; i < TIME_WIDTH-1; i++){
    newdata[electrode][i+1] = eegdata[electrode][i];
  }
  eegdata = newdata;
}
  
void draw_graph(int electrode){

  float position =  electrode*250;
  
  for(int i = 0; i < TIME_WIDTH - 1; i++){
      line(float(i)/10, eegdata[electrode][i]*250/1682.815 + position, float((i+1))/10, eegdata[electrode][i+1]*250/1682.815 + position);
      stroke(126);
  }
}
  
void oscEvent(OscMessage msg) {
  //System.out.println("### got a message " + msg);
  System.out.println("### got a message " + msg);
  if (msg.checkAddrPattern("muse/eeg")==true) {  
    //background(0);
    for(int i = 0; i < 4; i++) {
      update_data(i,msg.get(i).floatValue());
      //draw_graph(i);
    }
  }
}
