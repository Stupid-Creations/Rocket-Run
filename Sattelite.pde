class sat {
  float mass;
  int radius;
  PVector velocity;
  PVector pos;
  PVector acc;
  PVector Fr = new PVector(0, 0);
  float on;
  float G = 6.674 * pow(10, -11);
  PImage image;
  PImage image2;
  int w = 20;
  boolean rect = false;

  sat(float m, int r, PVector p) {
    mass = m;
    radius = r;
    velocity = new PVector(300, 50);
    pos = p;
    acc = new PVector(50, 0);
    on = 0.35;
  }
  void activate_image(PImage a, PImage b) {
    image = a;
    image2 = b;
    if (a.width<0)image.resize(55, 55);
    if (b.width<0)image2.resize(75, 55);
  }
  void render(PVector offset) {
    image(image, pos.x-radius+offset.x, pos.y-radius+offset.y);
  }
  void render_player(float angle) {
    translate(pos.x, pos.y);
    rotate(angle);
    if (state == "off.png")image(image, -27, -27);
    if (state == "on.png")image(image2, -50, -27);
  }
  void update(sat a, float mag) {
    float DistSq = (sq(pos.x-a.pos.x))+(sq(pos.y-a.pos.y));
    PVector ForceDirection = PVector.sub(a.pos, pos).normalize();
    PVector Force = ForceDirection.mult(G).mult(a.mass).div(DistSq).add(Fr);
    acc = Force.div(mass);
    velocity.add(acc.setMag(mag));
    pos.y += velocity.y+Fr.y;
    if (velocity.magSq() >= 4) {
      velocity.setMag(2);
    }
  }

  int check_col(sat a) {
    if (new PVector(a.pos.x-pos.x, a.pos.y-pos.y).magSq()<sq(a.radius+radius)) {
      return 1;
    } else {
      return 0;
    }
  }
}
