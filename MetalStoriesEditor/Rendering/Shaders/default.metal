//
//  linearTransition.metal
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 16.12.2020.
//

#include <metal_stdlib>
using namespace metal;

float easeInOut(float t);

kernel void linear(texture2d<half, access::read>  inTexture  [[texture(0)]],
                   texture2d<half, access::write> outTexture [[texture(1)]],
                   device const float *fractionComplete [[ buffer(0) ]],
                   uint2 gid [[thread_position_in_grid]]) {
    
    float complete = easeInOut(*fractionComplete);
    uint overlayLevel = complete * outTexture.get_height();
    half4 color;
    if (gid.y >= overlayLevel) {
        color = inTexture.read(gid);
    } else {
        //TODO: rewrite this piece to read color from input property
        color = half4(1,1,1,1);
    }
    outTexture.write(color, gid);
}

//https://github.com/nicolausYes/easing-functions/blob/master/src/easing.cpp
//also helpful https://easings.net
float easeInOut(float t) {
    if(t < 0.5) {
        t *= t;
        return 8 * t * t;
    } else {
        t = (--t) * t;
        return 1 - 8 * t * t;
    }
}
