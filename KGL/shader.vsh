#version 150

struct material {
  vec4 emissive;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};

struct light {
  vec4 position;
  vec4 halfVector;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  
  float attenuation0;
  float attenuation1;
  float attenuation2;
  
  vec3 spotDirection;
  float spotExponent;
  float spotCutoff;  
  float spotCosCutoff;  
};

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

uniform material Material;

uniform int NumEnabledLights;
uniform light LightSource[8];

in vec4 inPosition;
in vec3 normal;

out vec4 vertexColor;

void DirectionalLight(const in int i,
                      const in vec3 normal,
                      inout vec4 ambient,
                      inout vec4 diffuse,
                      inout vec4 specular)
{
  float nDotVP;
  float nDotHV;
  float powerFactor;
  
  nDotVP = max(0.0, dot(normal, normalize(vec3(LightSource[i].position))));
  nDotHV = max(0.0, dot(normal, vec3(LightSource[i].halfVector)));
  
  if (nDotVP == 0.0) {
    powerFactor = 0.0;
  } else {
    powerFactor = pow(nDotHV, Material.shininess);
  }
  
  ambient += LightSource[i].ambient;
  diffuse += LightSource[i].diffuse *nDotVP;
  specular += LightSource[i].specular * powerFactor;
}

void PointLight(const in int i,
                const in vec3 eye,
                const in vec3 ecPosition3,
                const in vec3 normal,
                inout vec4 ambient,
                inout vec4 diffuse,
                inout vec4 specular)
{
  float nDotVP;
  float nDotHV;
  float powerFactor;
  float attenuation;
  float d;
  vec3 VP;
  vec3 halfVector;
  
  VP = vec3(LightSource[i].position) - ecPosition3;
  d = length(VP);
  VP = normalize(VP);
  
  attenuation = 1.0 / (LightSource[i].attenuation0 +
                       LightSource[i].attenuation1*d +
                       LightSource[i].attenuation2*d*d);
  
  halfVector = normalize(VP + eye);
  nDotVP = max(0.0, dot(normal, VP));
  nDotHV = max(0.0, dot(normal, halfVector));
  
  if (nDotVP == 0.0) {
    powerFactor = 0.0;
  } else {
    powerFactor = pow(nDotHV, Material.shininess);
  }
  
  ambient += LightSource[i].ambient * attenuation;
  diffuse += LightSource[i].diffuse * nDotVP * attenuation;
  specular += LightSource[i].specular * powerFactor * attenuation;
}

void SpotLight(const in int i,
                const in vec3 eye,
                const in vec3 ecPosition3,
                const in vec3 normal,
                inout vec4 ambient,
                inout vec4 diffuse,
                inout vec4 specular)
{
  float nDotVP;
  float nDotHV;
  float powerFactor;
  float spotDot;
  float spotAttenuation;
  float attenuation;
  float d;
  vec3 VP;
  vec3 halfVector;
  
  VP = vec3(LightSource[i].position) - ecPosition3;
  d = length(VP);
  VP = normalize(VP);
  
  attenuation = 1.0 / (LightSource[i].attenuation0 +
                       LightSource[i].attenuation1*d +
                       LightSource[i].attenuation2*d*d);
  
  //Is it inside the cone?
  spotDot = dot(-VP, normalize(LightSource[i].spotDirection));
  if (spotDot < LightSource[i].spotCosCutoff) {
    spotAttenuation = 0.0;
  } else {
    spotAttenuation = pow(spotDot, LightSource[i].spotExponent);
  }
  
  attenuation *= spotAttenuation;
  
  halfVector = normalize(VP + eye);
  nDotVP = max(0.0, dot(normal, VP));
  nDotHV = max(0.0, dot(normal, halfVector));
  
  if (nDotVP == 0.0) {
    powerFactor = 0.0;
  } else {
    powerFactor = pow(nDotHV, Material.shininess);
  }
  
  ambient += LightSource[i].ambient * attenuation;
  diffuse += LightSource[i].diffuse * nDotVP * attenuation;
  specular += LightSource[i].specular * powerFactor * attenuation;
}                

void main (void) {
  vec3 eyeNormal = normalize(normalMatrix * normal);
  vec4 ecPosition4 = modelViewMatrix * inPosition;
  vec3 ecPosition = vec3(ecPosition4)/ecPosition4.w;
  vec3 viewVec = -normalize(ecPosition);
  
  vec4 amb = vec4(0.0);
  vec4 diff = vec4(0.0);
  vec4 spec = vec4(0.0);
  
  for (int i=0; i < NumEnabledLights; ++i) {
    if (LightSource[i].position.w == 0.0) {
      DirectionalLight(i, eyeNormal, amb, diff, spec);
    } else if (LightSource[i].spotCutoff == 180.0) {
      PointLight(i, viewVec, ecPosition, eyeNormal, amb, diff, spec);
    } else {
      SpotLight(i, viewVec, ecPosition, eyeNormal, amb, diff, spec);
    }
  }
    
  vertexColor = min(Material.emissive + amb * Material.ambient + diff * Material.diffuse + spec * Material.specular, 1.0);
  
  gl_Position = modelViewProjectionMatrix * inPosition;
}