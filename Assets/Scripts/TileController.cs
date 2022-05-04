using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileController : MonoBehaviour
{
    private Color initialColor; 
    // Start is called before the first frame update
    void Start()
    {
        initialColor = GetComponent<Renderer>().material.color;
    }
    void OnMouseOver()
    {
        GetComponent<Renderer>().material.color = new Color32(144, 85, 85, 255);
    }

    void OnMouseExit()
    {
        GetComponent<Renderer>().material.color = initialColor;
    }
}
