using UnityEngine;
using UnityEngine.UI;

public class CanvasController : MonoBehaviour
{
    [SerializeField] private FixedJoystick joystick;
    [SerializeField] private Button jumpButton;
    void Start()
    {
#if UNITY_IOS || UNITY_ANDROID
        joystick.gameObject.SetActive(true);
        jumpButton.gameObject.SetActive(true);
#else
        joystick.gameObject.SetActive(false);
        jumpButton.gameObject.SetActive(false);
#endif   
    }
}
