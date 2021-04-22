using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainSelections : MonoBehaviour
{


    public int index; // what am i currently hovering over
    [SerializeField] bool keyDown;
    [SerializeField] int maxIndex; // max # of indexes you can have. last number option

    public MenuController menuController;

    public GameObject[] playMenuObjects;
    public Image[] underlines;

    //barista chatter
    private bool enteredMainMenu;
    public float secondsUntilChatter;
    [SerializeField]
    private float timer;
    private FMODSoundManager soundManager;


    // Start is called before the first frame update
    void Start()
    {
        index = 0;
        keyDown = false;

        for (int i = 0; i < underlines.Length; i++)
        {
            underlines[i].enabled = false;
        }

        menuController = menuController.GetComponent<MenuController>(); // making sure the menu controller knows who it is. this is how you fix null reference exception

        //barista chatter
        soundManager = FindObjectOfType<FMODSoundManager>();
        enteredMainMenu = true;
        timer = 0;
    }

    // Update is called once per frame
    void Update()
    {
        
        ChangeOptions();

        BaristaChatter();

        if (Input.GetButtonDown("Submit"))
        {
            enteredMainMenu = false;
            ChangeMenus();
        }
        if (Input.GetButtonDown("Cancel"))
        {
            menuController.ChangeScreen(menuController.MainMenu, menuController.StartMenu);
        }


        if (!keyDown)
        {
            if (Input.GetAxis("Horizontal") > 0.5)
            {
                keyDown = true;
                StartCoroutine("IncreaseIndex");

            }

            else if (Input.GetAxis("Horizontal") < -0.5)
            {
                keyDown = true;
                StartCoroutine("DecreaseIndex");
            }

        }
        else if ((Input.GetAxis("Horizontal") < 0.5 && Input.GetAxis("Horizontal") > -0.5) && keyDown)
        {
            keyDown = false;
            StopAllCoroutines();
        }

    }

    public void ChangeOptions()
    {
        for (int i = 0; i < underlines.Length; i++)
        {
            if (i == index)
            {
                underlines[i].enabled = true;
            }

            else
            {
                underlines[i].enabled = false;
            }
        }

    }
    public void ChangeMenus() //switching menus,  similar to how change options is built
    {
        if (index == 0)
        {
            menuController.ChangeScreen(menuController.MainMenu, menuController.PlayOption);
        }
        else if (index == 1) //changing screens. first one is current, second one is next screen. menuController is to access anything in the menuController script that is public
        {
            menuController.ChangeScreen(menuController.MainMenu, menuController.TutorialOption);
        }
        else if (index == 2) //changing screens. first one is current, second one is next screen. menuController is to access anything in the menuController script that is public
        {
            menuController.ChangeScreen(menuController.MainMenu, menuController.SettingsOption);
        }
        
    }

    public IEnumerator IncreaseIndex()
    {

        index++;

        if (index == maxIndex)
        {
            index = 0;
        }

        yield return new WaitForSeconds(0.2f);

        keyDown = false;
    }

    public IEnumerator DecreaseIndex()
    {

        index--;

        if (index < 0)
        {
            index = maxIndex - 1;
        }

        yield return new WaitForSeconds(0.2f);

        keyDown = false;
    }

    private void BaristaChatter()
    {
        //reset the timer if we had left the screen
        if (enteredMainMenu == false)
        {
            enteredMainMenu = true;
            timer = 0;
        }

        timer = timer + Time.deltaTime;
        if(timer >= secondsUntilChatter)
        {
            soundManager.PlayBaristaChatter();
            Debug.Log("barista says wumbo");
            timer = 0;
        }
        
    }





}
