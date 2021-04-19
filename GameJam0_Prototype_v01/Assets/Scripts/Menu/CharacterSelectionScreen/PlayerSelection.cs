using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.InputSystem;
using System;

public enum PlayerSelectionState
{
    SelectingCharacter,
    SelectingCosmetic,
    ReadyingUp,
    Ready
}


public class PlayerSelection : MonoBehaviour
{
    private int PlayerIndex;
    private PlayerInput playerInput;
    private PlayerControls controls;
    private SelectionScreenManager selectionScreenManager;

    [SerializeField]
    private TextMeshProUGUI playerNumberText;
    [SerializeField]
    private TextMeshProUGUI characterSelectedText;
    [SerializeField]
    private TextMeshProUGUI cosmeticSelectedText;
    [SerializeField]
    private TextMeshProUGUI readyText;
    [SerializeField]
    private Image characterSelectedImage;
    [SerializeField]
    private Image cosmeticSelectedImage;
    [SerializeField]
    private RawImage leftArrow;
    [SerializeField]
    private RawImage rightArrow;

    [SerializeField]
    private string readyConfirmedString = "Ready!!";
    [SerializeField]
    private Color readyConfirmedColor;
    [SerializeField]
    private string readyUPString = "Ready??";
    [SerializeField]
    private Color readyUPColor;

    [SerializeField, Range(0.2f, 4.0f)]
    private float ignoreInputTime = 1.5f;
    private float InputTime;
    private bool inputEnabled;
    private PlayerSelectionState selectionState;
    private int characterIndex;
    private int cosmeticIndex;

    //to find indexes
    private int selectedCharacter;
    private int startIndex, endIndex;

    public void Awake()
    {
        cosmeticSelectedImage.gameObject.SetActive(false);
        cosmeticSelectedText.gameObject.SetActive(false);
        readyText.gameObject.SetActive(false);
        selectionState = PlayerSelectionState.SelectingCharacter;
        // TODO: Add in finding the selection screen handlers
        controls = new PlayerControls();
        selectionScreenManager = FindObjectOfType<SelectionScreenManager>();
        if (selectionScreenManager == null)
        {
            Debug.LogError("SelectionScreenManager couldn't be found");
        }
    }
    public void InitializePlayer(PlayerInput pi)
    {
        playerInput = pi;
        playerInput.onActionTriggered += Input_onActionTriggered;
        PlayerIndex = pi.playerIndex;
        playerNumberText.SetText("Player " + (PlayerIndex + 1).ToString());
        DisplayCharacterItem(selectionScreenManager.characters[characterIndex]);
        DisableInputForSetAmountOfTime();
    }

    private void Input_onActionTriggered(InputAction.CallbackContext obj)
    {
        if (!inputEnabled || !obj.started)
        {
            return;
        }

        if (obj.action.name == controls.Gameplay.Submit.name)
        {
            switch (selectionState)
            {
                case PlayerSelectionState.SelectingCharacter:
                    SetPlayerCharacter(selectionScreenManager.characters[characterIndex]);
                    break;

                case PlayerSelectionState.SelectingCosmetic:
                    SetPlayerCosmetic(selectionScreenManager.cosmetics[cosmeticIndex]);
                    break;

                case PlayerSelectionState.ReadyingUp:
                    Debug.Log("Player is ready");
                    ReadyPlayer();
                    break;
            }
        }

        if (obj.action.name == controls.Gameplay.LeftSelection.name)
        {
            switch (selectionState)
            {
                case PlayerSelectionState.SelectingCharacter:
                    characterIndex--;
                    if (characterIndex < 0)
                    {
                        characterIndex = selectionScreenManager.characters.Length - 1;
                    }
                    DisplayCharacterItem(selectionScreenManager.characters[characterIndex]);
                    break;

                case PlayerSelectionState.SelectingCosmetic:
                    cosmeticIndex--;
                    /*
                    if (cosmeticIndex < 0)
                    {
                        cosmeticIndex = selectionScreenManager.cosmetics.Length - 1;
                    }
                    */

                    //if the index becomes less than the start index

                    if (cosmeticIndex < startIndex)
                    {
                        cosmeticIndex = endIndex - 1;
                    }
                    DisplayCosmeticItem(selectionScreenManager.cosmetics[cosmeticIndex]);
                    break;
            }
        }

        if (obj.action.name == controls.Gameplay.RightSelection.name)
        {
            switch (selectionState)
            {
                case PlayerSelectionState.SelectingCharacter:
                    characterIndex++;
                    if (characterIndex > selectionScreenManager.characters.Length - 1)
                    {
                        characterIndex = 0;
                    }
                    DisplayCharacterItem(selectionScreenManager.characters[characterIndex]);
                    break;

                case PlayerSelectionState.SelectingCosmetic:
                    cosmeticIndex++;
                    /*
                    if (cosmeticIndex > selectionScreenManager.cosmetics.Length - 1)
                    {
                        cosmeticIndex = 0;
                    }
                    */

                    if (cosmeticIndex > endIndex - 1)
                    {
                        cosmeticIndex = startIndex;
                    }
                    DisplayCosmeticItem(selectionScreenManager.cosmetics[cosmeticIndex]);
                    break;
            }
        }

        if (obj.action.name == controls.Gameplay.Cancel.name)
        {
            switch (selectionState)
            {
                case PlayerSelectionState.SelectingCharacter:
                    // TODO: handle a player backing out of the match
                    Debug.Log("Player attempted to back out of the match, this feature hasnt been fully completed so for now we'll back out to the map selection");
                    selectionScreenManager.QuitSelectionScreen();
                    break;

                case PlayerSelectionState.SelectingCosmetic:
                    selectionState = PlayerSelectionState.SelectingCharacter;
                    cosmeticSelectedImage.gameObject.SetActive(false);
                    cosmeticSelectedText.gameObject.SetActive(false);
                    break;

                case PlayerSelectionState.ReadyingUp:
                    UnReadyPlayer();
                    break;

                case PlayerSelectionState.Ready:
                    UnReadyPlayer();
                    break;
            }
        }
    }

    // Update is called once per frame
    public void Update()
    {
        if (Time.time > InputTime)
        {
            inputEnabled = true;
        }
    }

    public void SetPlayerCharacter(Item character)
    {
        if (!inputEnabled) { return; }

        if(characterIndex != 3)
        {
            //selected character is the index i selected
            selectedCharacter = characterIndex;

            //last number of the index = length of all characters * selected character index + 1 
            //(+1 done so that our 1st character isnt read as value of 0, 2nd character as value of 1, ect)

            endIndex = (selectionScreenManager.characters.Length * (selectedCharacter + 1));

            //start index = the end index - lenth of accessory options - length of character options.  

            startIndex = endIndex - (selectionScreenManager.cosmetics.Length / selectionScreenManager.characters.Length);

            Debug.Log("Selected Character:" + selectedCharacter + " Start Index:" + startIndex + " End Index: " + endIndex);

            cosmeticIndex = startIndex;

            PlayerConfigurationManager.Instance.SetPlayerCharacter(PlayerIndex, character);
            cosmeticSelectedImage.gameObject.SetActive(true);
            cosmeticSelectedText.gameObject.SetActive(true);
            DisplayCosmeticItem(selectionScreenManager.cosmetics[cosmeticIndex]);
            selectionState = PlayerSelectionState.SelectingCosmetic;
            DisableInputForSetAmountOfTime();
        }
        else
        {
            
            Debug.LogWarning("Hard coded for XP Summit to only choose Brown Bear!  Edit Player selection to delete if statement in SetPlayerCharacter Function to fix " +
                "this!  This is not a bug!");
        }
        
    }

    public void SetPlayerCosmetic(Item cosmetic)
    {
        if (!inputEnabled) { return; }
        if (cosmeticIndex == startIndex)
        {
            PlayerConfigurationManager.Instance.SetPlayerCosmetic(PlayerIndex, cosmetic);
        characterSelectedText.gameObject.SetActive(false);
        cosmeticSelectedText.gameObject.SetActive(false);
        leftArrow.gameObject.SetActive(false);
        rightArrow.gameObject.SetActive(false);
        selectionState = PlayerSelectionState.ReadyingUp;
        DisableInputForSetAmountOfTime();

        readyText.gameObject.SetActive(true);
        readyText.text = readyUPString;
        readyText.color = readyUPColor;
    }
        else
        {
            Debug.LogWarning("Hard coded for XP Summit to only choose No Hat!  Edit Player selection to delete if statement in SetPlayerCharacter Function to fix " +
                "this!  This is not a bug!");
        }
    }

    public void ReadyPlayer()
    {
        if (!inputEnabled) { return; }

        readyText.text = readyConfirmedString;
        readyText.color = readyConfirmedColor;
        PlayerConfigurationManager.Instance.ReadyPlayer(PlayerIndex);
        selectionState = PlayerSelectionState.Ready;
        DisableInputForSetAmountOfTime();
    }

    public void UnReadyPlayer()
    {
        if (!inputEnabled) { return; }

        readyText.gameObject.SetActive(false);
        characterSelectedText.gameObject.SetActive(true);
        cosmeticSelectedText.gameObject.SetActive(true);
        leftArrow.gameObject.SetActive(true);
        rightArrow.gameObject.SetActive(true);
        selectionState = PlayerSelectionState.SelectingCosmetic;
        DisableInputForSetAmountOfTime();
    }

    private void DisplayCharacterItem(Item character)
    {
        characterSelectedText.text = character.ItemName;
        characterSelectedImage.sprite = character.ItemSprite;
    }

    private void DisplayCosmeticItem(Item cosemtic)
    {
        cosmeticSelectedText.text = cosemtic.ItemName;
        cosmeticSelectedImage.sprite = cosemtic.ItemSprite;
        if (cosmeticSelectedImage.sprite == null)
        {
            var newColor = cosmeticSelectedImage.color;
            newColor.a = 0;
            cosmeticSelectedImage.color = newColor;
        }
        else
        {
            var newColor = cosmeticSelectedImage.color;
            newColor.a = 1;
            cosmeticSelectedImage.color = newColor;
        }
    }

    private void DisableInputForSetAmountOfTime()
    {
        inputEnabled = false;
        InputTime = Time.time + ignoreInputTime;
    }
}
