using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PopupController : MonoBehaviour
{
    public Button openBtn, closeBtn;
    public GameObject popup;
    public TextMeshProUGUI msg;
    public void Start()
    {
        popup.SetActive(false);

        if (openBtn)
            openBtn.onClick.AddListener(() => { if (!popup.activeSelf) popup.SetActive(true) ;});
        if (closeBtn)
            closeBtn.onClick.AddListener(() => { if (popup.activeSelf) popup.SetActive(false); });
    }
}