// USEFUL CODE
// ------------------------------------------------------------
//
// DEFINITIONS OF PI AND TAU
// ------------------------------------------------------------
// #define M_PI 3.1415926535897932384626433832795
// #define M_TAU 6.2831853071795864769252867665590
//
// CENTERING COORDINATE SPACE
// ------------------------------------------------------------
// ???
//
// REMAPPING FUNCTION FOR GLSL
// ------------------------------------------------------------
// low2 + (value - low1) * (high2 - low2) / (high1 - low1)
//
// highp float map(highp float value, highp float low1, highp float high1, highp float low2, highp float high2) {
//     return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
// }
//
// CONVERTS FROM RANGE [0,1] TO [-1,1]
// ------------------------------------------------------------
// highp vec2 normCoord = 2.0 * textureCoordinate - 1.0;
// highp vec2 normCenter = 2.0 * center - 1.0;
//
// USE POLAR COORDINATES INSTEAD OF CARTESIAN
// ------------------------------------------------------------
// vec2 toCenter = vec2(0.5) - textureCoordinate;
// float angle = atan(toCenter.y,toCenter.x);
// float radius = length(toCenter)*2.0;
//
// MATRIX FOR ROTATION
// ------------------------------------------------------------
// ???
//
// MATRIX FOR SHEAR
// ------------------------------------------------------------
// ???
//
// BRESENHAM'S LINE ALGORITHM
// ------------------------------------------------------------
// void line(x0, y0, x1, y1) {
//     float deltax = x1 - x0;
//     float deltay = y1 - y0;
//     float error = 0;
//     float deltaerr = abs(deltay / deltax)
//     // Assume deltax != 0 (line is not vertical),
//     // note that this division needs to be done in a way
//     // that preserves the fractional part
//     int y = y0;
//     for (int x = x0; x ++; x <= x1) {
//             plot(x,y)
//         error = error + deltaerr
//         while (error ≥ 0.5) {
//             plot(x, y);
//             y = y + sign(y1 - y0)
//             error := error - 1.0
//         }
// }
//
// FAST RGB TO HSV CONVERSION
// ------------------------------------------------------------
// vec3 rgb2hsv(vec3 c)
// {
//     vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
//     vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
//     vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
//
//     float d = q.x - min(q.w, q.y);
//     float e = 1.0e-10;
//     return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
// }
// SOURCE: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
//
//
// FAST HSV TO RGB CONVERSION
// ------------------------------------------------------------
// vec3 hsv2rgb(vec3 c)
// {
//     vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
//     vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
//     return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
// }
// SOURCE: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
//
//
// REINHARD TONEMAPPING
// ------------------------------------------------------------
// Based on Filmic Tonemapping Operators http://filmicgames.com/archives/75
//
// vec3 tonemapReinhard(vec3 color) {
//     return color / (color + vec3(1.0));
// }
//
// CLASSIC PERLIN NOISE
// ------------------------------------------------------------
// Classic Perlin noise
//float cnoise(vec2 P)
//{
//    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
//    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
//    Pi = mod289(Pi); // To avoid truncation effects in permutation
//    vec4 ix = Pi.xzxz;
//    vec4 iy = Pi.yyww;
//    vec4 fx = Pf.xzxz;
//    vec4 fy = Pf.yyww;
//    
//    vec4 i = permute(permute(ix) + iy);
//    
//    vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
//    vec4 gy = abs(gx) - 0.5 ;
//    vec4 tx = floor(gx + 0.5);
//    gx = gx - tx;
//    
//    vec2 g00 = vec2(gx.x,gy.x);
//    vec2 g10 = vec2(gx.y,gy.y);
//    vec2 g01 = vec2(gx.z,gy.z);
//    vec2 g11 = vec2(gx.w,gy.w);
//    
//    vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
//    g00 *= norm.x;
//    g01 *= norm.y;
//    g10 *= norm.z;
//    g11 *= norm.w;
//    
//    float n00 = dot(g00, vec2(fx.x, fy.x));
//    float n10 = dot(g10, vec2(fx.y, fy.y));
//    float n01 = dot(g01, vec2(fx.z, fy.z));
//    float n11 = dot(g11, vec2(fx.w, fy.w));
//    
//    vec2 fade_xy = fade(Pf.xy);
//    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
//    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
//    return 2.3 * n_xy;
//}
// SOURCE: http://indieambitions.com/idevblogaday/perlin-noise-gpu-gpuimage/

#define M_PI 3.1415926535897932384626433832795

precision highp float;

varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

//uniform lowp float parameter;
uniform highp float time;
uniform highp vec2 center;
// Classic Perlin noise


float fractionalWidthOfPixel;
float scale;

// Description : Array and textureless GLSL 2D/3D/4D simplex
// noise functions.
// Author : Ian McEwan, Ashima Arts.
// Maintainer : ijm
// Lastmod : 20110822 (ijm)
// License : Copyright (C) 2011 Ashima Arts. All rights reserved.
// Distributed under the MIT License. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}


vec4 mod289(vec4 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
    return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
    return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod289(Pi); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    
    vec4 i = permute(permute(ix) + iy);
    
    vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
    vec4 gy = abs(gx) - 0.5 ;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    
    vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

// 3 Dimensional Perlin Noise
float snoise(vec3 v)
{
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);
    
    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;
    
    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );
    
    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
    
    // Permutations
    i = mod289(i);
    vec4 p = permute( permute( permute(
                                       i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
                              + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
                     + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
    
    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;
    
    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
    
    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
    
    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);
    
    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );
    
    //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
    //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));
    
    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
    
    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);
    
    //Normalise gradients
    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;
    
    // Mix final noise value
    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                 dot(p2,x2), dot(p3,x3) ) );
}

// highp float map(highp float value, highp float low1, highp float high1, highp float low2, highp float high2) {
//     return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
// }


void main()
{
    highp vec2 interp = vec2(mix(.1, 2.0, center.x),
                             mix(.1, 2.0, center.y));
    highp vec2 textureCoordinateToUse = mod(vec2(textureCoordinate.x + snoise(vec3(textureCoordinate/interp.x, time/50.)), textureCoordinate.y + snoise(vec3(textureCoordinate/interp.y, time/50.))), 1.0);
   
    gl_FragColor = texture2D(inputImageTexture, textureCoordinateToUse );
    
}
