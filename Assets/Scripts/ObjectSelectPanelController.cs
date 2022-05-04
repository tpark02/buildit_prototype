using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSelectPanelController : MonoBehaviour
{
    public static Action callback;
    public GameObject content;

    void Awake()
    {
        ClearObjectPanel();
    }
    void Start()
    {
        PrefabManager.setObjectButtonToContentCallBack = SetObjectButtonToContent;
        PrefabManager.clearObjectPanelCallBack = ClearObjectPanel;
    }
    public void SetObjectButtonToContent(GameObject o)
    {
        o.transform.parent = content.transform;
    }

    public void ClearObjectPanel()
    {
        foreach (Transform c in content.transform)
            Destroy(c.gameObject);
    }
}
