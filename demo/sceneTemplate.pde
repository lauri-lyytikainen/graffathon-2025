abstract class EffectScene {
    public double startTime, endTime;
    public EffectScene(float startTime, float endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }
    public abstract void draw(double time); // Abstract method to be implemented by subclasses
}
class SceneHandler {
    ArrayList<EffectScene> scenes;
    public SceneHandler() {
        scenes = new ArrayList<EffectScene>();
    }
    public void addScene(EffectScene scene) {
        scenes.add(scene);
    }
    public void drawScenes(double time) {
        for (EffectScene scene : scenes) {
            if (time >= scene.startTime && time < scene.endTime) {
                scene.draw(time);
            }
        }
    }
}