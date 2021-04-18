using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class SpawnPlayerSelection : MonoBehaviour
{
    public GameObject playerSetupMenuPrefab;
    public PlayerInput input;
    public string menuName;
    public void Awake()
    {
        GameObject rootMenu = GameObject.Find(menuName);

        if (rootMenu != null)
        {
            var menu = Instantiate(playerSetupMenuPrefab, rootMenu.transform);
            menu.GetComponent<PlayerSelection>().InitializePlayer(input);
        }
    }
}
