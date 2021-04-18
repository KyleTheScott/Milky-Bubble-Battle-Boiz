using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class Dialogue : MonoBehaviour
{
    public Player2 player;
    public TextMeshProUGUI textDisplay;
    public string[] sentences;
    private int index;

    public GameObject tutorialPanel;
    public GameObject gamePanel;

    public GameObject uiPanel;
    public GameObject ui2Panel;

    string sceneName;

    //bool checks for tutorial events
    bool deathOnce = false;
    bool absorbOnce = false;
    bool absorbTwice = false;
    bool absorbThrice = false;

    private void Start()
    {
        textDisplay.SetText(sentences[index]);

        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;

        CounterSystem.checkpointCount = 0; //reset for new scene

        if (sceneName == "TutorialJumping")
        {
            Time.timeScale = 0;
            player.setMovementEnabled(true);
        }
        else if (sceneName == "TutorialShooting")
        {
            Time.timeScale = 0;
            player.setMovementEnabled(true);
            player.setAbsorbingEnabled(true);
        }

    }

    private void Update()
    {

        if (sceneName == "TutorialJumping")
        {
            JumpTutorial();
        }
        else if (sceneName == "TutorialShooting")
        {
            ShootTutorial();
        }

    }

    void JumpTutorial()
    {
        if(tutorialPanel.activeSelf)
        {
            if (Input.GetKeyDown(KeyCode.Return))
            {
                Debug.Log("this is index: " + index);
                if (index == 3)
                {
                    tutorialPanel.SetActive(false);
                    Time.timeScale = 1;
                }
                if (index == 4)
                {
                    SceneManager.LoadScene("TutorialShooting");
                }
                if (index == 5)
                {
                    Respawn.death = false;
                    SceneManager.LoadScene("TutorialJumping");
                }
                else
                {
                    nextSentence();
                }
            }


            if (Input.GetKeyDown(KeyCode.Escape))
            {
                Debug.Log("this is index: " + index);
                if (index > 0 && index != 4 && index != 5)
                {
                    lastSentence();
                }

            }
            if (Input.GetKeyDown(KeyCode.S))
            {
                if(index <= 3)
                {
                    Time.timeScale = 1;
                }
                if (index == 4)
                {
                    SceneManager.LoadScene("TutorialShooting");
                }
                if (index == 5)
                {
                    Respawn.death = false;
                    SceneManager.LoadScene("TutorialJumping");
                }
                else
                {
                    Debug.Log("this is index: " + index);
                    tutorialPanel.SetActive(false);
                    index = 6;
                    displayText();
                }
            }
        }
        

        //checkpoint check
        if (CounterSystem.checkpointCount == 4)
        {
            tutorialPanel.SetActive(true);
            index = 4;
            displayText();

            Time.timeScale = 0;
        }

        //death check
        if (Respawn.death)
        {
            tutorialPanel.SetActive(true);
            index = 5;
            displayText();

            Time.timeScale = 0;
        }
    }

    void ShootTutorial()
    {
        if (tutorialPanel.activeSelf)
        {
            if (Input.GetKeyDown(KeyCode.Return))
            {
                Debug.Log("this is index: " + index);

                //index
                if (index == 0)
                {
                    tutorialPanel.SetActive(false);

                    Time.timeScale = 1;
                }
                if (index == 1)
                {
                    tutorialPanel.SetActive(false);

                    Time.timeScale = 1;
                }
                if (index == 2)
                {
                    tutorialPanel.SetActive(false);
                    switchPanels(uiPanel, ui2Panel);

                    CounterSystem.checkpointCount = 0; //reset absorb count for target count

                    player.setAttackingEnabled(true);

                    Time.timeScale = 1;
                }
                if (index == 3)
                {
                    SceneManager.LoadScene("StartMenu");
                }
                if (index == 4)
                {
                    Respawn.death = false;
                    SceneManager.LoadScene("TutorialShooting");
                }
                else
                {
                    nextSentence();
                }
            }

            /*
            if (Input.GetKeyDown(KeyCode.Escape))
            {
                lastSentence();
            }
            */

            if (Input.GetKeyDown(KeyCode.S))
            {
                if (player.getAmmoCount() == 0 || player.getAmmoCount() == 2 || player.getAmmoCount() == 6)
                {
                    Time.timeScale = 1;
                }
                if (CounterSystem.checkpointCount == 0 && player.getAmmoCount() > 0)
                {
                    player.setAttackingEnabled(true);

                    Time.timeScale = 1;
                }
                if (index == 2)
                {
                    tutorialPanel.SetActive(false);
                    switchPanels(uiPanel, ui2Panel);
                    player.setAttackingEnabled(true);
                    CounterSystem.checkpointCount = 0; //reset absorb count for target count

                    Time.timeScale = 1;
                }
                if (index == 4)
                {
                    Respawn.death = false;
                    SceneManager.LoadScene("TutorialShooting");
                }
                tutorialPanel.SetActive(false);
                index = 5;
                displayText();

                Time.timeScale = 1;

            }

        }


        if (player.getAmmoCount() == 2 && absorbOnce == false)
        {
            Debug.Log("this is index: " + index);
            tutorialPanel.SetActive(true);
            index = 1;
            displayText();
            absorbOnce = true;

            CounterSystem.checkpointCount++;

            Time.timeScale = 0;
        }
        if (player.getAmmoCount() == 4 && absorbTwice == false)
        {
            Debug.Log("this is index: " + index);
            absorbTwice = true;

            CounterSystem.checkpointCount++;
        }
        if (player.getAmmoCount() == 6 && absorbThrice == false)
        {
            Debug.Log("this is index: " + index);
            tutorialPanel.SetActive(true);
            index = 2;
            displayText();
            absorbThrice = true;

            CounterSystem.checkpointCount++;

            Time.timeScale = 0;
        }
        if (CounterSystem.checkpointCount == 4) //target count 4/4
        {
            tutorialPanel.SetActive(true);
            index = 3;
            displayText();

            Time.timeScale = 0;
        }

        //death check
        if (Respawn.death)
        {
            tutorialPanel.SetActive(true);
            index = 4;
            displayText();

            Time.timeScale = 0;
        }

    }


    void nextSentence()
    {

        if (index < sentences.Length - 1)
        {
            index++;
            displayText();
        }
        else
        {
            textDisplay.text = "";
        }


    }

    void lastSentence()
    {

        if (index > 0 - 1)
        {
            index--;
            displayText();
        }
        else
        {
            textDisplay.text = "";
        }
    }
    void displayText()
    {
        textDisplay.text = "";
        textDisplay.SetText(sentences[index]);

    }

    void skipSentence()
    {
        if (tutorialPanel.activeSelf)
        {
            switchPanels(tutorialPanel, gamePanel);
        }
    }

    void switchPanels(GameObject panel1, GameObject panel2)
    {
        panel1.SetActive(false);
        panel2.SetActive(true);
    }
}
