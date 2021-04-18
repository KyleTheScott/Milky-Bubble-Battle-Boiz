using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement; 

public class VictoryCheck : MonoBehaviour
{
    public int fallCount;
    public GameObject respawnPoint;
    public bool debugMode;
    public GameController gameController;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.L))
        {
            debugMode = !debugMode;
        }

        if (Input.GetKeyDown(KeyCode.P))
        {
            SceneManager.LoadScene(2);
        }
    }

    private void OnTriggerEnter(Collider collision)
    {
        
        if (collision.gameObject.tag == "Player")
        {
            
            if (!debugMode)
            {
                Player1 p = collision.GetComponent<Player1>();

                p.OnPlayerKnockOut();

                fallCount++;
                collision.GetComponent<Player1>().OnPlayerKnockOut();
                if (fallCount == gameController.players.Length - 1) 
                {
                    gameController.SelectWinner();
                    SceneManager.LoadScene(2);
                }
                Debug.Log("Player touched this");
            }
            else
            {
                collision.gameObject.transform.position = respawnPoint.transform.position;
            }
                
        }
    }

}
