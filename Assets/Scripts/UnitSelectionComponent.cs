using UnityEngine;
using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEditor;
using UnityEngine.EventSystems;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class UnitSelectionComponent : MonoBehaviour
{
    public static List<GameObject> selectedObjectsList = new List<GameObject>();
    public static Action<Vector3> setPositionCallBack = null;
    public static Action<Vector3> setRotationCallBack = null;
    public static Action<Vector3> setScaleCallBack = null;
    public static Action resetInputFieldCallBack = null;

    bool isSelecting = false;
    Vector3 mousePosition1;
    
    public GameObject selectionCirclePrefab;

    //public static List<GameObject> chosenObject = null;

    //public static List<GameObject> circledObjects = new List<GameObject>();

    private GraphicRaycaster m_Raycaster;
    private PointerEventData m_PointerEventData;
    private EventSystem m_EventSystem;

    [SerializeField] private Canvas canvas;
    void Start()
    {
        //Fetch the Raycaster from the GameObject (the Canvas)
        m_Raycaster = canvas.GetComponent<GraphicRaycaster>();
        //Fetch the Event System from the Scene
        m_EventSystem = GetComponent<EventSystem>();
    }
    void Update()
    {
        if (!SelectToggleController.isSelectOn) return;
        if (IsUIpanelTouched()) return;
        // If we press the left mouse button, begin selection and remember the location of the mouse
        if ( Input.GetMouseButtonDown( 0 ) )
        {
            if (selectedObjectsList.Count > 0)
            {
                Debug.Log("<color=red>List Clear !</color>");
                selectedObjectsList.Clear();
            }

            isSelecting = true;
            mousePosition1 = Input.mousePosition;

            foreach( var selectableObject in FindObjectsOfType<SelectableUnitComponent>() )
            {
                if( selectableObject.selectionCircle != null )
                {
                    Destroy( selectableObject.selectionCircle.gameObject );
                    selectableObject.selectionCircle = null;
                }
            }
        }
        // If we let go of the left mouse button, end selection
        if( Input.GetMouseButtonUp( 0 ) )
        {
            var selectedObjects = new List<SelectableUnitComponent>();
            foreach( var selectableObject in FindObjectsOfType<SelectableUnitComponent>() )
            {
                if (selectableObject.gameObject.name.Equals("SM_Box_Ground_01")) continue;
                
                if( IsWithinSelectionBounds( selectableObject.gameObject ) )
                {
                    selectedObjects.Add( selectableObject );
                    selectedObjectsList.Add( selectableObject.gameObject );
                }
            }

            var sb = new StringBuilder();
            sb.AppendLine( string.Format( "Selecting [{0}] Units", selectedObjects.Count ) );
            foreach( var selectedObject in selectedObjects )
                sb.AppendLine( "-> " + selectedObject.gameObject.name );
            Debug.Log( sb.ToString() );

            isSelecting = false;
            
            //chosenObject.Clear();

            if (selectedObjectsList.Count > 1)
            {
                XYZPanelController.isMultiSelect = true;
                resetInputFieldCallBack();
            }
            else if (selectedObjectsList.Count == 1)
            {
                XYZPanelController.isMultiSelect = false;

                if (selectedObjects[0] != null)
                {
                    setPositionCallBack(selectedObjects[0].transform.position);
                    setRotationCallBack(selectedObjects[0].transform.localEulerAngles);
                    setScaleCallBack(selectedObjects[0].transform.localScale);
                }
            }
        }

        // Highlight all objects within the selection box
        if( isSelecting )
        {
            foreach( var selectableObject in FindObjectsOfType<SelectableUnitComponent>() )
            {
                if( IsWithinSelectionBounds( selectableObject.gameObject ) )
                {
                    if( selectableObject.selectionCircle == null )
                    {
                        selectableObject.selectionCircle = Instantiate( selectionCirclePrefab );
                        selectableObject.selectionCircle.transform.SetParent( selectableObject.transform, false );
                        selectableObject.selectionCircle.transform.eulerAngles = new Vector3( 90, 0, 0 );
                    }
                }
                else
                {
                    if( selectableObject.selectionCircle != null )
                    {
                        Destroy( selectableObject.selectionCircle.gameObject );
                        selectableObject.selectionCircle = null;
                    }
                }
            }
        }

        if (Input.GetKeyDown(KeyCode.Delete))
        {
            if (selectedObjectsList.Count >= 1)
            {
                foreach (var o in selectedObjectsList)
                {
                    Destroy(o);
                }
            }
        }
    }
    public bool IsWithinSelectionBounds( GameObject gameObject )
    {
        if( !isSelecting )
            return false;

        var camera = Camera.main;
        var viewportBounds = Utils.GetViewportBounds( camera, mousePosition1, Input.mousePosition );
        return viewportBounds.Contains( camera.WorldToViewportPoint( gameObject.transform.position ) );
    }

    void OnGUI()
    {
        if( isSelecting )
        {
            // Create a rect from both mouse positions
            var rect = Utils.GetScreenRect( mousePosition1, Input.mousePosition );
            Utils.DrawScreenRect( rect, new Color( 0.8f, 0.8f, 0.95f, 0.25f ) );
            Utils.DrawScreenRectBorder( rect, 2, new Color( 0.8f, 0.8f, 0.95f ) );
        }
    }

    public static void SetXYZPosition(string x, string y, string z)
    {
        if (selectedObjectsList.Count <= 0) return;

        float _x = 0f;
        float _y = 0f;
        float _z = 0f;

        foreach (var o in selectedObjectsList)
        {
            var pos = o.transform.position;
            if (!x.Equals("--"))
                _x = float.Parse(x);
            else
                _x = pos.x;

            if (!y.Equals("--"))
                _y = float.Parse(y);
            else
                _y = pos.y;

            if (!z.Equals("--"))
                _z = float.Parse(z);
            else
                _z = pos.z;

            o.transform.position = new Vector3(_x, _y, _z);
        }
    }

    public static void SetXYZRotation(string x, string y, string z)
    {
        if (selectedObjectsList.Count <= 0) return;

        float _x = 0f;
        float _y = 0f;
        float _z = 0f;

        foreach (var o in selectedObjectsList)
        {
            var pos = o.transform.position;
            if (!x.Equals("--"))
                _x = float.Parse(x);
            else
                _x = pos.x;

            if (!y.Equals("--"))
                _y = float.Parse(y);
            else
                _y = pos.y;

            if (!z.Equals("--"))
                _z = float.Parse(z);
            else
                _z = pos.z;

            o.transform.rotation = Quaternion.Euler(_x, _y, _z);
        }
    }

    public static void SetXYZScale(string x, string y, string z)
    {
        if (selectedObjectsList.Count <= 0) return;

        float _x = 0f;
        float _y = 0f;
        float _z = 0f;

        foreach (var o in selectedObjectsList)
        {
            var pos = o.transform.position;

            if (!x.Equals("--"))
                _x = float.Parse(x);
            else
                _x = pos.x;
            
            if (!y.Equals("--"))
                _y = float.Parse(y);
            else
                _y = pos.y;

            if (!z.Equals("--"))
                _z = float.Parse(z);
            else
                _z = pos.z;

            o.transform.localScale = new Vector3(_x, _y, _z);
        }
    }

    private bool IsUIpanelTouched()
    {
        //Set up the new Pointer Event
        m_PointerEventData = new PointerEventData(m_EventSystem);
        //Set the Pointer Event Position to that of the mouse position
        m_PointerEventData.position = Input.mousePosition;

        //Create a list of Raycast Results
        List<RaycastResult> results = new List<RaycastResult>();

        //Raycast using the Graphics Raycaster and mouse click position
        m_Raycaster.Raycast(m_PointerEventData, results);

        //For every result returned, output the name of the GameObject on the Canvas hit by the Ray
        foreach (RaycastResult result in results)
        {
            //Debug.Log("<color=yellow>Hit " + result.gameObject.name + "</color>");

            foreach (Transform uiPanel in canvas.transform)
            {
                if (uiPanel.gameObject.name.Equals(result.gameObject.name))
                {
                    //Debug.Log("<color=blue>" + uiPanel.gameObject.name + "</color>");
                    return true;
                }
            }
        }
        
        return false;
    }
    void OnDestroy()
    {
        selectedObjectsList.Clear();
        setPositionCallBack = null;
        setRotationCallBack = null;
        setScaleCallBack = null;
        resetInputFieldCallBack = null;
    }
}