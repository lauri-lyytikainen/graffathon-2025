// metallic.vert
#version 150

in vec4 position;
in vec3 normal;

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

out vec3 vNormal;
out vec3 vPosition;

void main() {
    vNormal = normalize(normalMatrix * normal);
    vPosition = vec3(modelview * position);
    gl_Position = transform * position;
}