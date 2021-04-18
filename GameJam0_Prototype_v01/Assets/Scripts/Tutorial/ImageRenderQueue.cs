using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ImageRenderQueue : MonoBehaviour
{
    Image img;
    TextMeshProUGUI text;

    // Start is called before the first frame update
    void Start()
    {
        img = GetComponent<Image>();
        img.material.renderQueue = 3001;

        text = GetComponentInChildren<TextMeshProUGUI>();
        text.fontMaterial.renderQueue = 3001;
    }

}
