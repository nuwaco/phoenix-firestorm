/** 
 * @file glowcombineF.glsl
 *
 * $LicenseInfo:firstyear=2007&license=viewerlgpl$
 * Second Life Viewer Source Code
 * Copyright (C) 2007, Linden Research, Inc.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation;
 * version 2.1 of the License only.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 * 
 * Linden Research, Inc., 945 Battery Street, San Francisco, CA  94111  USA
 * $/LicenseInfo$
 */

#ifdef DEFINE_GL_FRAGCOLOR
out vec4 frag_color;
#else
#define frag_color gl_FragColor
#endif

// <FS> Fix GLSL compatibility
//#extension GL_ARB_texture_rectangle : enable

uniform sampler2D glowMap;
uniform sampler2DRect screenMap;
uniform vec3 exo_vignette;

VARYING vec2 vary_texcoord0;
VARYING vec2 vary_texcoord1;

float saturate(float val)
{
	return clamp(val, 0, 1);
}

void main() 
{
	vec4 diff = texture2DRect(screenMap, vary_texcoord1.xy) + texture2D(glowMap, vary_texcoord0.xy);
	if (exo_vignette.x > 0)
	{
		vec2 tc = vary_texcoord0.xy - 0.5f;
		float vignette = 1 - dot(tc, tc);
		diff.rgb *= saturate(pow(mix(1, vignette * vignette * vignette * vignette * exo_vignette.z, saturate(exo_vignette.x)), exo_vignette.y));
	}
	frag_color = diff;
}
