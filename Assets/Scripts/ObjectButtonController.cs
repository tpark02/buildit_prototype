using System.Collections;
using System.Collections.Generic;
using System.Net.Mime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ObjectButtonController : MonoBehaviour
{
    private int index = 0;

    public int Index
    {
        get => index;
        set => index = value;
    }
    [SerializeField] private TextMeshProUGUI text;

    public string Name
    {
        get => text.text;
        set => text.text = value;
    }
    [SerializeField] private Image icon;

    public Sprite Icon
    {
        get => icon.sprite;
        set => icon.sprite = value;
    }
    public void OnClickObjectButton()
    {
        Debug.Log("<color=yellow>Object Button Clicked !</color>");
        PrefabManager.selectedObjectIdx = index;
    }
}
