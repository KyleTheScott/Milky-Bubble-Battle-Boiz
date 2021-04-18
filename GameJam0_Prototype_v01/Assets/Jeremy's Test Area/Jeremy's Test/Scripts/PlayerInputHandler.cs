using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using UnityEngine.InputSystem;
using static UnityEngine.InputSystem.InputAction;

public class PlayerInputHandler : MonoBehaviour
{
    private PlayerInput playerInput;
    private PlayerInputManager playerInputManager;
    private Player1 player;

    private void Awake()
    {
        playerInput = GetComponent<PlayerInput>();
        //var index = playerInput.playerIndex;

        var players = FindObjectsOfType<Player1>();

        //player = players.FirstOrDefault(m => m.playerID == index);
    }

    private void Update()
    {
           
    }


}
