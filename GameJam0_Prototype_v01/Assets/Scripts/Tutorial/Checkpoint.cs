using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class Checkpoint : MonoBehaviour
{
    public Respawn respawn;

    private void Start()
    {
        respawn = FindObjectOfType<Respawn>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            CounterSystem.checkpointCount += 1;
            //respawn.setSpawnPoint(transform);
            gameObject.SetActive(false);
        }

    }
}
