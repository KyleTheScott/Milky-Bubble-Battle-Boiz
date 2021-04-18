using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonController : MonoBehaviour
{
    [SerializeField] TutorialPrompt tutorialPrompt;
    [SerializeField] Animator animator;
    [SerializeField] int thisIndex;
       
    

    // Update is called once per frame
    void Update()
    {
        if(tutorialPrompt.index == thisIndex)
        {
            animator.SetBool("selected", true);
            if(Input.GetAxis ("Submit") == 1)
            {
                animator.SetBool("pressed", true);
            }
            else if (animator.GetBool("pressed"))
            {
                animator.SetBool("pressed", false);
            }
            else
            {
                animator.SetBool("selected", false);
            }
        }
    }
}
