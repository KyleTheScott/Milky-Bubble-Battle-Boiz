using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetBulletCollision : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Projectile"))
        {
            gameObject.SetActive(false);
            CounterSystem.checkpointCount++;
            //Destroy(gameObject);
        }

    }
}
