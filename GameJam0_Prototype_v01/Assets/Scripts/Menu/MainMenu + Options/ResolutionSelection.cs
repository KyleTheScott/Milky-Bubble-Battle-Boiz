using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ResolutionSelection : MonoBehaviour
{
    [SerializeField] int maxIndex;
    [SerializeField] bool keyDown;
    public int index;
    public GameObject ResolutionSelect;
    public MenuController menuController;
    public string[] resolutions;
    public Text Label;

    // Start is called before the first frame update
    private void Start()
    {
        index = 0;
        menuController = menuController.GetComponent<MenuController>();
        Label.text = "";
    }

    // Update is called once per frame
    void Update()
    {
        ChangeResolution();

        if (Input.GetButtonDown("Cancel"))
        {
            menuController.ChangeScreen(menuController.ResolutionSelection, menuController.MainMenu);
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

    public void ChangeResolution()
    {
        for (int i = 0; i < resolutions.Length; i++)
        {
            if (i == index)
            {
                Label.text = resolutions[i];
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
