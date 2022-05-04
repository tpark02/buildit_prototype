using System.Collections;
using System.Collections.Generic;
using System.Xml.Serialization;
using System.IO;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class SaveLoadSystem : MonoBehaviour
{
    //public GameObject CubeContainer;
    public static string xmlStr = string.Empty;
    [SerializeField] private GameObject warningPopup;
    [SerializeField] private Button exitButton;

    void Awake()
    {
#if UNITY_WEBGL
        MenuPopupController.loadCallBack = LoadWebGL;
#else
        MenuPopupController.saveCallBack = Save;
        MenuPopupController.loadCallBack = Load;
#endif
    }

    void OnEnable()
    {
        if (exitButton)
        {
            exitButton.onClick.AddListener(() =>
            {
                StartCoroutine(LoadBuildScene());
            });
        }
    }
    IEnumerator LoadBuildScene()
    {
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(0);

        while (!asyncLoad.isDone)
        {
            yield return null;
        }
    }
    public class CubeInfo
    {
        public string prefabName;
        public Vector3 position;

        public Vector3 rotation;

        public Vector3 scale;
        //public Quaternion rotation;

        public CubeInfo()
        {
        }

        public CubeInfo(Transform cube)
        {
            prefabName = cube.name.Replace("(Clone)", string.Empty);
            position = cube.position;
            rotation = cube.eulerAngles;
            scale = cube.localScale;
            //rotation = cube.rotation;
        }
    }
    public class BuildingInfo
    { // Stores info about all the cubes.

        // $$anonymous$$ake a List holding objects of type CubeInfo
        public List<CubeInfo> cubeList;

        public BuildingInfo()
        {
            // $$anonymous$$ake a new instance of the List "cubeList"
        }

        public BuildingInfo(GameObject rootObject)
        {
            cubeList = new List<CubeInfo>();

            foreach (Transform child in rootObject.transform)
            {
                cubeList.Add(new CubeInfo(child));
                //print (child);
            }
        }

        public void reload(GameObject rootObject)
        {
            // Rebuild the cubes after loading building info:
            
            foreach (var cubeInfo in cubeList)
            {
                GameObject cube = Instantiate(Resources.Load(cubeInfo.prefabName), cubeInfo.position, Quaternion.Euler(cubeInfo.rotation.x, cubeInfo.rotation.y, cubeInfo.rotation.z)) as GameObject;
                cube.transform.localScale = cubeInfo.scale;
                cube.transform.parent = rootObject.transform;
            }
        }
    }

    void Save(GameObject rootObject, string filename)
    {
        BuildingInfo buildingInfo = new BuildingInfo(rootObject);
        XmlSerializer serializer = new XmlSerializer(typeof(BuildingInfo));
        TextWriter writer = new StreamWriter(filename);
        serializer.Serialize(writer, buildingInfo);
        writer.Close();
    }

    void Load(GameObject rootObject, string filename)
    {
        if (File.Exists(filename) == false)
        {
            warningPopup.transform.GetChild(1).GetComponent<Button>().onClick.AddListener(() =>
            {
                warningPopup.SetActive(false);
            });
            warningPopup.SetActive(true);
            return;
        }
        XmlSerializer serializer = new XmlSerializer(typeof(BuildingInfo));
        TextReader reader = new StreamReader(filename);
        BuildingInfo buildingInfo = serializer.Deserialize(reader) as BuildingInfo;
        buildingInfo.reload(rootObject);
        reader.Close();
    }

    void LoadWebGL(GameObject rootObject, string str)
    {
        XmlSerializer serializer = new XmlSerializer(typeof(BuildingInfo));
        TextReader sr = new StringReader(str);
        BuildingInfo buildingInfo = serializer.Deserialize(sr) as BuildingInfo;
        buildingInfo.reload(rootObject);
        Debug.Log("<color=blue>Load WebGL !</color>");
    }
    //void OnGUI()
    //{
    //    if (GUI.Button(new Rect(30, 60, 150, 30), "Save State"))
    //    {
    //        Save(CubeContainer, "savefile.xml");
    //    }

    //    if (GUI.Button(new Rect(30, 90, 150, 30), "Load State"))
    //    {
    //        Load(CubeContainer, "savefile.xml");
    //    }
    //}
}