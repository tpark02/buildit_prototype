using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

public class PrefabManager : MonoBehaviour
{
    //public static Dictionary<string, GameObject> allPrefabDic = new Dictionary<string, GameObject>();
    
    public static Action clearObjectPanelCallBack;
    public static Action<GameObject> setObjectButtonToContentCallBack;
    public GameObject objectButton;
    // Prefab
    public GameObject[] furniturePrefabs;
    public GameObject[] naturePrefabs;
    public GameObject[] buildingPrefabs;
    public GameObject[] propPrefabs;
    public GameObject[] tilePrefabs;

    // Sprite (Icons)
    [SerializeField] private Sprite[] furnitureSpriteArr;
    [SerializeField] private Sprite[] natureSpriteArr;
    [SerializeField] private Sprite[] buildingSpriteArr;
    [SerializeField] private Sprite[] propSpriteArr;
    [SerializeField] private Sprite[] tileSpriteArr;

    [HideInInspector] public static int selectedCategoryIdx = 0;
    [HideInInspector] public static int selectedObjectIdx = 0;

    private string[] furnitureNameArr =
    {
        "Bench 1", 
        "Bench 2", 
        "Bench 3", 
        "Chair 1", 
        "Chair 2", 
        "Chair 3", 
        "Table"
    };
    private string[] natureNameArr =
    {
        "Tree 1", 
        "Tree 2", 
        "Tree 3", 
        "Grass 1", 
        "Grass 2", 
        "Grass 3", 
        "Flower 1", 
        "Flower 2", 
        "Flower 3", 
        "Stone 1", 
        "Stone 2"
    };
    private string[] buildingNameArr =
    {
        "Alcove", 
        "Archway", 
        "Playground 1", 
        "Playground 2", 
        "Playground 3", 
        "Playground 4", 
        "Playground 5"
    };
    private string[] propNameArr =
    {
        "Border 1",
        "Border 40",
        "Border 100",
        "Border 200",
        "Lamp",
        "Railing 1",
        "Railing 2",
        "Railing Angles",
        "CrossBar",
        "Sandbox 1",
        "Sandbox 2",
        "Sandbox 3",
        "Stairs",
        "Stand 1",
        "Stand 2",
        "Swing 1",
        "Swing 2",
        "Swing 3",
        "Swing 4",
        "Toy 1",
        "Toy 2",
        "Toy 3",
        "Toy 4",
        "Toy 5",
        "Toy 6",
        "Toy 7",
        "Toy 8",
        "Trash 1",
        "Trash 2",
        "Trash 3",
        "Tube"
    };

    private string[] tileNameArr =
    {
        "Grass"
    };
    private GameObject[] prefabArr = null;
    private string[] nameArr = null;
    private Sprite[] sprArr = null;
    private bool isBuilding = false;

    private static PrefabManager instance;

    void Awake()
    {
        CategorySelectPanelController.initObjectButtonSpriteArrCallback += (int idx) => {
            Debug.Log("<color=yellow> CallBack : PrefabManager.cs : " + idx.ToString() + "</color>");
            clearObjectPanelCallBack();
            CreateObjectButton(idx);
        };

        DontDestroyOnLoad(gameObject);

        if (instance == null)
        {
            instance = this;
        }
        else
        {
            DestroyObject(gameObject);
        }
    }

    void Start()
    {
        MenuPopupController.destroyPrefabManagerObjectsCallBack = DestroyPrefabManagerObjects;
    }
    public void DestroyPrefabManagerObjects()
    {
        foreach(Transform v in transform)
            Destroy(v.gameObject);
    }
    public void Update()
    {
        if (SceneManager.GetActiveScene().buildIndex == 1) return;
        if (SelectToggleController.isSelectOn) return;
        if (Input.GetMouseButtonDown(0) && !EventSystem.current.IsPointerOverGameObject())
            PutObject(Input.mousePosition);
    }
    public void PutObject(Vector2 mousePosition)
    {
        RaycastHit hit = RayFromCamera(mousePosition, 1000.0f);

        if (hit.point.y <= 0f) hit.point = new Vector3(hit.point.x, 0f, hit.point.z);
        if (isBuilding) hit.point = new Vector3(hit.point.x, 0.5f, hit.point.z);
        Instantiate(prefabArr[selectedObjectIdx], hit.point, Quaternion.identity).transform.parent = transform;
    }
    public RaycastHit RayFromCamera(Vector3 mousePosition, float rayLength)
    {
        RaycastHit hit;
        {
            Ray ray = Camera.main.ScreenPointToRay(mousePosition);
            Physics.Raycast(ray, out hit, rayLength);
        }
        return hit;
    }
    public void CreateObjectButton(int idx)
    {
        selectedCategoryIdx = idx;
        isBuilding = false;

        var len = 0;
        if (idx == 0) len = CopyObjectData(furnitureNameArr, furnitureSpriteArr, furniturePrefabs);
        else if (idx == 1) len = CopyObjectData(natureNameArr, natureSpriteArr, naturePrefabs);
        else if (idx == 2)
        {
            len = CopyObjectData(buildingNameArr, buildingSpriteArr, buildingPrefabs);
            isBuilding = true;
        }
        else if (idx == 3) len = CopyObjectData(propNameArr, propSpriteArr, propPrefabs);
        else if (idx == 4)
        {
            len = CopyObjectData(tileNameArr, tileSpriteArr, tilePrefabs);
            isBuilding = true;
        }

        for (int i = 0; i < len; i++)
        {
            var o = Instantiate(objectButton).GetComponent<ObjectButtonController>();
            {
                o.Index = i;
                o.Name = nameArr[i];
                o.Icon = sprArr[i];
            }
            setObjectButtonToContentCallBack(o.gameObject);
        }
    }

    private int CopyObjectData(String[] strSrc, Sprite[] sprSrc, GameObject[] objSrc)
    {
        var len = 0;
        len = strSrc.Length;
        nameArr = new string[len];
        strSrc.CopyTo(nameArr, 0);

        len = sprSrc.Length;
        sprArr = new Sprite[len];
        sprSrc.CopyTo(sprArr, 0);

        len = objSrc.Length;
        prefabArr = new GameObject[len];
        objSrc.CopyTo(prefabArr, 0);

        return len;
    }

    void OnDestroy()
    {
        selectedCategoryIdx = 0;
        selectedObjectIdx = 0;
    }
}
