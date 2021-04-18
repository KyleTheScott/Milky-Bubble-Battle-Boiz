using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : MonoBehaviour
{

    private Rigidbody rb;

    private Vector3 initialForce;


    public Projectile(Vector3 initialDirection)
    {
        initialForce = initialDirection;
    }

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {

        rb.velocity = transform.forward * 7f;
        Debug.Log("this is: " + rb.velocity);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            Rigidbody playerRb = collision.gameObject.GetComponent<Rigidbody>();
            playerRb.AddForce(transform.forward * 15f, ForceMode.Impulse);

            Player1 p = collision.gameObject.GetComponent<Player1>();
            Destroy(gameObject);
        } else
        {
            Destroy(gameObject);
        }
    }
}
