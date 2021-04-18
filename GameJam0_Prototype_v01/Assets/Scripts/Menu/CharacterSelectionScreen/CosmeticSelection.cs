using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CosmeticSelection : MonoBehaviour
{
    [SerializeField] int maxIndex;
    [SerializeField] bool keyDown;
    public int index;
    public GameObject CosmeticSelect;
    public MenuController menuController;
    public Image[] cosmetics;
    public Text Label;
    public string[] hatNames;

    private void Start()
    {
        index = 0;
        menuController = menuController.GetComponent<MenuController>();
        Label.text = "";
    }

    void Update()
    {
        ChangeCosmetic();
       


        if (Input.GetButtonDown("Submit"))
        {

            menuController.ChangeScreen(menuController.CosmeticMenu, menuController.MapSelect);

        }

        if (Input.GetButtonDown("Cancel"))
        {
            menuController.DisableHatScreen(menuController.CosmeticMenu);
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

    public void ChangeCosmetic()
    {
        for (int i = 0; i < cosmetics.Length; i++)
        {
            if (i == index)
            {
                cosmetics[i].enabled = true;
                Label.text = hatNames[i];
            }

            else
            {
                cosmetics[i].enabled = false;
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