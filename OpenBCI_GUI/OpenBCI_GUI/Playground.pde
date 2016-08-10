//////////////////////////////////////////////////////////////////////////
//
//		Playground Class
//		Created: 11/22/14 by Conor Russomanno
//                Edited: 07/27/16 by Irene Vigue Guix
//		An extra interface pane for additional GUI features
//
//////////////////////////////////////////////////////////////////////////


class Playground {

  //Button for opening and closing
  float x, y, w, h;
  float topMargin, bottomMargin;
  float expandLimit = width/2.5;
  boolean isOpen;
  boolean collapsing;

  // Playground
  int count = 1;
  int heart = 0;
  int TrailWindowWidth;
  int TrailWindowHeight; 
  int TrailWindowX;
  int TrailWindowY;
  color eggshell;
  int[] TrialY;      // HOLDS TRIAL DATA
  boolean OBCI_inited= false;
  OpenBCI_ADS1299 OBCI;

  // Text and Colors
  color boxBG;
  color strokeColor;
  color green;
  color red;
  color softgray;
  color darkgray;
  PFont myFont;

  // MI vs ME Buttons stuff
  Button collapser;
  Button StartTrial;
  Button StopTrial;
  Button Trials;
  Button RestState;
  boolean StartTrialButtonPressed = false;
  boolean StopTrialButtonPressed = false;
  boolean TrialsButtonPressed = false;
  boolean RestStateButtonPressed = false;
  boolean help = false;
  public String but_txt;

  // Timing
  boolean TestRunning = false;
  int startingTime;
  int seconds;
  int minutes;
  int onlysecs; 
  int ThisTime;
  int bonusTime = 0;
  int sec;
  int min;
  int countdown;

  // Images
  StringList task;
  PImage rightfinger;
  PImage leftfinger;
  PImage trials;
  PImage reststate;
  PImage eeg;
  PImage[]  eegdata = new PImage[4];

  //Send Serial Char
  char serialchar_f;
  char serialchar_g;
  char serialchar_k;
  char serialchar_l;
  char serialchar_o;
  char serialchar_O;
  boolean sendf = false;
  boolean sendg = false;
  boolean sendk = false;
  boolean sendl = false;
  boolean sendo = false;
  boolean sendO = false;

  // Margins
  Playground(int _topMargin) {

    //Playground
    topMargin = _topMargin;
    bottomMargin = helpWidget.h;
    isOpen = false;
    collapsing = true;
    boxBG = bgColor;

    // Colors
    strokeColor = color(138, 146, 153);
    green = color(115, 220, 120);
    red = color(230, 120, 140);
    softgray =  color(240, 240, 240);
    darkgray = color(200, 200, 200);

    // Buttons
    collapser = new Button(0, 0, 20, 60, "<", 14);
    StartTrial = new Button(int(x+300), int(y+70), 60, 30, "Start", 12);
    StopTrial = new Button(int(x+370), int(y+70), 60, 30, "Stop", 12);
    Trials = new Button(int(x+300), int(y+100), 60, 30, "Training", 12);
    RestState = new Button(int(x+370), int(y+100), 60, 30, "Play", 12);
    StartTrial.setColorPressed(darkgray);
    StartTrial.setColorNotPressed(green);
    StopTrial.setColorPressed(darkgray);
    StopTrial.setColorNotPressed(red);
    Trials.setColorPressed(darkgray);
    Trials.setColorNotPressed(softgray);
    RestState.setColorPressed(darkgray);
    RestState.setColorNotPressed(softgray);

    // Send chars
    serialchar_f = 'f';
    serialchar_g = 'g';
    serialchar_k = 'k';
    serialchar_l = 'l';
    serialchar_o = 'o';
    serialchar_O = 'O';

    // Playground Window
    keyPressed = false;
    x = width;
    y = topMargin;
    w = 0;
    h = (height - (topMargin+bottomMargin))/2;
    eggshell = color(255);
    TrailWindowWidth = 440;
    TrailWindowHeight = 183;
    TrailWindowX = int(x)+5;
    TrailWindowY = int(y)-10+int(h)/2;
    TrialY = new int[TrailWindowWidth];
  }

  public void initPlayground(OpenBCI_ADS1299 _OBCI) {
    OBCI = _OBCI;
    OBCI_inited = true;
  }

  public void update() {
    // verbosePrint("uh huh");
    if (collapsing) {
      collapse();
    } else {
      expand();
    }

    if (x > width) {
      x = width;
    }
  }  

  public void draw() {
    // verbosePrint("yeaaa");
    if (OBCI_inited) {

      pushStyle();
      fill(boxBG);
      stroke(strokeColor);
      rect(width - w, topMargin, w, h);

      textFont(f4, 30);
      textAlign(LEFT, TOP);
      fill(eggshell);
      text("Emotion Recognition", x+20, y+20);

      //TRAIL WINDOW
      fill(eggshell);  // pulse window background
      stroke(eggshell);
      rect(TrailWindowX, TrailWindowY, TrailWindowWidth, TrailWindowHeight);

      //TRIAL STUFF
      // Timing
      ThisTime = (millis() - startingTime)+ bonusTime;
      seconds = ThisTime / 1000;
      minutes = seconds / 60;
      onlysecs = seconds - 60*minutes;
      sec = 60 - onlysecs;
      min = (countdown - minutes);
      countdown = 2;

      // TEST IS NOT RUNNING YET
      //if (!TestRunning) {
      //  textFont(f4, 16);
      //  textAlign(LEFT, TOP);
      //  text("Before pressing START you must", x+20, y+60);
      //  text("select \"Training\" or \"Play\".", x+20, y+75);

      //  if (Trials.isMouseHere()) {
      //    textFont(f4, 10);
      //    textAlign(LEFT, TOP);
      //    fill(0);
      //    text("Before rials consists in an experiment involving four different tasks of simple finger typing", TrailWindowX+20, TrailWindowY+20);
      //    text("to differenciate between Motor Imagery and Motor Execution. Each \"trial\" is 40s long,", TrailWindowX+20, TrailWindowY+35);
      //    text("and it involves four different cues of 10s, which are: move right finger, move left", TrailWindowX+20, TrailWindowY+50);
      //    text("finger, imagine moving right finger, and imagine moving left finger, respectively.", TrailWindowX+20, TrailWindowY+65);
      //  }

      //  if (RestState.isMouseHere()) {
      //    textFont(f4, 12);
      //    textAlign(LEFT, TOP);
      //    fill(0);
      //    text("Rest State consists in register brain signals", TrailWindowX+140, TrailWindowY+30);
      //    text("while the subject is restless for 2 min.", TrailWindowX+140, TrailWindowY+45);
      //    text("Since we are interested in the post processing of", TrailWindowX+140, TrailWindowY+70);
      //    text("the EEG data in order to compare Motor Imagery", TrailWindowX+140, TrailWindowY+85);
      //    text("MI) and Motor Execution (ME) on each cue, it is", TrailWindowX+140, TrailWindowY+100);
      //    text("needed an EEG data baseline (as a control) to", TrailWindowX+140, TrailWindowY+115);
      //    text("compare it with the Trials data.", TrailWindowX+140, TrailWindowY+130);
      //  }
      //}

      // TEST RUNNING
      if (TestRunning) {            

        fill(softgray);
        textFont(f4, 30);
        textAlign(LEFT, TOP);

        //************************************************TRIALS******************************************************+

        if ((TrialsButtonPressed) && (!RestStateButtonPressed)) {
          if (onlysecs < 10) {
            text("Time " + " " + "-" + " " + ((minutes) + ":" + "0" + (onlysecs)), x+40, y+70);
          } else {
            text("Time " + " " + "-" + " " + ((minutes) + ":" + (onlysecs)), x+40, y+70);
          }

          if (count < 30) {
            text("Trial" + " " + "-" + " " + "0" + (count) + "/" + "30", x+40, y+110);
          } else {
            text("Trial" + " " + "-" + " " + (count) + "/" + "30", x+40, y+110);
          }

          //************************************************ Move Right Finger

          if (ThisTime < 1000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(green);
            text("READY", TrailWindowX+140, TrailWindowY+70);
          }

          if (ThisTime > 1000 && ThisTime < 2000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("3", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 2000 && ThisTime < 3000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("2", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 3000 && ThisTime < 4000) {
            textFont(f4, 80);
            textAlign(LEFT, TOP);
            fill(0);
            text("1", TrailWindowX+200, TrailWindowY+50);
          }

          if (ThisTime > 4000 && ThisTime < 6000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(0);
            text("CUE", TrailWindowX+160, TrailWindowY+70);
            if (sendg) {
              openBCI.sendChar('g');
              sendg = false;
            }
          }  

          if (ThisTime > 6000 && ThisTime < 8000) {
            textFont(f4, 50);
            textAlign(LEFT, TOP);
            fill(darkgray);
            text("REST", TrailWindowX+150, TrailWindowY+70);
          } 

          if (ThisTime > 8000) {
            count ++;
            bonusTime = 0;

            if (count < 31) {
              startingTime = millis();
              sendf = true;
              sendg = true;
              sendk = true;
              sendl = true;
              sendo = true;
              sendO = true;

              println("Back to beginning...");
            } else {
              TestRunning = false;
              println("Final trial finished...");
              if (sendO) {
                openBCI.sendChar('O');
                sendO = false;
              }
            }
          }
        } else {

          //****************************************** REST STATE ******************************************************

          if (countdown != minutes) {
            //background(255);
            fill(0);      
            text("Work in process", TrailWindowX+100, TrailWindowY+80);
            
            //calcWave();
            //renderWave();
            
            //image(eeg, TrailWindowX+45, TrailWindowY+5);
            //for (int i=0; i < eegdata.length; i = i++) {
            //  image(eegdata[(int)random(4)], TrailWindowX+160, TrailWindowY+10);
          }

          if (onlysecs < 1) {
            fill(255);
            textSize(30);
            text("Time " + " " + "-" + " " + countdown + ":" + "00", x+40, y+70);
          }

          if ((onlysecs <= 50) && (onlysecs >= 1)) {
            fill(255);
            textSize(30);
            text("Time " + " " + "-" + " " + ((min-1) + ":" + (sec)), x+40, y+70);
          } 

          if ((onlysecs > 50 ) && (onlysecs < 60)) {
            fill(255);
            textSize(30);
            text("Time " + " " + "-" + " " + (min-1) + ":" + "0" + (sec), x+40, y+70);
          }

          if (onlysecs == 60) {
            fill(255);
            textSize(30);
            text("Time " + " " + "-" + " " + (min-1) + ":" + "00", x+40, y+70);
          } else { 

            if (minutes == countdown) {
              fill(255);
              textSize(30);
              text("Time " + " " + "-" + " " + "0" + ":" + "00", x+40, y+70);
            }
          }
        }
      }

      fill(255, 0, 0);
      collapser.draw(int(x - collapser.but_dx), int(topMargin + (h-collapser.but_dy)/2));

      fill(255, 0, 0);
      StartTrial.draw(int(x+300), int(y+70));

      fill(255, 0, 0);
      StopTrial.draw(int(x+370), int(y+70));

      fill(255, 0, 0);
      Trials.draw(int(x+300), int(y+110));

      fill(255, 0, 0);
      RestState.draw(int(x+370), int(y+110));

      popStyle();
    }
  }


  boolean isMouseHere() {
    if (mouseX >= x && mouseX <= width && mouseY >= y && mouseY <= height - bottomMargin) {
      return true;
    } else {
      return false;
    }
  }

  boolean isMouseInButton() {
    verbosePrint("Playground: isMouseInButton: attempting");
    if (mouseX >= collapser.but_x && mouseX <= collapser.but_x+collapser.but_dx && mouseY >= collapser.but_y && mouseY <= collapser.but_y + collapser.but_dy) {
      return true;
    } else {
      return false;
    }
  }

  public void toggleWindow() {
    if (isOpen) {//if open
      verbosePrint("close");
      collapsing = true;//collapsing = true;
      isOpen = false;
      collapser.but_txt = "<";
    } else {//if closed
      verbosePrint("open");
      collapsing = false;//expanding = true;
      isOpen = true;
      collapser.but_txt = ">";
    }
  }

  void keyPressed() {
  }

  public void mousePressed() {
    verbosePrint("Playground >> mousePressed()");

    if (StartTrial.isMouseHere()) {
      if ((TrialsButtonPressed && !RestStateButtonPressed) || (!TrialsButtonPressed && RestStateButtonPressed)) {
        StartTrial.setIsActive(true);
        StartTrialButtonPressed = true;
        StopTrial.setIsActive(false);
        sendo = true;
        if (sendo) {
          openBCI.sendChar('o');
          sendo = false;
        }
        if (!TestRunning) {
          TestRunning = true;
          startingTime = millis();
        }
      }
      if ((TrialsButtonPressed && !RestStateButtonPressed) || (!TrialsButtonPressed && RestStateButtonPressed)) {
        StartTrial.setIsActive(false);
        StartTrialButtonPressed = false;
        StopTrial.setIsActive(false);
        help = true;
      }
    }

    if (StopTrial.isMouseHere()) {
      if ((TrialsButtonPressed && !RestStateButtonPressed) || (!TrialsButtonPressed && RestStateButtonPressed)) {
        StopTrial.setIsActive(true);
        StopTrialButtonPressed = true;
        StartTrial.setIsActive(false);
        if (sendO) {
          openBCI.sendChar('O');
          sendO = false;
        }
        if (TestRunning) {
          TestRunning = false;
          startingTime = millis();
        }
      }
      if ((TrialsButtonPressed && !RestStateButtonPressed) || (!TrialsButtonPressed && RestStateButtonPressed)) {
        StartTrial.setIsActive(false);
        StartTrialButtonPressed = false;
        StopTrial.setIsActive(false);
        help = true;
      }
    }

    if (Trials.isMouseHere()) {
      help = false;
      Trials.setIsActive(true);
      TrialsButtonPressed = true;
      RestState.setIsActive(false);
      RestStateButtonPressed = false;
      sendf = true;
      sendg = true;
      sendk = true;
      sendl = true;
    }

    if (RestState.isMouseHere()) {
      RestState.setIsActive(true);
      RestStateButtonPressed = true;
      Trials.setIsActive(false);
      TrialsButtonPressed = false;      
    }
  }

  public void mouseReleased() {
    verbosePrint("Playground >> mouseReleased()");
  }

  public void expand() {
    if (w <= expandLimit) {
      w = w + 50;
      x = width - w;
      TrailWindowX = int(x)+5;
    }
  }

  public void collapse() {
    if (w >= 0) {
      w = w - 50;
      x = width - w;
      TrailWindowX = int(x)+5;
    }
  }

  public void plus1000() {
    println("+1 sec");
    println("ThisTime: " + ThisTime);
    bonusTime += 1000;
  }
};