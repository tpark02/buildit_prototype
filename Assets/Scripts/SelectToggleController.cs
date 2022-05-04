using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelectToggleController : ToggleController
{
    public static bool isSelectOn = false;

    // Start is called before the first frame update
    void Start()
    {
        ON();
        isSelectOn = false;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void ON()
    {
        base.ON();
        isSelectOn = false;
    }

    public void OFF()
    {
        base.OFF();
        isSelectOn = true;
    }
}
