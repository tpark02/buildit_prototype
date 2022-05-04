using System;
using UnityEngine;


public class CategorySelectPanelController : MonoBehaviour
{
    public static Action<int> initObjectButtonSpriteArrCallback;

    void Start()
    {
        OnClickCategorySelectButton(0);
        MenuPopupController.quitCallBack = OnClickQuitButton;
    }
    public void OnClickCategorySelectButton(int index)
    {
        Debug.Log("<color=yellow>Category Select Button Clicked !</color>");
        initObjectButtonSpriteArrCallback(index);
    }

    public void OnClickQuitButton()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#elif UNITY_WEBPLAYER
         Application.OpenURL(webplayerQuitURL);
#else
         Application.Quit();
#endif
    }
}
