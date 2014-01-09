#version 150

uniform sampler2D tex; //this is the texture
in vec4 vertexColor;
in vec2 fragTexCoords; //this is the texture coord

out vec4 fragColor;

void main (void) {
  vec4 textureColor;
  textureColor = texture(tex, fragTexCoords);
  fragColor = textureColor*vertexColor;
}