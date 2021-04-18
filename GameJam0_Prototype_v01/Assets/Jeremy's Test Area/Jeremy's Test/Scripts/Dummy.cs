using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dummy : MonoBehaviour
{

    Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Cup")
        {
           
                rb.constraints = RigidbodyConstraints.None;
            

            //playerRigidbody.constraints = RigidbodyConstraints.None;
        }
    }
}
