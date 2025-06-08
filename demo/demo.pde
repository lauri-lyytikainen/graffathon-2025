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
  sceneHandler.addScene(new IntroScene(0.0, 14.0));
  sceneHandler.addScene(new GalaxyScene(14.0, 28.0));
  sceneHandler.addScene(new MetaBallScene(28.0, 42.0));
  sceneHandler.addScene(new WormScene(42.0, 50.0));
  sceneHandler.addScene(new TorusScene(50.0, 63.0));
  sceneHandler.addScene(new DnaScene(63.0, 76.0));
  sceneHandler.addScene(new FishScene(76.0, 90.5));
  sceneHandler.addScene(new SurfaceScene(90.5, 104.5));
  sceneHandler.addScene(new GalaxyScene(104.5, 125));
  sceneHandler.addScene(new MetaBallScene(125, 146));
  sceneHandler.addScene(new DnaScene(146, 160));
  sceneHandler.addScene(new OutroScene(160, 165));



  moonlander = Moonlander.initWithSoundtrack(this, "./data/glxblt_-_swookie.mp3", 138, 4);
  moonlander.start("localhost", 1338, "./data/syncdata.rocket");
  sceneHandler.initializeScenes();
}

void draw() {
  sceneHandler.drawScenes((float)moonlander.getCurrentTime());
  
  moonlander.update();
}
