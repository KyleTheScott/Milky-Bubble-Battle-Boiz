using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    [Header("Bullet Related")]
    public int MaxBullets;
    public GameObject bulletPrehab;

    [Header("Player Related")]
    [SerializeField]
    private Transform[] playerSpawns;

    [Header("Player HUD Related")]
    [SerializeField]
    public PlayerHUD[] playerHUDs;

    public Player1[] players { get; private set; }

    // Start is called before the first frame update
    void Start()
    {
        BulletManager.Instance.Init(bulletPrehab, MaxBullets);
        var playerConfigs = PlayerConfigurationManager.Instance.GetPlayerConfigurations().ToArray();
        players = new Player1[playerConfigs.Length];
        Debug.Log(playerConfigs.Length);
        for (int i = 0; i < playerConfigs.Length; i++)
        {
            var player = Instantiate(playerConfigs[i].PlayerCharacter.ItemObject, playerSpawns[i].position, playerSpawns[i].rotation);
            playerHUDs[i].gameObject.SetActive(true);
            players[i] = player.GetComponent<Player1>();
            players[i].InitializePlayer(playerConfigs[i], playerHUDs[i]);
            
        }
    }

    public void SelectWinner()
    {

        foreach (Player1 player in players)
        {
            if (!player.isKnockedOut)
            {
                PlayerConfigurationManager.Instance.SetWinningPlayer(player.GetPlayerConfig());
                Debug.Log("Set winning player");
            }
        }

        foreach (Player1 player in players)
        {
            Destroy(player.gameObject);
        }
    }



}
