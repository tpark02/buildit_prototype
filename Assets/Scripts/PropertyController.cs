using System.Collections;
using System.IO;
using System.Xml.Serialization;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

public class PropertyController : MonoBehaviour
{
    public Button playButton;
    private XYZPanelController positionXYZcontroller = null;
    private XYZPanelController rotationXYZcontroller = null;

    private XYZPanelController scaleXYZcontroller = null;

    //private GameObject selectedObject = null;
    void Awake()
    {
        positionXYZcontroller = transform.GetChild(0).GetChild(0).GetComponent<XYZPanelController>();
        positionXYZcontroller.xyzPanelCallBack = (string x, string y, string z) =>
        {
            UnitSelectionComponent.SetXYZPosition(x, y, z);
        };

        rotationXYZcontroller = transform.GetChild(1).GetChild(0).GetComponent<XYZPanelController>();
        rotationXYZcontroller.xyzPanelCallBack = (string x, string y, string z) =>
        {
            UnitSelectionComponent.SetXYZRotation(x, y, z);
        };

        scaleXYZcontroller = transform.GetChild(2).GetChild(0).GetComponent<XYZPanelController>();
        scaleXYZcontroller.xyzPanelCallBack = (string x, string y, string z) =>
        {
            Debug.Log("<color=yellow>" + x.ToString() + " : " + y.ToString() + " : " + z.ToString() + "</color>");
            UnitSelectionComponent.SetXYZScale(x, y, z);
        };
        playButton.onClick.AddListener(() => { StartCoroutine(LoadMoveScene()); });
    }

    void Start()
    {
        //UnitSelectionComponent.setSelectedObjectCallBack = ((g) => { selectedObject = g;});
        UnitSelectionComponent.resetInputFieldCallBack = ResetInputField;
        UnitSelectionComponent.setPositionCallBack = (v) => { positionXYZcontroller.SetInputField(v.x, v.y, v.z); };
        UnitSelectionComponent.setRotationCallBack = (v) => { rotationXYZcontroller.SetInputField(v.x, v.y, v.z); };
        UnitSelectionComponent.setScaleCallBack = (s) => { scaleXYZcontroller.SetInputField(s.x, s.y, s.z); };
    }

    public void ResetInputField()
    {
        positionXYZcontroller.ResetInputField();
        rotationXYZcontroller.ResetInputField();
        scaleXYZcontroller.ResetInputField();
    }

    IEnumerator LoadMoveScene()
    {
#if UNITY_WEBGL
        UnityWebRequest uwr = UnityWebRequest.Get("http://49.50.175.78:3000/savefile.xml");
        yield return uwr.SendWebRequest();

        if (uwr.isNetworkError)
        {
            Debug.Log("Error While Sending: " + uwr.error);
        }
        else
        {
            SaveLoadSystem.xmlStr = uwr.downloadHandler.text;
            Debug.Log("Received: " + uwr.downloadHandler.text);
        }
#endif
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(1);

        while (!asyncLoad.isDone)
        {
            yield return null;
        }
    }
}
