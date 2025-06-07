import moonlander.library.*;

import ddf.minim.*;

int CANVAS_WIDTH = 720;
int CANVAS_HEIGHT = 480;

Moonlander moonlander;
SceneHandler sceneHandler;

void settings() {
  // size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  fullScreen(P3D);
}

void setup() {
  frameRate(60);

  sceneHandler = new SceneHandler();
  sceneHandler.addScene(new GalaxyScene(14.0, 28.0));


  moonlander = Moonlander.initWithSoundtrack(this, "../glxblt_-_swookie.mp3", 138, 4);
  moonlander.start();
  sceneHandler.initializeScenes();
}

void draw() {
  sceneHandler.drawScenes((float)moonlander.getCurrentTime());
  
  moonlander.update();
}
