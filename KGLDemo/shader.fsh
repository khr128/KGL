#version 150

uniform sampler2D tex; //this is the texture
in vec4 vertexColor;

out vec4 fragColor;

void main (void) {
  fragColor = vertexColor;
}