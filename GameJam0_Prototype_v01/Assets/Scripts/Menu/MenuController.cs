using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour
{
    public Transform barista;
    public Transform counterLocation;

    public Transform cameraTargetLocation;
    public Transform cameraTargetLocation2;

    public Animator baristaAnimator;

    public GameObject MainMenu;
    public GameObject StartMenu;
    public GameObject TutorialPrompt;
    public GameObject PlayOption;
    public GameObject TutorialOption;
    public GameObject ToppingOption;
    public GameObject SettingsOption;
    public GameObject SoundSelection;
    public GameObject ResolutionSelection;
    public GameObject CharacterMenu;
    public GameObject CosmeticMenu;
    public GameObject MapSelect;
    public GameObject LoadingMenu;
    public GameObject UI;
    public KeyCode _Key;

    private bool isStarted;
    private bool isCharacterSelect;
    public bool tutorialViewed;
    public bool choosingHat;

    void Awake()
    {
        MainMenu.SetActive(false);
        StartMenu.SetActive(true);
        TutorialPrompt.SetActive(false);
        PlayOption.SetActive(false);
        TutorialOption.SetActive(false);
        ToppingOption.SetActive(false);
        SettingsOption.SetActive(false);
        SoundSelection.SetActive(false);
        ResolutionSelection.SetActive(false);
        CharacterMenu.SetActive(false);
        CosmeticMenu.SetActive(false);
        MapSelect.SetActive(false);
       
    }    

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        /*


        if (isStarted && (barista.position != counterLocation.position))
        {

            //barista.position = Vector3.Lerp(barista.position, counterLocation.position, 1 * Time.deltaTime) ;
        }

        if (isStarted)
        {
            Camera.main.transform.position = Vector3.Lerp(Camera.main.transform.position, cameraTargetLocation.position, 2 * Time.deltaTime);
        }

        if (isCharacterSelect)
        {
            Camera.main.transform.position = Vector3.Lerp(Camera.main.transform.position, cameraTargetLocation2.position, 2 * Time.deltaTime);
        }
        */
    }

    public void StartGame()
    {
        SceneManager.LoadScene("WhiteBox");
    }

    public void Quit()
    {
        Debug.Log("QUIT");
        Application.Quit();
    }

    public void CameraZoomStartHere()
    {
        isStarted = true;
        isCharacterSelect = false;
    }

    public void PlayGame()
    {
        isStarted = false;
        isCharacterSelect = true;
    }



    private IEnumerator StartStartHereSequence()
    {
        //isStarted = true;
        Vector3 baristaTurn = barista.eulerAngles + 130f * Vector3.up;

        barista.eulerAngles = Vector3.Lerp(barista.eulerAngles, baristaTurn, 1 * Time.deltaTime);
        yield return new WaitForSeconds(2.0f);

    }

    public void ChangeScreen(GameObject currentScreen, GameObject nextScreen)
    {
        currentScreen.SetActive(false);
        nextScreen.SetActive(true);
    }

    public void OverlayHatScreen(GameObject hatScreen)
    {
        hatScreen.SetActive(true);
        choosingHat = true;
    }

    public void DisableHatScreen(GameObject hatScreen)
    {
        hatScreen.SetActive(false);
        choosingHat = false;
    }

    

}




