using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindTrailRendererA01 : MonoBehaviour {
    public Animation anim;
	public GameObject gameObject1;
	
    // Use this for initialization
    void Start () {
        anim = GetComponent<Animation>();
	    AniPlaymm();
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    void AniPlaymm()
    {
          anim.Play("WindTrailRendererA01");
	    
    }
}
