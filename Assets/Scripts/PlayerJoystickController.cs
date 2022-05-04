using UnityEngine;
using UnityEngine.UI;

public class PlayerJoystickController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private float directionDampTime = 0.25f;
    [SerializeField] private Rigidbody playerRigidbody;
    [SerializeField] private Camera playerCamera;
    [SerializeField] private float speed = 20f;

    public GameObject helperObject;
    public GameObject characterObject;
    public Joystick joystick;
    public Button jumpButton;

    private Vector3 helperDirection;
    // Start is called before the first frame update
    void Start()
    {
#if !UNITY_IOS || !UNITY_ANDROID
        this.enabled = false;
        return;
#endif
        animator = GetComponent<Animator>();
        if (!animator)
        {
            Debug.LogError("PlayerAnimatorManager is Missing Animator Component", this);
        }
        jumpButton.onClick.AddListener(() =>
        {
            animator.SetBool("IsJump", true);
            //SetRootMotion(true);
        });
    }

    // Update is called once per frame
    void Update()
    {
        helperDirection = helperObject.transform.TransformDirection(Vector3.forward);

        if (!animator)
        {
            return;
        }

        if (joystick.Horizontal != 0 || joystick.Vertical != 0)
        {
            Vector3 vec = playerCamera.transform.TransformDirection(joystick.Horizontal, 0, joystick.Vertical);
            playerRigidbody.velocity = new Vector3(vec.x * speed, playerRigidbody.velocity.y, vec.z * speed);
            Debug.Log("<color=yellow>" + playerRigidbody.velocity + "</color>");
            UpdateMeshRotation();
            //SetRootMotion(false);
            animator.SetBool("IsWalk", true);
        }
        else
        {
            animator.SetBool("IsWalk", false);
        }
    }
    void UpdateMeshRotation()
    {
        Vector3 vec = transform.position - playerCamera.transform.position;

        Quaternion rotation = Quaternion.LookRotation(vec, Vector3.up) * Quaternion.LookRotation(new Vector3(joystick.Horizontal, 0f, joystick.Vertical));

        rotation.eulerAngles = new Vector3(0, rotation.eulerAngles.y, 0);

        characterObject.transform.rotation = rotation;
    }

    void OnJumpPrepareAniStart()
    {
        Debug.Log("Jump Prepare !");
        GetComponent<CapsuleCollider>().height = 1.8f;
    }
    void OnJumpAniStart()
    {
        Debug.Log("Jump Start !");
        playerRigidbody.AddForce((helperDirection * 100f) + (Vector3.up * 300f));
    }
    void OnJumpAniEnd()
    {
        Debug.Log("Jump End !");
        GetComponent<CapsuleCollider>().height = 2f;
        animator.SetBool("IsJump", false);
    }

    void SetRootMotion(bool isOn)
    {
        //animator.applyRootMotion = isOn;
        //playerRigidbody.isKinematic = isOn;
    }
}
