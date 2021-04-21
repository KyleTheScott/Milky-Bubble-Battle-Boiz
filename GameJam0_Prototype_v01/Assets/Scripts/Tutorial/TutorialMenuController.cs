using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class TutorialMenuController : MonoBehaviour
{

    public PlayerInput playerInput;
    public GameObject[] tutorialInstructionsMK;
    public GameObject[] tutorialInstructionsGamepad;



    // Update is called once per frame
    void Update()
    {
        if(playerInput.currentControlScheme.Contains("Mouse") || playerInput.currentControlScheme.Contains("Keyboard"))
        {
           foreach(GameObject instructions in tutorialInstructionsGamepad)
            {
                instructions.SetActive(false);
            }

            foreach (GameObject instructions in tutorialInstructionsMK)
            {
                instructions.SetActive(true);
            }
        }

        else if (playerInput.currentControlScheme.Contains("Gamepad"))
        {

            foreach (GameObject instructions in tutorialInstructionsGamepad)
            {
                instructions.SetActive(true);
            }

            foreach (GameObject instructions in tutorialInstructionsMK)
            {
                instructions.SetActive(false);
            }
        }
    }
}
