using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

[Serializable]
public struct Item
{
    public Sprite ItemSprite;
    public string ItemName;
    public GameObject ItemObject;
}

public class SelectionScreenManager : MonoBehaviour
{
    [SerializeField]
    public Item[] cosmetics;
    [SerializeField]
    public Item[] characters;

    [SerializeField]
    private MenuController menuController;
    [SerializeField]
    private GameObject OldInputEventSystem;
    [SerializeField]
    private PlayerConfigurationManager playerConfigurationManager;
    [SerializeField]
    private GameObject playerPanel;

    // Start is called before the first frame update
    void Start()
    {
        OldInputEventSystem.gameObject.SetActive(false);
        playerConfigurationManager.gameObject.SetActive(true);
    }

    public void OnEnable()
    {
        OldInputEventSystem.gameObject.SetActive(false);
        playerConfigurationManager.gameObject.SetActive(true);
        PlayerConfigurationManager.Instance.RemoveAllPlayerConfigurations();
    }

    public void OnDisable()
    {
    }

    public void QuitSelectionScreen()
    {
        menuController.ChangeScreen(menuController.CharacterMenu, menuController.MainMenu);
        PlayerConfigurationManager.Instance.RemoveAllPlayerConfigurations();
        foreach (Transform child in playerPanel.transform)
        {
            Destroy(child.gameObject);
        }
        playerConfigurationManager.gameObject.SetActive(false);
        OldInputEventSystem.gameObject.SetActive(true);
    }
}
