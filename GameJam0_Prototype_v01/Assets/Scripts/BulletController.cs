using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletController : MonoBehaviour
{
    [Header("Bullet Stats")]
    [SerializeField]
    public float speed;
    [SerializeField]
    float knockbackForce;
    [SerializeField]
    Rigidbody rigidBody;
    [SerializeField]
    public Sprite BulletImage;

    public float bulletTimeout;
    private float bulletDuration;

    // Start is called before the first frame update
    void Awake()
    {
        rigidBody = GetComponent<Rigidbody>();
    }
    void OnCollisionEnter(Collision collision)
    {
        Player player = collision.gameObject.GetComponent<Player>();
        if (player)
        {
            player.ApplyKnockBack(Vector3.Normalize(player.transform.position - transform.position) * knockbackForce, true, 2.0f);
        }
        Destroy(gameObject);
    }

    public void FireBullet(Vector3 direction)
    {
        rigidBody.velocity = direction * speed;
    }

    private void FixedUpdate()
    {
        if(bulletDuration < bulletTimeout)
        {
            bulletDuration += Time.deltaTime;
        } else
        {
            Destroy(gameObject);
        }
    }


}
