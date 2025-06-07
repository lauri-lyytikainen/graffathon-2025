class IntroScene extends EffectScene {

    ArrayList<PVector> nodes = new ArrayList<PVector>();
    PFont font;

    public IntroScene(float startTime, float endTime) {
        super(startTime, endTime);
        font = createFont("Monospaced", 32, true);
    }

    public void setup() {
        int nodeCount = 1000;
        nodes.clear();
        for (int i = 0; i < nodeCount; i++) {
            float x = random(-width/2, width/2);
            float y = random(-width/2, height/2);
            float z = random(-200, 1);
            nodes.add(new PVector(x, y, z));
        }
        textFont(font);
    }

    public void draw(float time) {
        background(0);
        String[] futuristicWords = {
            "FUTURE", "TECHNOLOGY", "INNOVATION", "PROGRESS", "VISION", "ADVANCEMENT",
            "REVOLUTION", "EVOLUTION", "EXPLORATION", "DISCOVERY"
        };
        int visibleNodes = int(normalizedTime * nodes.size());
        int idx = 0;
        for (PVector node : nodes) {
            if (idx >= visibleNodes) break;
            pushMatrix();
            translate(node.x, node.y, node.z);
            fill(255, 150);
            stroke(255, 100);
            noStroke();
            float t = time * 0.2;
            float nx = noise(node.x * 0.01 + t, node.y * 0.01, node.z * 0.01) - 0.5;
            float ny = noise(node.x * 0.01, node.y * 0.01 + t, node.z * 0.01) - 0.5;
            float nz = noise(node.x * 0.01, node.y * 0.01, node.z * 0.01 + t) - 0.5;
            PVector offset = new PVector(nx, ny, nz).mult(200);
            stroke(0, 200, 255, 180);
            line(0, 0, 0, offset.x, offset.y, offset.z);
            // Generate a changing suffix of numbers/symbols
            String base = futuristicWords[idx % futuristicWords.length];
            int num = int(abs(sin(time + idx) * 999));
            String[] symbols = {"#", "@", "*", "-", "+", "=", "%", "^", "~"};
            String symbol = symbols[(idx + int(time * 2)) % symbols.length];
            String word = base + "-" + num + symbol;
            textAlign(CENTER, CENTER);
            textSize(16);
            text(word, offset.x, offset.y + 20, offset.z);
            translate(offset.x, offset.y, offset.z);
            popMatrix();
            idx++;
        }

        // Draw special nodes at 0.25, 0.5, 0.75 of normalizedTime, using node positions and offsets, rendered on top, top-to-bottom order
        float[] specialTimes = {0.25, 0.5, 0.75};
        String[] specialTexts = {"Todo & Nora", "present", "Evolution"};
 
        // Render special nodes at fixed screen positions (top left, middle right, bottom center)
        float nodeW = width * 0.28;
        float nodeH = height * 0.10;
        float marginX = width * 0.05;
        float marginY = height * 0.05;
        float specialZ = -50; // Z position for special nodes
        float[][] specialPositions = {
            { -width/4 + nodeW/2 + marginX, -height/4 + nodeH/2 + marginY }, // top left
            {  width/4 - nodeW/2 - marginX, 0 },                             // middle right
            { 0, height/4 - nodeH/2 - marginY }                              // bottom center
        };
        for (int i = 0; i < 3; i++) {
            if (normalizedTime >= specialTimes[i]) {

                String text = specialTexts[i];
                float x = specialPositions[i][0];
                float y = specialPositions[i][1];
                pushMatrix();
                translate(x, y, specialZ);
                fill(255);
                noStroke();
                rectMode(CENTER);
                rect(0, 0, nodeW, nodeH);
                fill(0);
                textAlign(CENTER, CENTER);
                textSize(min(width, height) * 0.045);
                text(text, 0, 0);
                popMatrix();
            }
        }

        camera(0, 0, 500, 0, 0, 0, 0, 1, 0);
    }
}
