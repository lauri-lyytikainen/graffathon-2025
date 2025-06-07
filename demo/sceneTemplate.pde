abstract class EffectScene {
    public double startTime, endTime;
    public float normalizedTime;
    public EffectScene(float startTime, float endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
        this.normalizedTime = 0.0;
    }
    public void update(float time) {
        if (time >= startTime && time < endTime) {
            normalizedTime = (float)((time - startTime) / (endTime - startTime));
        } else if (time >= endTime) {
            normalizedTime = 1.0;
        } else {
            normalizedTime = 0.0;
        }
        draw((float)time);
    }
    public abstract void setup();
    public abstract void draw(float time);
}
class SceneHandler {
    ArrayList<EffectScene> scenes;
    EffectScene currentScene;
    public SceneHandler() {
        scenes = new ArrayList<EffectScene>();
        currentScene = null;
    }
    public void addScene(EffectScene scene) {
        scenes.add(scene);
    }
    public void initializeScenes() {
        scenes.get(0).setup(); // Setup the first scene
        resetEverything();

    }

    public void drawScenes(double time) {
        for (EffectScene scene : scenes) {
            if (time >= scene.startTime && time < scene.endTime) {
                if (currentScene != null && currentScene != scene) {
                    resetEverything();
                    scene.setup();
                }
                currentScene = scene;
                scene.update((float)time);
            }
        }
    }
}

void resetEverything() {
    fill(255);
    stroke(0);
    strokeWeight(1);
    camera();
    lights();
    blendMode(BLEND);
    colorMode(RGB);
}