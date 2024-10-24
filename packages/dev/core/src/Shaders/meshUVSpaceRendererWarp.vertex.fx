precision highp float;

attribute vec3 position;
attribute vec3 normal;

uniform mat4 world;
uniform mat4 viewProjection;

varying vec3 vPositionW;
varying vec3 vNormalW;

void main(void) {
    vec4 worldPos = world * vec4(position, 1.0);
    vPositionW = worldPos.xyz;
    vNormalW = normalize(mat3(world) * normal);
    gl_Position = viewProjection * worldPos;
}
