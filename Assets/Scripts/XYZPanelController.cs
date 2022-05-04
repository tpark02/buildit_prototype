using System;
using System.Collections.Generic;
using System.Xml.Linq;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class XYZPanelController : MonoBehaviour
{
    public Action<string, string, string> xyzPanelCallBack = null;
    
    [HideInInspector] public TMP_InputField X, Y, Z;
    private Vector3 vec = Vector3.one;
    public static bool isMultiSelect = false;

    private void SetInputFieldMultiObj(string x, string y, string z, string s)
    {
        Utils.DebugPos(x.ToString(), y.ToString(), z.ToString());
        xyzPanelCallBack(x.ToString(), y.ToString(), z.ToString());

        if (s.Equals("x"))
            X.text = x;
        if (s.Equals("y"))
            Y.text = y;
        if (s.Equals("z"))
            Z.text = z;
    }
    public void SetInputField(float x, float y, float z)
    {
        vec = new Vector3(x, y, z);
        
        xyzPanelCallBack(x.ToString(), y.ToString(), z.ToString());

        X.text = x.ToString();
        Y.text = y.ToString();
        Z.text = z.ToString();
    }
    void Start()
    {
        X = transform.Find("X").GetChild(0).GetComponent<TMP_InputField>();
        Y = transform.Find("Y").GetChild(0).GetComponent<TMP_InputField>();
        Z = transform.Find("Z").GetChild(0).GetComponent<TMP_InputField>();
            
        ResetInputField();
    }
    public void ResetInputField()
    {
        X.text = "-";
        Y.text = "-";
        Z.text = "-";
    }

    public void ChangeX(string s)
    {
        float x = 0f;
        if (!Utils.CheckNumber(s, out x)) return;

        if (isMultiSelect)
        {
            var l = UnitSelectionComponent.selectedObjectsList;
            foreach (var o in l)
            {
                var pos = o.transform.position;
                SetInputFieldMultiObj(x.ToString(), "--", "--", "x");
            }
        }
        else
        {
            SetInputField(x, vec.y, vec.z);
        }

        Debug.Log("<color=yellow> X : " + X.text + "</color>");
    }
    public void ChangeY(string s)
    {
        float y = 0f;
        if (!Utils.CheckNumber(s, out y)) return;
        
        if (isMultiSelect)
        {
            var l = UnitSelectionComponent.selectedObjectsList;
            foreach (var o in l)
            {
                var pos = o.transform.position;
                SetInputFieldMultiObj("--", y.ToString(), "--", "y");
            }
        }
        else
        {
            SetInputField(vec.x, y, vec.z);
        }

        Debug.Log("<color=yellow> Y : " + Y.text + "</color>");
    }
    public void ChangeZ(string s)
    {
        float z = 0f;
        if (!Utils.CheckNumber(s, out z)) return;
        
       
        if (isMultiSelect)
        {
            var l = UnitSelectionComponent.selectedObjectsList;
            foreach (var o in l)
            {
                var pos = o.transform.position;
                SetInputFieldMultiObj("--", "--", z.ToString(), "z");
            }
        }
        else
        {
            SetInputField(vec.x, vec.y, z);
        }

        Debug.Log("<color=yellow> Z : " + Z.text + "</color>");
    }

    void OnDestroy()
    {
        isMultiSelect = false;
    }
}
