Shader "Unlit/Line_Shad"
{
     Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture",2D) = "white" {}

        _Start("Start", float) = 0.5
        _Width("Width", float) = 0.5
        
    }
    SubShader
    {
        
        tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True" 
        }
        
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM 
            
            float drawLine(float2 uv, float start, float end){
                if((uv.x > start)&&(uv.x < end)){
                    return 1;
                }
                return 0;
            }

            #pragma vertex vert
            #pragma fragment frag

            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            uniform float _Start;
            uniform float _Width;

            struct VertexInput{
                float4 vertex: POSITION;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput{
                float4  pos: SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };
            
            VertexOutput vert(VertexInput v){
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                o.texcoord.zw = 0;
                return o;
            }

            half4 frag(VertexOutput i): COLOR{
                float4 color = tex2D(_MainTex,i.texcoord) * _Color;
                color.a = drawLine(i.texcoord.xy, _Start, _Width);
                return color;
            }

            ENDCG
        }
    }
}
