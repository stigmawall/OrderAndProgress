using UnityEngine;
using System.Collections;

public class IntroLogo : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Color newColor = new Color(1, 1, 1, 0);
		guiTexture.color = newColor;
		iTween.FadeTo(this.gameObject, iTween.Hash(
		             	"alpha",1, 
						"time",2, 
						"onComplete","FadeAgain"));
	}
		               

	void FadeAgain() {
		iTween.FadeTo(this.gameObject, iTween.Hash(
			"alpha",0, 
			"time",2,
			"delay", 2,
			"onComplete","GotoMainMenu"));		             
	}


	void GotoMainMenu () {
		Debug.Log("proxima fase");
	}
}
