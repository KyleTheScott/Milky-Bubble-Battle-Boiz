using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class VictoryScreen : MonoBehaviour
{
    public bool canContinue = false;
    public float waitTime;
    [SerializeField]
    private Image winningPlayerImage;
    [SerializeField]
    private TextMeshProUGUI winningPlayerText;
    [SerializeField]
    private TextMeshProUGUI winningPlayerName;
    private PlayerConfiguration winningPlayer;

    [SerializeField]
    private GameObject continueMessage;

    [SerializeField]
    private AudioSource audioSource;

    [SerializeField]
    private AudioClip victoryClip;

    // Start is called before the first frame update

    void Awake()
    {

    }


    private void Start()
    {
        canContinue = false;
        StartCoroutine("PlayerWait");
        winningPlayer = PlayerConfigurationManager.Instance.winningPlayer;
        winningPlayerText.text = winningPlayer.PlayerCharacter.ItemName;
        winningPlayerName.SetText("Player " + (winningPlayer.PlayerIndex + 1));

        

        continueMessage.SetActive(false);
        
        if (winningPlayer.PlayerOutfit.ItemSprite != null)
        {
            winningPlayerImage.sprite = winningPlayer.PlayerOutfit.ItemSprite;
        }
        else
        {
            winningPlayerImage.sprite = winningPlayer.PlayerCharacter.ItemSprite;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Cancel"))
        {
            if (canContinue)
            {
                SceneManager.LoadScene(0);
            }
        }

        if (Input.GetButtonDown("Submit"))
        {
            if (canContinue)
            {
                SceneManager.LoadScene(1);
            }
        }
    }

    public IEnumerator PlayerWait()
    {

        //play the victory music
        audioSource.clip = victoryClip;
        audioSource.volume = 0.7f;
        audioSource.Play();

        yield return new WaitForSeconds(waitTime);
        canContinue = true;
        continueMessage.SetActive(true);
        
    }
}
