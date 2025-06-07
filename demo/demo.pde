import moonlander.library.*;

import ddf.minim.*;

int CANVAS_WIDTH = 480;
int CANVAS_HEIGHT = 360;

Moonlander moonlander;
SceneHandler sceneHandler;

void settings() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
}

void setup() {
  frameRate(60);

  sceneHandler = new SceneHandler();
  sceneHandler.addScene(new CubeScene(0.0, 1.0));


  moonlander = Moonlander.initWithSoundtrack(this, "../glxblt_-_swookie.mp3", 138, 4);
  moonlander.start();
}

void draw() {
  sceneHandler.drawScenes((float)moonlander.getCurrentTime());
  
  moonlander.update();
}
