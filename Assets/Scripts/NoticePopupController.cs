using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoticePopupController : PopupController
{
    public void SetPopupMessage(string s)
    {
        if (msg) msg.text = s;
    }
}
