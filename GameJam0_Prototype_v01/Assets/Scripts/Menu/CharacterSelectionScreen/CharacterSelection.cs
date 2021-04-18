using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CharacterSelection : MonoBehaviour
{
    [SerializeField] int maxIndex;
    [SerializeField] bool keyDown;
    public int index;
    public GameObject CharacterSelect;
    public MenuController menuController;
    public Image[] characters;
    public string[] characterNames;
    public Text Label;

    private void Start()
    {
        index = 0; 
        menuController = menuController.GetComponent<MenuController>();
        Label.text = "";
    }

    void Update()
    {
        if (menuController.choosingHat == false)
        {
            ChangeCharacter();

            if (Input.GetButtonDown("Submit"))
            {

                menuController.OverlayHatScreen(menuController.CosmeticMenu);

            }

            if (Input.GetButtonDown("Cancel"))
            {
                menuController.ChangeScreen(menuController.CharacterMenu, menuController.MainMenu);
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
        
    }

    public void ChangeCharacter()
    {
        for (int i = 0; i < characters.Length; i++)
        {
            if (i == index)
            {
                characters[i].enabled = true;
                Label.text = characterNames[i];
            }

            else
            {
                characters[i].enabled = false;
            }
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
}
