using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ToppingSelection : MonoBehaviour
{
    public int index; // what am i currently hovering over
    [SerializeField] bool keyDown;
    [SerializeField] int maxIndex; // max # of indexes you can have. last number option

    public MenuController menuController;

    public GameObject[] playMenuObjects;
    public Image[] underlines;
    public Text Label;
    public string[] toppings;

    // Start is called before the first frame update
    void Start()
    {
        index = 0;
        keyDown = false;

        for (int i = 0; i < underlines.Length; i++)
        {
            underlines[i].enabled = false;
        }

        menuController = menuController.GetComponent<MenuController>();
        Label.text = "";
    }

    // Update is called once per frame
    void Update()
    {

        ChangeOptions();
        ChangeToppings();

        if (Input.GetButtonDown("Cancel"))
        {


            index = 0;
        }

        if (!keyDown)
        {
            // Horizontal Input
            if (Input.GetAxis("Horizontal") > 0.5)
            {
                keyDown = true;
                StartCoroutine("IncreaseHorizontalIndex");

            }

            else if (Input.GetAxis("Horizontal") < -0.5)
            {
                keyDown = true;
                StartCoroutine("DecreaseHorizontalIndex");
            }

        }
        else if ((Input.GetAxis("Horizontal") < 0.5 && Input.GetAxis("Horizontal") > -0.5) && keyDown)
        {
            keyDown = false;
            StopAllCoroutines();
        }

        // Vertical Input

       /* else if (Input.GetAxis("Vertical") > 0.5)
        {
            keyDown = true;
            StartCoroutine("IncreaseVerticalIndex");
        }

        else if ((Input.GetAxis("Vertical") < 0.5 && Input.GetAxis("Vertical") > -0.5) && keyDown)
        {
            keyDown = false;
            StopAllCoroutines();
        }*/
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

    public void ChangeToppings()
    {
        for (int i = 0; i < toppings.Length; i++)
        {
            if (i == index)
            {
                Label.text = toppings[i];
            }
        }

    }

    

    public IEnumerator IncreaseHorizontalIndex()
    {

        index++;

        if (index == maxIndex)
        {
            index = 0;
        }

        yield return new WaitForSeconds(0.2f);

        keyDown = false;
    }

    public IEnumerator DecreaseHorizontalIndex()
    {

        index--;

        if (index < 0)
        {
            index = maxIndex - 1;
        }

        yield return new WaitForSeconds(0.2f);

        keyDown = false;
    }

    public IEnumerator IncreaseVerticalIndex()
    {

        index = index + 3;

        if (index >= maxIndex)
        {
            index = index - 5;
        }

        yield return new WaitForSeconds(0.2f);

        keyDown = false;
    }

    public IEnumerator DecreaseVerticalIndex()
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
