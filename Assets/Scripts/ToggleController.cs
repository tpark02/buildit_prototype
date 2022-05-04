using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using Image = UnityEngine.UI.Image;

public class ToggleController : MonoBehaviour
{
    public Image On;
    public Image Off;
    private int index = 0;
    public void Start()
    {
        ON();
        //isSelectOn = false;
    }
    public void ON()
    {
        index = 1;
        Off.gameObject.SetActive(true);
        On.gameObject.SetActive(false);
        //isSelectOn = false;
    }

    public void OFF()
    {
        index = 0;
        On.gameObject.SetActive(true);
        Off.gameObject.SetActive(false);
        //isSelectOn = true;
    }
}
