using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class PlayerConfigurationManager : MonoBehaviour
{
    private List<PlayerConfiguration> playerConfigurations;

    [SerializeField]
    private int MaxPlayers = 4;
    public int MinPlayersRequired = 1;

    [SerializeField]
    private string selectedMap;

    private PlayerInputManager playerInputManager;


    public PlayerConfiguration winningPlayer { get; private set; }

    public static PlayerConfigurationManager Instance { get; private set; }

    public void Awake()
    {
        if (Instance != null)
        {
            if (this != Instance)
            {
                Destroy(gameObject);
            }
        }
        else
        {
            Instance = this;
            DontDestroyOnLoad(Instance);
            playerConfigurations = new List<PlayerConfiguration>();
            playerInputManager = GetComponent<PlayerInputManager>();
            SceneManager.sceneLoaded += OnSceneLoaded;
        }
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        if (scene.name == "StartMenu")
        {
            playerInputManager.EnableJoining();
        }
        else
        {
            playerInputManager.DisableJoining();
        }
    }

    public List<PlayerConfiguration> GetPlayerConfigurations()
    {
        return playerConfigurations;
    }

    public void RemoveAllPlayerConfigurations()
    {
        playerConfigurations.Clear();
        foreach (Transform child in transform)
        {
            Destroy(child.gameObject);
        }
        playerInputManager.EnableJoining();
    }

    public void SetSelectedMap(string mapName)
    {
        selectedMap = mapName;
    }

    public void SetPlayerCharacter(int index, Item character)
    {
        playerConfigurations[index].PlayerCharacter = character;
    }

    public void SetPlayerCosmetic(int index, Item outfit)
    {
        playerConfigurations[index].PlayerOutfit = outfit;
    }

    public void ReadyPlayer(int index)
    {
        playerConfigurations[index].IsReady = true;
        if (playerConfigurations.Count >= MinPlayersRequired && playerConfigurations.All(p => p.IsReady == true))
        {
            // TODO: Add in map selection
            Debug.Log("All players are now ready");
            SceneManager.LoadScene(selectedMap);
        }
    }

    public void UnReadyPlayer(int index)
    {
        playerConfigurations[index].IsReady = false;
    }

    public void HandlePlayerJoin(PlayerInput player)
    {
        Debug.Log("Player Joined" + player.playerIndex);
        if((!playerConfigurations.Any(p => p.PlayerIndex == player.playerIndex)) && (SceneManager.GetActiveScene().name == "StartMenu") && (playerConfigurations.Count < MaxPlayers))
        {
            player.transform.SetParent(transform);
            playerConfigurations.Add(new PlayerConfiguration(player));
        }
    }

    public void SetWinningPlayer(PlayerConfiguration winningPlayer)
    {
        if (playerConfigurations.Contains(winningPlayer))
        {
            this.winningPlayer = winningPlayer;
        }
        else
        {
            Debug.LogWarning("A playerConfiguration that's NOT part of the manager was passed as the winner");
        }
    }
}

public class PlayerConfiguration
{ 
    public PlayerConfiguration(PlayerInput playerInput)
    {
        PlayerIndex = playerInput.playerIndex;
        Input = playerInput;
    }
    public PlayerInput Input { get; set; }
    public int PlayerIndex { get; set; }
    public bool IsReady { get; set; }
    public Item PlayerCharacter { get; set; }
    public Item PlayerOutfit { get; set; }
}

