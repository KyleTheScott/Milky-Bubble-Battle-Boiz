using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SoundSelection : MonoBehaviour
{

    public MenuController menuController;

    // Start is called before the first frame update
    private void Start()
    {
        menuController = menuController.GetComponent<MenuController>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Cancel"))
        {
            menuController.ChangeScreen(menuController.SoundSelection, menuController.MainMenu);
        }
    }
}
