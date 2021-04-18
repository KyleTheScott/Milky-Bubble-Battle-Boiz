using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class BulletManager : MonoBehaviour
{
    public static BulletManager Instance { get; private set; }
    // game controller reference
    private GameController gameController;

    private void Start()
    {
        gameController = FindObjectOfType<GameController>();
    }
    
    public void Awake()
    {
        if (Instance != null)
        {
            if (this != Instance)
            {
                Destroy(gameObject);
            }
        }
        else
        {
            Instance = this;
        }
    }

    public int MaxBullets { get; set; }

    private Queue<GameObject> m_bulletPool;
    public void Init(GameObject bulletType, int max_bullets = 50)
    {
        MaxBullets = max_bullets;
        BuildBulletPool(bulletType);
    }

    private void BuildBulletPool(GameObject bulletType)
    {
        // create empty Queue structure
        m_bulletPool = new Queue<GameObject>();
        for (int count = 0; count < MaxBullets; count++)
        {
            var tempBullet = GameObject.Instantiate(bulletType);
            tempBullet.transform.parent = gameController.gameObject.transform;
            tempBullet.SetActive(false);
            m_bulletPool.Enqueue(tempBullet);
        }
    }

    public GameObject GetBullet(Vector3 position, Vector3 direction)
    {
        var newBullet = m_bulletPool.Dequeue();
        newBullet.SetActive(true);
        newBullet.transform.position = position;
        newBullet.GetComponent<BulletController>().FireBullet(direction);
        return newBullet;
    }

    public GameObject GetBullet()
    {
        return m_bulletPool.Dequeue();    
    }

    public bool HasBullets()
    {
        return m_bulletPool.Count > 0;
    }

    public void ReturnBullet(GameObject returnedBullet)
    {
        returnedBullet.SetActive(false);
        m_bulletPool.Enqueue(returnedBullet);
    }
}
