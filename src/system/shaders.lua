local shader = {}
shader.blue = love.graphics.newShader([[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 pixel = Texel(texture, texture_coords);
        float grey = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
        return vec4(grey, pixel.g + 0.5, pixel.b + 0.5, pixel.a);
    }
]])
shader.focus = love.graphics.newShader([[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 pixel = Texel(texture, texture_coords);
        float grey = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
        return vec4(grey, grey, grey, pixel.a);
    }
]])
shader.focusAnim = love.graphics.newShader([[
    extern vec2 circleCenter;
    extern number circleRadius;
    
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        number distance = length(screen_coords - circleCenter);
        
        if (distance > circleRadius) {
            return color;
        }
        
        number fadeFactor = 1.0 - (distance / circleRadius);
        
        fadeFactor = 1.0 - fadeFactor;
        
        return color * fadeFactor;
    }
]])
shader.focusAnim:send("circleCenter", {0, 0})
shader.focusAnim:send("circleRadius", 0)
shader.light = love.graphics.newShader([[
    #define MAX_LIGHTS 3

extern number ellipseXScale;
extern number ellipseYScale;
extern vec2 lightPositions[MAX_LIGHTS];
extern number lightRadii[MAX_LIGHTS];
extern int numLights;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    if (numLights == 0) {
        return color;
    }

    number totalFade = 1.0;
    
    for (int i = 0; i < MAX_LIGHTS; i++) {
        if (i >= numLights) {
            break;
        }

        vec2 ellipseCenter = lightPositions[i];
        vec2 ellipseScale = vec2(ellipseXScale, ellipseYScale);

        vec2 delta = (screen_coords - ellipseCenter) / ellipseScale;
        number distance = length(delta);
        
        // There is no longer a circle radius comparison
        
        number fadeFactor = 1.0 - (distance / lightRadii[i]);
        fadeFactor = max(fadeFactor, 0.0);
        fadeFactor = 1.0 - fadeFactor;
        
        totalFade *= fadeFactor;
    }

    return color * totalFade;
}
]])

return shader