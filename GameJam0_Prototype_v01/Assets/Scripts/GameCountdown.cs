using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameCountdown : MonoBehaviour
{
    public Image[] countdownImages;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine("Countdown");
    }

    // Update is called once per frame
    void Update()
    {

    }

    public IEnumerator Countdown()
    {
        for (int i = 0; i < countdownImages.Length; i++)
        {
            countdownImages[i].gameObject.SetActive(true);
            yield return new WaitForSeconds(1.0f);
            countdownImages[i].gameObject.SetActive(false);
        }
    }

}
