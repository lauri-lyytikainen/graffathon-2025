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

        // --- White boxes with black letters ---
        String[] baseTexts = {"Evolution", "Todo & Nora", "Graffathon_2025"};
        // Use smaller box size for small windows
        float minDim = min(width, height);
        float boxW = constrain(width * 0.4, 120, minDim * 0.9);
        float boxH = constrain(height * 0.10, 32, minDim * 0.25);
        float marginX = width * 0.05;
        float marginY = height * 0.05;
        float[][] boxPositions = {
            { constrain(width * 0.25 - boxW/2, marginX, width - boxW - marginX), constrain(height * 0.18 - boxH/2, marginY, height - boxH - marginY) }, // top center
            { constrain(width * 0.5 - boxW/2, marginX, width - boxW - marginX), constrain(height * 0.5 - boxH/2, marginY, height - boxH - marginY) },  // middle center
            { constrain(width * 0.75 - boxW/2, marginX, width - boxW - marginX), constrain(height * 0.82 - boxH/2, marginY, height - boxH - marginY) }  // bottom center
        };
        String[] symbols = {"#", "@", "*", "-", "+", "=", "%", "^", "~"};
        for (int i = 0; i < 3; i++) {
            // Generate random number and symbol suffix
            int num = int(abs(sin(time + i) * 999));
            String symbol = symbols[(i + int(time * 2)) % symbols.length];
            String text = baseTexts[i] + "-" + num + symbol;
            // Reduce movement for small windows
            float moveScale = map(minDim, 120, 600, 2, 12);
            moveScale = constrain(moveScale, 2, 12);
            float moveX = sin(time * 1.2 + i) * moveScale + cos(time * 0.7 + i * 2) * (moveScale * 0.6);
            float moveY = cos(time * 1.1 + i * 1.5) * (moveScale * 0.8) + sin(time * 0.9 + i) * (moveScale * 0.5);
            float x = constrain(boxPositions[i][0] + moveX, marginX, width - boxW - marginX);
            float y = constrain(boxPositions[i][1] + moveY, marginY, height - boxH - marginY);
            // Draw box
            noStroke();
            fill(255);
            rect(x, y, boxW, boxH);
            // Draw text
            fill(0);
            textAlign(CENTER, CENTER);

            // Dynamically fit text size to box
            float maxTxtSize = boxH * 0.5;
            float minTxtSize = 10;
            float txtSize = maxTxtSize;
            textSize(txtSize);
            // Shrink text if it overflows box width
            while (textWidth(text) > boxW * 0.92 && txtSize > minTxtSize) {
                txtSize -= 1;
                textSize(txtSize);
            }
            text(text, x + boxW/2, y + boxH/2);

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