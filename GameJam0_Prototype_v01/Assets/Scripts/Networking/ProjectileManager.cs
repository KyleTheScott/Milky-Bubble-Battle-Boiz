using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileManager : MonoBehaviour
{
    public int id;
    private Rigidbody rb;

    public float knockbackForce;
    public float knockbackRadius;

    private float timeActive;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    public void Initialize(int _id, Vector3 _position)
    {
        id = _id;
        transform.position = _position;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            rb.AddExplosionForce(knockbackForce, transform.position, knockbackRadius);
            //Debug.Log("HIT SOMEONE");
            //Destroy(gameObject);
        }

        if (collision.gameObject.tag == "Projectile")
        {
            rb.AddExplosionForce(10f, transform.position, 10);
            //Destroy(gameObject);
        }
    }

    private void Update()
    {
        timeActive += Time.deltaTime;
        if(timeActive > 5)
        {
            GameManager.projectiles.Remove(id);
            
            Destroy(gameObject);
        }
    }
}
