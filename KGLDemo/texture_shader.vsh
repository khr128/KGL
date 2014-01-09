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
  float spotTightness;
  float spotRadius;
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
in vec2 texCoords;

out vec4 vertexColor;
out vec2 fragTexCoords;

float ShininessPowerFactor(float nDotVP, float nDotHV) {
  if (nDotVP == 0.0) {
    return 0.0;
  } else {
    return pow(nDotHV, Material.shininess);
  }
}

void DirectionalLight(const in int i,
                      const in vec3 normal,
                      inout vec4 ambient,
                      inout vec4 diffuse,
                      inout vec4 specular)
{
  float nDotVP;
  float nDotHV;
  float powerFactor;
  vec3 VP;
  
  VP = normalize(vec3(LightSource[i].position));
  nDotVP = max(0.0, dot(normal, VP));
  nDotHV = max(0.0, dot(normal, vec3(LightSource[i].halfVector)));
  
  powerFactor = ShininessPowerFactor(nDotVP, nDotHV);
  
  ambient += LightSource[i].ambient;
  diffuse += LightSource[i].diffuse *nDotVP;
  specular += LightSource[i].specular * powerFactor;
}

float Attenuate(const in int i, const in float d) {
  return 2.0 / (LightSource[i].attenuation0 + pow(d/LightSource[i].attenuation1, LightSource[i].attenuation2));
}

void PointLight(const in int i,
                const in vec3 eye,
                const in vec3 ecPosition3,
                const in vec3 normal,
                inout vec4 ambient,
                inout vec4 diffuse,
                inout vec4 specular)
{
  float powerFactor;
  float attenuation;
  float d;
  vec3 VP;
  float nDotVP;
  vec3 halfVector;
  float nDotHV;
  
  VP = vec3(LightSource[i].position) - ecPosition3;
  d = length(VP);
  VP = normalize(VP);
  nDotVP = max(0.0, dot(normal, VP));
  
  halfVector = normalize(VP + eye);
  nDotHV = max(0.0, dot(normal, halfVector));

  powerFactor = ShininessPowerFactor(nDotVP, nDotHV);
  attenuation = Attenuate(i, d);
  
  ambient += LightSource[i].ambient * attenuation;
  diffuse += LightSource[i].diffuse * nDotVP * attenuation;
  specular += LightSource[i].specular * powerFactor * attenuation;
}

float SpotAttenuation(const in int i, const in vec3 VP) {
  const float PIH = 3.14159265358979323846264/2;
  //Is it inside the cone?
  float spotDot, angle, cutoffAngle, radiusAngle;
  spotDot = dot(-VP, normalize(LightSource[i].spotDirection));
  angle = acos(spotDot);
  cutoffAngle = acos(LightSource[i].spotCosCutoff);
  radiusAngle = PIH*LightSource[i].spotRadius/90.0;
  
  float attenuation;
  attenuation = 1;
  if (spotDot <= LightSource[i].spotCosCutoff) {
    attenuation = 0.0;
  } else if (LightSource[i].spotCosCutoff < spotDot && angle > radiusAngle) {
    attenuation = cos(PIH*(angle - radiusAngle)/(cutoffAngle - radiusAngle));
  }

  return attenuation*cos(PIH*angle/cutoffAngle)*exp(-LightSource[i].spotTightness*angle);
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
  float attenuation;
  float d;
  vec3 VP;
  vec3 halfVector;
  
  VP = vec3(LightSource[i].position) - ecPosition3;
  d = length(VP);
  VP = normalize(VP);
  nDotVP = max(0.0, dot(normal, VP));
  
  halfVector = normalize(VP + eye);
  nDotHV = max(0.0, dot(normal, halfVector));
  
  attenuation = Attenuate(i, d)*SpotAttenuation(i, VP);
  powerFactor = ShininessPowerFactor(nDotVP, nDotHV);
  
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
    } else if (LightSource[i].spotRadius == 180.0) {
      PointLight(i, viewVec, ecPosition, eyeNormal, amb, diff, spec);
    } else {
      SpotLight(i, viewVec, ecPosition, eyeNormal, amb, diff, spec);
    }
  }
    
  vertexColor = min(Material.emissive + amb * Material.ambient + diff * Material.diffuse + spec * Material.specular, 1.0);
  fragTexCoords = texCoords;
  
  gl_Position = modelViewProjectionMatrix * inPosition;
}