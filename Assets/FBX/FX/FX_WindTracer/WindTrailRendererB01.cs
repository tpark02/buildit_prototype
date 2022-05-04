using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindTrailRendererB01 : MonoBehaviour {
    public Animation anim;

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
        anim.Play("WindTrailRendererB01");
        
    }
}
