abstract class EffectScene {
    public double startTime, endTime, normalizedTime;
    public EffectScene(float startTime, float endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
        this.normalizedTime = 0.0;
    }
    public void update(float time) {
        if (time >= startTime && time < endTime) {
            normalizedTime = (time - startTime) / (endTime - startTime);
        } else if (time >= endTime) {
            normalizedTime = 1.0;
        } else {
            normalizedTime = 0.0;
        }
        draw((float)time);
    }

    private abstract void draw(float time); // Abstract method to be implemented by subclasses
}
class SceneHandler {
    ArrayList<EffectScene> scenes;
    EffectScene currentScene;
    public SceneHandler() {
        scenes = new ArrayList<EffectScene>();
    }
    public void addScene(EffectScene scene) {
        scenes.add(scene);
    }
    public void drawScenes(double time) {
        for (EffectScene scene : scenes) {
            if (time >= scene.startTime && time < scene.endTime) {
                if (currentScene != null && currentScene != scene) {
                    resetEverything();
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
    blendMode(NORMAL);
    colorMode(RGB);
}