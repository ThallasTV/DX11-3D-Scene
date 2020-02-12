
//
// Sprite
//

// Ensure matrices are row-major
#pragma pack_matrix(row_major)

//-----------------------------------------------------------------
// Globals
//-----------------------------------------------------------------
cbuffer modelCBuffer : register(b0) {
	float4x4			worldMatrix;
	float4x4			worldITMatrix; // Correctly transform normals to world space
};
cbuffer cameraCbuffer : register(b1) {
	float4x4			viewMatrix;
	float4x4			projMatrix;
	float4				eyePos;
}
cbuffer lightCBuffer : register(b2) {
	float4				lightVec; // w=1: Vec represents position, w=0: Vec  represents direction.
	float4				lightAmbient;
	float4				lightDiffuse;
	float4				lightSpecular;
};

cbuffer sceneCBuffer : register(b3) {
	float4				windDir;
	float				Time;
	float				grassHeight;
};


//-----------------------------------------------------------------
// Input / Output structures
//-----------------------------------------------------------------
struct vertexInputPacket {

	float3 pos : POSITION;   // in object space
	float4	colour	: COLOR;

};


struct vertexOutputPacket {

	float4 posH  : SV_POSITION;  // in clip space
	float2 texCoord  : TEXCOORD0;
	float4	colour	: COLOR;
};
//-----------------------------------------------------------------
// Vertex Shader
//-----------------------------------------------------------------
vertexOutputPacket main(vertexInputPacket vin) {
	
	float size = 1.0;//scaling factor

	float4x4 VP = mul(viewMatrix, projMatrix);

	float2x2 rotScaleMatrix;
	rotScaleMatrix[0] = worldMatrix[0].xy;
	rotScaleMatrix[1] = worldMatrix[1].xy;
	//float2 pos = mul(vin.pos.xy, rotScaleMatrix);

	vertexOutputPacket vout = (vertexOutputPacket)0;
	float3	pos = mul(float4(0,0,0, 1.0), worldMatrix).xyz;

	// Compute camera ortho normal basis to direct billboard faces towards the camera.
	// Add Code Here (Compute ortho normal basis)
	float3 look = normalize(eyePos - pos);
	float3 right = normalize(cross(float3(0, 1, 0), look));
	float3 up = cross(look, right);

	
	// Transform to world space.
	// Add Code Here (Transform particle verticies to face the camera)
	pos= pos + (posL.x*right*size) + (posL.y*up*size);

	// Transform to homogeneous clip space.
	vout.posH = mul(float4(pos, 1.0f), VP);

	//calculate texture coordinates
	vout.texCoord = float2((vin.posL.x + 1)*0.5, (vin.posL.y + 1)*0.5);
	vout.colour = vin.colour;
	return vout;

}
