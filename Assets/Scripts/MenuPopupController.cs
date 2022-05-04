using System;
using System.Collections;
using System.IO;
using System.Xml.Serialization;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuPopupController : PopupController
{
    public static Action<GameObject, string> saveCallBack = null, loadCallBack = null;
    public static Action destroyPrefabManagerObjectsCallBack = null, quitCallBack = null;
    public Button clearButton, saveButton, loadButton, quitButton;
    public GameObject noticePopup;
    void Start()
    {
        //StartCoroutine(InitMenuPopupController());
        base.Start();
        var o = FindObjectOfType<PrefabManager>().gameObject;
#if UNITY_WEBGL
        if (SceneManager.GetActiveScene().buildIndex == 0)
        {
                clearButton.onClick.AddListener(() => { destroyPrefabManagerObjectsCallBack(); });
                saveButton.onClick.AddListener(() => 
                {
                    StartCoroutine(UploadSave(o));
                    noticePopup.GetComponent<NoticePopupController>().SetPopupMessage("Saved Successfully");
                    noticePopup.SetActive(true);
                });
                loadButton.onClick.AddListener(() => 
                {
                    StartCoroutine(DownloadSave(o));
                    noticePopup.GetComponent<NoticePopupController>().SetPopupMessage("Load Successfully");
                    noticePopup.SetActive(true);
                });
                quitButton.onClick.AddListener(() => { quitCallBack(); });
        }
#else
        if (SceneManager.GetActiveScene().buildIndex == 0)
        {
            clearButton.onClick.AddListener(() => { destroyPrefabManagerObjectsCallBack(); });
            saveButton.onClick.AddListener(() =>
            {
                saveCallBack(o, "savefile.xml");
                noticePopup.GetComponent<NoticePopupController>().SetPopupMessage("Saved Successfully");
                noticePopup.SetActive(true);
            });
            loadButton.onClick.AddListener(() =>
            {
                loadCallBack(o, "savefile.xml");
                noticePopup.GetComponent<NoticePopupController>().SetPopupMessage("Load Successfully");
                noticePopup.SetActive(true);
            });
            quitButton.onClick.AddListener(() => { quitCallBack(); });
        }
#endif
    }
#if UNITY_WEBGL
    IEnumerator UploadSave(GameObject rootGameObject)
    {
        SaveLoadSystem.BuildingInfo buildingInfo = new SaveLoadSystem.BuildingInfo(rootGameObject);
        XmlSerializer serializer = new XmlSerializer(typeof(SaveLoadSystem.BuildingInfo));
        StringWriter sw = new StringWriter();
        serializer.Serialize(sw, buildingInfo);
        
        WWWForm packet = new WWWForm();
        packet.AddField("xml", sw.ToString());
        
        UnityWebRequest www = UnityWebRequest.Post("http://49.50.175.78:3000/uploads", packet);
        yield return www.SendWebRequest();

        if (www.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(www.error);
        }
        else
        {
            Debug.Log("Upload complete!");
        }
    }

    IEnumerator DownloadSave(GameObject rootGameObject)
    {
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

        loadCallBack(rootGameObject, SaveLoadSystem.xmlStr);
    }
#endif
}
