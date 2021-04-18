using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartHereScreen : MonoBehaviour
{
    public GameObject StartScreen;
    public MenuController menuController;

    // Update is called once per frame
    private void Start()
    {
        menuController = menuController.GetComponent<MenuController>();
    }
    void Update()
    {

        if (Input.GetButtonDown("Submit"))
        {

            if (menuController.tutorialViewed == false)
            {
                ChangeMenus();
                menuController.tutorialViewed = true;
            }

            else if (menuController.tutorialViewed == true)
            {
                SkipTutorial();
            }
        }

        if(Input.GetButtonDown("Cancel"))
        {
            Application.Quit();
        }

       
    }

    public void ChangeMenus() //switching menus,  similar to how change options is built
    {
            menuController.ChangeScreen(menuController.StartMenu, menuController.TutorialPrompt);
    }

    public void SkipTutorial()
    {
        menuController.ChangeScreen(menuController.StartMenu, menuController.MainMenu);
    }
}
