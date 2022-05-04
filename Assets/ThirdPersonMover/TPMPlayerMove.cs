using System.Collections;
using System.Collections.Generic;
using System.Timers;
using UnityEngine;

public class TPMPlayerMove : MonoBehaviour
{
	CharacterController controller;
    public float jumpSpeed = 8.0F;
    public float gravity = 20.0F;
    private Vector3 moveDirection = Vector3.zero;
    public float Speed;
    public GameObject helperObject;
    public Transform Cam;
    private Vector3 prevPlayerPos;
    [SerializeField] private Animator animator;
    [SerializeField] private Rigidbody myRigid;
    private Vector3 helperDirection;
    private bool isJump = false;
void Start()
	{
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
        myRigid = GetComponent<Rigidbody>();
	}

	void Update()
    {
        helperDirection = helperObject.transform.TransformDirection(Vector3.forward);

        float Horizontal = Input.GetAxis("Horizontal") * Speed * Time.deltaTime;
		float Vertical = Input.GetAxis("Vertical") * Speed * Time.deltaTime;
        
        if (IsCheckGrounded() && Input.GetKeyDown("space"))
        {
            animator.SetBool("IsJump", true);
        }

        if (isJump)
        {
            moveDirection.y -= gravity * Time.deltaTime;
            controller.Move( (moveDirection) * Time.deltaTime);
        }

        Vector3 Movement = Cam.transform.right * Horizontal + Cam.transform.forward * Vertical;
        Movement.y = 0f;

        controller.Move(Movement);

        if (Movement.magnitude != 0f)
        {
            transform.Rotate(Vector3.up * Input.GetAxis("Mouse X") * Cam.GetComponent<TPMCameraMove>().sensivity * Time.deltaTime);

            Vector3 vec2 = transform.position - Cam.position;
            Quaternion rotation = Quaternion.LookRotation(vec2, Vector3.up) * Quaternion.LookRotation(new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical")));
            rotation.eulerAngles = new Vector3(0, rotation.eulerAngles.y, 0);
            transform.rotation = rotation;

            Quaternion CamRotation = Cam.rotation;
            CamRotation.x = 0f;
            CamRotation.z = 0f;

            transform.rotation = Quaternion.Lerp(transform.rotation, CamRotation, 0.1f);
            animator.SetBool("IsWalk", true);
        }
    }
    void OnJumpPrepareAniStart()
    {
        Debug.Log("Jump Prepare !");
        animator.SetBool("IsWalk", false);
        isJump = true;
    }
    void OnJumpAniStart()
    {
        Debug.Log("Jump Start !");
        moveDirection.y = jumpSpeed;
        //moveDirection.z = 0f;
    }
    void OnJumpAniEnd()
    {
        Debug.Log("Jump End !");
        animator.SetBool("IsJump", false);
        isJump = false;
    }

    void OnCollisionEnter(Collision c)
    {
        if (c.transform.tag.Equals("Wall"))
        {
            Debug.Log("Kyle Collision Enter !");
            myRigid.MovePosition(prevPlayerPos);
        }

        //if (c.transform.transform.Equals("Floor"))
    }
    void OnWalkingAniEnd()
    {
        animator.SetBool("IsWalk", false);
    }
    /// <summary>
    /// 땅에 접지되어 있는지 여부를 확인
    /// Update에서 실행, _characterController, _fieldLayer의 경우 Start 메서드에서 캐시 처리.
    /// </summary>
    /// <returns></returns>
    private bool IsCheckGrounded()
    {
        // CharacterController.IsGrounded가 true라면 Raycast를 사용하지 않고 판정 종료
        if (controller.isGrounded) return true;
        // 발사하는 광선의 초기 위치와 방향
        // 약간 신체에 박혀 있는 위치로부터 발사하지 않으면 제대로 판정할 수 없을 때가 있다.
        var ray = new Ray(this.transform.position + Vector3.up * 0.1f, Vector3.down);
        // 탐색 거리
        var maxDistance = 0.2f;
        // 광선 디버그 용도
        Debug.DrawRay(transform.position + Vector3.up * 0.1f, Vector3.down * maxDistance, Color.red);
        // Raycast의 hit 여부로 판정
        // 지상에만 충돌로 레이어를 지정
        int layermask = 1 << LayerMask.NameToLayer("Ground");
        return Physics.Raycast(ray, maxDistance, layermask);
    }
}
