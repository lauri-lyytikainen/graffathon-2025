class OutroScene extends EffectScene {
    public OutroScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    // Node class for the network
    class Node {
        PVector basePos, offset;
        float speed, angleOffset;
        Node(float x, float y) {
            basePos = new PVector(x, y);
            offset = PVector.random2D().mult(random(10, 40));
            speed = random(0.2, 0.7);
            angleOffset = random(TWO_PI);
        }
        PVector getPos(float t) {
            // Circular or wobbly motion based on time
            float angle = t * speed + angleOffset;
            float r = 1.0 + 0.3 * sin(t * speed * 0.7 + angleOffset * 2);
            return new PVector(
                basePos.x + offset.x * cos(angle) * r,
                basePos.y + offset.y * sin(angle) * r
            );
        }
        void display(float t) {
            PVector p = getPos(t);
            fill(255);
            noStroke();
            ellipse(p.x, p.y, 8, 8);
        }
    }

    ArrayList<Node> nodes;
    float connectDist = 120;

    public void setup() {
        nodes = new ArrayList<Node>();
        int nodeCount = 300;
        for (int i = 0; i < nodeCount; i++) {
            nodes.add(new Node(random(width), random(height)));
        }
    }

    public void draw(float time) {
        background(0, 60); // Faint fade for trails

        // Calculate fade factor for lines
        float fadeFactor = 1.0;
        if (normalizedTime >= 0.75) {
            fadeFactor = 1.0 - constrain(map(normalizedTime, 0.75, 1.0, 0, 1), 0, 1);
        }

        // Display nodes
        for (Node n : nodes) {
            n.display(time);
        }

        // Draw lines between close nodes, apply fade
        strokeWeight(1.2);
        for (int i = 0; i < nodes.size(); i++) {
            Node a = nodes.get(i);
            PVector pa = a.getPos(time);
            for (int j = i + 1; j < nodes.size(); j++) {
                Node b = nodes.get(j);
                PVector pb = b.getPos(time);
                float d = dist(pa.x, pa.y, pb.x, pb.y);
                if (d < connectDist) {
                    float alpha = map(d, 0, connectDist, 255, 0) * fadeFactor;
                    stroke(255, alpha);
                    line(pa.x, pa.y, pb.x, pb.y);
                }
            }
        }

        // --- White boxes with black letters (copied from introScene style) ---
        String[] outroTexts = {"Evolution", "Todo & Nora", "Graffathon_2025", "Music: glxblt - Swookie"};
        float nodeW = width * 0.35;
        float nodeH = height * 0.10;
        float marginX = width * 0.05;
        float marginY = height * 0.05;
        float[][] outroPositions = {
            { marginX + nodeW/2, marginY + nodeH/2 }, // top left
            { width - marginX - nodeW/2, marginY + nodeH/2 }, // top right
            { width/2, height - marginY - nodeH/2 }, // bottom center
            { width/2, height/2 } // center for music
        };
        for (int i = 0; i < 4; i++) {
            float x = outroPositions[i][0];
            float y = outroPositions[i][1];
            pushMatrix();
            translate(x, y, 0);
            fill(255);
            noStroke();
            rectMode(CENTER);
            if (i == 3) {
                // Center box for music
                nodeW = width * 0.5;
            }
            rect(0, 0, nodeW, nodeH);
            fill(0);
            textAlign(CENTER, CENTER);
            textSize(min(width, height) * 0.045);
            // Generate a changing suffix of numbers/symbols
            int num = int(abs(sin(time + i) * 999));
            String[] symbols = {"#", "@", "*", "-", "+", "=", "%", "^", "~"};
            String symbol = symbols[(i + int(time * 2)) % symbols.length];
            String text = outroTexts[i] + "-" + num + symbol;
            text(text, 0, 0);
            popMatrix();
        }

        // Fade to black when normalized time is 0.75 to 1
        if (normalizedTime >= 0.75) {
            float fadeAmt = map(normalizedTime, 0.75, 1.0, 0, 255);
            noStroke();
            fill(0, constrain(fadeAmt, 0, 255));
            rect(0, 0, width*3, height*3);
        }
    }
}