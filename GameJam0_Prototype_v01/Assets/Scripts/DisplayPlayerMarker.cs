using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class DisplayPlayerMarker : MonoBehaviour
{
    public GameObject PlayerMarker;
    private Player1 p;
    public int showTimer;
    public TextMeshProUGUI playerText;
    public Color[] bearColors;
    public GameObject Bear;
    public RawImage pointer;

    // Start is called before the first frame update
    void Start()
    { 
        p = this.gameObject.GetComponent<Player1>();
        playerText.SetText("P" + (p.playerID + 1));
        playerText.color = bearColors[p.playerID];
        pointer.color = bearColors[p.playerID];

        //var renderer = Bear.gameObject.GetComponent<Renderer>();
        //renderer.material.color = bearColors[p.playerID];

        PlayerMarker.SetActive(true);
        StartCoroutine("ShowPlayerMarker");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public IEnumerator ShowPlayerMarker()
    {
        yield return new WaitForSeconds(showTimer);
        PlayerMarker.SetActive(false);
    }
}
