using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetActive : MonoBehaviour
{
    public GameObject myObject;
        public bool activate;

    private void Update()
    {
        if(activate == true)
        {
            myObject.SetActive(true);
        }
        else
        {
            myObject.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            myObject.SetActive(true);
        }

    }
}
