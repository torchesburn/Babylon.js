precision highp float;

// Vertex attributes
attribute vec3 position; // The position of the vertex
attribute vec2 uv; // The UV coordinate of the vertex

// Matrices
uniform mat4 worldViewProjection; // Combined world-view-projection matrix
uniform mat4 decalProjection; // Projection matrix for the decal
uniform mat4 decalTransform; // Transformation matrix for the decal
uniform mat4 world; // World matrix for the model

// Varying to pass data to the fragment shader
varying vec2 vUV; // Pass the UV coordinate to the fragment shader
varying vec3 vDecalPos; // Pass the transformed position for the decal

void main(void) {
    vUV = uv;

    // Transform the vertex position to world space
    vec4 worldPosition = world * vec4(position, 1.0);

    // Apply the decal projection and transformation
    vDecalPos = (decalTransform * decalProjection * worldPosition).xyz;

    // Compute the final position of the vertex in clip space
    gl_Position = worldViewProjection * vec4(position, 1.0);
}
