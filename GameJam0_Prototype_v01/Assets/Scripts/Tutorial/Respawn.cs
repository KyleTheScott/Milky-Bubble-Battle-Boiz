using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Respawn : MonoBehaviour
{

    //[SerializeField] private Transform player;
    //[SerializeField] private Transform respawnPoint;
    public static bool death;

    /*
    public void setSpawnPoint(Transform newPosition)
    {
        respawnPoint = newPosition;
    }*/

    private void OnTriggerEnter(Collider other)
    {
        //player.transform.position = respawnPoint.transform.position;
        death = true;
    }

}
