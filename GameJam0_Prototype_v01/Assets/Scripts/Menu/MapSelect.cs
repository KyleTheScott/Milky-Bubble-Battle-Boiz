using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MapSelect : MonoBehaviour
{
    [SerializeField] int maxIndex;
    [SerializeField] bool keyDown;
    public int index;
    public GameObject MapsSelect;
    public MenuController menuController;
    public string[] maps;
    public Text Label;
    // Start is called before the first frame update
    public void Start()
    {
        index = 0;
        menuController = menuController.GetComponent<MenuController>();
        Label.text = "";
    }

    // Update is called once per frame
    public void Update()
    {
        ChangeMap();

        if (Input.GetButtonDown("Submit"))
        {
            Debug.Log("Going to the character select screen");
            menuController.ChangeScreen(menuController.MapSelect, menuController.CharacterMenu);
        }

        if (Input.GetButtonDown("Cancel"))
        {
            menuController.ChangeScreen(menuController.MapSelect, menuController.MainMenu);
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

    public void ChangeMap()
    {
        for (int i = 0; i < maps.Length; i++)
        {
            if (i == index)
            {
                Label.text = maps[i];
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
