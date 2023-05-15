ArrayList<sat>debris=new ArrayList<sat>();
IntList col = new IntList();

sat Earth = new sat(300, 150/2, new PVector(200, 200));
sat player = new sat(45, 25, new PVector(250, 50));
sat moon = new sat(150, 50, new PVector(4700, 200));

PImage bg;
PImage E;
PImage deb;
PImage mo;
PImage TS;
void setup() {
  frameRate(60);
  noStroke();
  ellipseMode(RADIUS);
  size(400, 400);
  Earth.rect = true;
  bg = requestImage("images/background.jpg");
  E = requestImage("images/Earth.png");
  deb  =  requestImage("images/as.png");
  mo = requestImage("images/moon.png");
  TS = requestImage("images/space.png");

  for (int i = 1000; i<4500; i+=random(150, 250)) {
    debris.add(new sat(25, 25, new PVector(i, random(0, height))));
    col.append(0);
  }
}

PVector ima = new PVector(0, 0);
PVector imb = new PVector(400, 0);

String text = "";
String state = "off.png";

int i = 0;
int t = -1;

boolean alarm = false;
boolean done = false;
boolean press = false;

int menu = 1;
int angle = 0;
int fuel = 2000;
int count = 0;


void draw() {
  if (menu == 4) {
    textSize(43);
    text("You won!", 0, 45);
    textSize(25);
    text("Press enter to restart", 0, 75);
    if (keyPressed) {
      if (key == ENTER) {
        col.clear();
        fuel = 1600;
        ima = new PVector(0, 0);
        imb = new PVector(400, 0);
        Earth.pos.x = 200;
        player.pos = new PVector(250, 50);
        moon.pos.x = 4700;
        angle = 0;
        i = 1000;
        player.velocity = new PVector(300, 50);
        for (int y = 0; y<debris.size(); y++) {
          debris.get(y).pos = new PVector(i, random(0, height));
          col.append(0);
          i+=random(150, 250);
        }
        menu = 2;
      }
    }
  }
  if (menu == 3) {
    textSize(43);
    text("Oops! You crashed", 0, 45);
    textSize(25);
    text("Press enter to restart", 0, 75);
    if (keyPressed) {
      if (key == ENTER) {
        fuel = 1600;
        col.clear();
        ima = new PVector(0, 0);
        imb = new PVector(400, 0);
        Earth.pos.x = 200;
        player.pos = new PVector(250, 50);
        moon.pos.x = 4700;
        angle = 0;
        i = 1000;
        player.velocity = new PVector(300, 50);
        for (int y = 0; y<debris.size(); y++) {
          debris.get(y).pos = new PVector(i, random(0, height));
          col.append(0);
          i+=random(150, 250);
        }
        menu = 2;
      }
    }
  }
  if (menu == 1) {
    fill(255);
    textSize(72);
    text(text, 30, 55);

    i ++;
    if (alarm == false) {
      if (i%6.5 == 0) {
        t ++;
        if (t == "Rocket Run".length()) {
          t = 0;
          alarm = true;
          done = true;
          return;
        }
        text += "Rocket Run".charAt(t);
        image(TS, 0, 0);
      }
    }

    textSize(18);
    if (done) {
      bg.resize(width+5, height);
      mo.resize(159, 159);
      moon.image = mo;
      Earth.image = E;
      deb.resize(55, 55);
      E.resize(175, 175);
      player.activate_image(requestImage("images/off.png"), requestImage("images/on.png"));
      text("press any key to continue", 100, 300);
    }
    // main game
    textSize(10.7);
  }
  if (menu == 2) {
    background(195);
    fill(255);
    image(bg, ima.x, ima.y);
    image(bg, imb.x, imb.y);
    ima.x-=player.velocity.x;
    imb.x-=player.velocity.x;
    if (ima.x<-400)ima.x=400;
    if (imb.x<-400)imb.x = 400;
    if (ima.x>400)ima.x=-400;
    if (imb.x>400)imb.x =-400;

    for (int i = 0; i<debris.size(); i++) {
      debris.get(i).image = deb;
      debris.get(i).render(new PVector(0, 0));
      if (debris.get(i).pos.x < 400 && debris.get(i).pos.x > 0 ) {
        col.set(i, player.check_col(debris.get(i)));
        player.update(debris.get(i), 0.005);
      }
      if (col.get(i) == 1)menu = 3;
      debris.get(i).pos.x -= player.velocity.x;
    }
    if (Earth.pos.x < 400 && Earth.pos.x > 0 ) player.update(Earth, 0.05);
    if (moon.pos.x < 400 && moon.pos.x > 0 ) player.update(moon, 0.025);
    int  a = Earth.check_col(player); 
    int m = moon.check_col(player);
    if (a==1)menu = 3;
    if (m == 1) {
      if (player.velocity.mag()<0.6) {
        menu = 4;
      } else menu = 3;
    }
    Earth.render(new PVector(-13, -7));
    moon.render(new PVector(-30, -23));
    Earth.pos.x -= player.velocity.x;
    moon.pos.x -= player.velocity.x;
    if (!keyPressed) {
      count = 0;
      state = "off.png";
      player.Fr = new PVector(0, 0);
    }
    if (count == 1) {
      if (fuel>0) {
        player.Fr.add(PVector.fromAngle(radians(angle))).mult(player.on);
        fuel -= 0.5;
      }
    }
    if (!press) {
      if (Earth.pos.x<400&Earth.pos.x>0) {
        textSize(10.7);
        text("press space to move,a and d to rotate. Press q to dismiss", 0, 345);
      }
      if (debris.get(debris.size()-1).pos.x<0) {
        textSize(10);
        text("Almost there! Make sure your speed is less than 1.7 befor landing on the moon.", 0, 315);
      }
    } else if (debris.get(debris.size()-1).pos.x<0) {
      press = false;
    }


    textSize(13);
    text(str(map(player.velocity.mag(), 0, 3.5, 0, 10))+" m/s", 300, 300);
    rect(300, 325, map(fuel, 0, 1600, 0, 100), 25);
    textSize(25);
    text("Fuel", 300, 370);
    player.render_player(radians(angle));
  }
}

void keyPressed() {
  if (menu == 1) {
    if (done == true) {
      menu = 2;
    }
  }

  if (menu == 2) {
    if (key == 'q') {
      press = true;
    }
    if (key == 'a') {
      angle-=5;
    }
    if (key == 'd') {
      angle+=5;
    }
    if (key == ' ') {
      state = "on.png";
      count = 1;
    }
  }
}
