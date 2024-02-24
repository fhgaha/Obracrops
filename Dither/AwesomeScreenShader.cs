using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Obracrops
{

    public class AwesomeScreenShader : MonoBehaviour
    {
        public Shader awesomeShader = null;
        Material m_renderMaterial;
        float step = 0.01f;

        void Start()
        {
            if (awesomeShader == null && Mat.mat == null && Mat.mat.shader == null)
            {
                Debug.LogError("awesome shader not set");
                m_renderMaterial = null;
                return;
            }
            //m_renderMaterial = new Material(awesomeShader);

            awesomeShader = Mat.mat.shader;
            m_renderMaterial = Mat.mat;
        }

        public void SetMat(Material m)
        {
            m_renderMaterial = m;
            awesomeShader = m.shader;
            Camera.main.targetTexture = null;
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            Graphics.Blit(source, destination, m_renderMaterial);
        }
        
        private void Update()
        {
            if (Input.GetKey(KeyCode.Comma))
            {
                var val = m_renderMaterial.GetFloat("_Lum");
                val -= step;
                m_renderMaterial.SetFloat("_Lum", val);
                //Debug.Log($"Comma pressed. Lum: {val}");
            }
            else if (Input.GetKey(KeyCode.Period))
            {
                var val = m_renderMaterial.GetFloat("_Lum");
                val += step;
                m_renderMaterial.SetFloat("_Lum", val);
                //Debug.Log($"Preiod presed. Lum: {val}");
            }
        }
    }
}
