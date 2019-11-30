import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.concurrent.TimeUnit;
import processing.opengl.*;
import processing.sound.AudioIn;
import processing.sound.Sound;
import processing.serial.*;

//required for audio analysis
Minim minim;
AudioRenderer render;
AudioInput in;
Serial arduinoPort;


float strength = 0;
int beatDelta = 0;      //change color based on beat detection
int beatStrength = 255; //how much color changes (0 to 255)
int beatSignal = 0;     //send int to arduino

//variables for automatic rotation of effects
boolean auto = false;
int intervalCount = 10000; //duration of each effect in milliseconds
int previousMillis =0;

//is the arduino connected?
boolean serialConnection;


int mode =1;
Button snakesButton;    //mode =1
Button rainbowButton;   //mode =2
Button rwbButton;       //mode =3
Button cylonButton;     //mode =4
Button reactButton;     //mode =5
Button autoButton;



void setup()
{ 
  //initialize frame
  size(250, 290);
  background(230);
  frameRate(60);

  //get live audio signal
  minim = new Minim(this);
  in = minim.getLineIn();

  //setup render
  render = new Visualize(in);
  in.addListener(render);
  render.setup();
  
  
  //initialize buttons
  snakesButton = new Button("Snakes", 75, 40, 100, 30);
  rainbowButton = new Button("Rainbow", 75, 80, 100, 30);
  rwbButton = new Button("RWB", 75, 120, 100, 30);
  cylonButton = new Button("Cylon", 75, 160, 100, 30);
  reactButton = new Button("React", 75, 200, 100, 30);
  autoButton = new Button("Auto", 75, 240, 100, 30);
  
  
  //try connecting to serial port
  try{
  serialConnection = true;
  String portName = Serial.list()[0]; //port 0 for pc and port 1 for mac
  arduinoPort = new Serial(this, portName, 9600);
  println("COM3 connected");
  }
  
  catch (ArrayIndexOutOfBoundsException e) {
    println("Arduino is not connected to COM3");
    serialConnection = false;
  }
}

void draw()
{
  render.draw();
  
  snakesButton.Draw();
  rainbowButton.Draw();
  rwbButton.Draw();
  cylonButton.Draw();
  reactButton.Draw();
  autoButton.Draw();
}


void stop()
{
  minim.stop();
  super.stop();
}



//class for audio analysis
abstract class AudioRenderer implements AudioListener {
  float[] left;
  float[] right;
  synchronized void samples(float[] samp) { 
    left = samp;
  }
  synchronized void samples(float[] sampL, float[] sampR) { 
    left = sampL; 
    right = sampR;
  }
  abstract void setup();
  abstract void draw();
}


//function to process audio
abstract class FourierRenderer extends AudioRenderer 
{
  FFT fft; 
  float maxFFT;
  float[] leftFFT;
  float[] rightFFT;

  //setup fast fourier transform
  FourierRenderer(AudioSource source) 
  {
    float gain = .125;
    fft = new FFT(source.bufferSize(), source.sampleRate());
    maxFFT =  source.sampleRate() / source.bufferSize() * gain;
    fft.window(FFT.HAMMING);
  }
}

//class for creating buttons
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
  void Draw() {
    fill(150);
    stroke(141);  
    rect(x, y, w, h);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}

//click events
void mousePressed()
{
  if (snakesButton.MouseIsOver()) {
    auto = false;
    mode =1;
  }
  if (rainbowButton.MouseIsOver()) {
    auto = false;
    mode =2;
  }
  if (rwbButton.MouseIsOver()) {
    auto = false;
    mode =3;
  }
  if (cylonButton.MouseIsOver()) {
    auto = false;
    mode =4;
  }
  if (reactButton.MouseIsOver()) {
    auto = false;
    mode =5;
  }
  if (autoButton.MouseIsOver()) {
    mode = 1;
    auto = true;
  }
  println("manually selected mode: " +mode);
  
  //send to arduino
  if(serialConnection == true) {
  arduinoPort.write(mode);
  }
  
}


class Visualize extends FourierRenderer 
{
  BeatDetect beat;

  Visualize(AudioSource source) 
  {
    super(source);
  }


  void setup() 
  {
    colorMode(RGB);
    rectMode(CORNER);
    noStroke();
    noSmooth(); 
    beat = new BeatDetect();
   
  }

  //second draw function
  synchronized void draw() 
  {
   int currentMillis = millis();
   background(200);


    if (left != null) 
    {      

      //beat detection
      beat.detect(in.mix);
      if ( beat.isOnset() == true) {
        beatDelta = beatStrength;
        beatSignal = 1;
    }
    
      beatDelta *= 0.98; //how fast color fades
  
      //map audio signal to volume meter at the top of the UI
      leftFFT = new float[1];
      fft.linAverages(1);
      fft.forward(left);
      leftFFT[0] = fft.getAvg(0);
      strength = lerp(strength, pow(leftFFT[0] * 2, 0.5), .15);
      strength = (strength/1.2 + beatDelta/(beatStrength-5));
    }

//send beat detection info to arduino
if(mode==5 || mode==6 ){
    if (beatSignal == 1) 
  { 
    mode=6;
    if(serialConnection == true) {
   arduinoPort.write(mode);
    }
    mode--;
  }
  
  else if (beatSignal == 0) 
  { 
    mode=5;
  }
    beatSignal = 0;
}

//rotate effects automatically
if(auto == true) {
  if((currentMillis - previousMillis) >= intervalCount) {
    mode++;
    println(mode);
    if(serialConnection == true) {
    arduinoPort.write(mode);
    }
    if(mode==5){
      intervalCount *= 2; //more time for beat visualization effect
    }
    previousMillis = currentMillis;
  }
  if(mode==6) {
    mode=1;
    intervalCount /=2; //adjust interval from beat visualization
    println(mode);
    if(serialConnection == true) {
    arduinoPort.write(mode);
    }
    }
    
}
  
    //draw volume meter at the top of the UI
    fill(beatDelta, 0,255);
    rect(125, 10, width*strength, 12);
    rect(125, 10, -width*strength, 12);
  }
}
