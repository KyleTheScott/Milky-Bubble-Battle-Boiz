using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{

    private Collider platformCollider;
    private PlayerManager playerManager;

    //public Projectile projectile;
    public int fireRate = 1;
    private bool readyToFire = true;

    private void Start()
    {
        //platformCollider = GameObject.Find("Milk Tea").GetComponent<Collider>();
        playerManager = GetComponent<PlayerManager>();
    }

    private void Update()
    {

        if(platformCollider == null) {
            platformCollider = GameObject.Find("Milk Tea").GetComponent<Collider>();
        }

        if (playerManager.id == Client.instance.myId)
        {
            if (Input.GetKeyDown(KeyCode.Mouse0))
            {
                ClientSend.PlayerShoot(transform.forward);
            }
        }
        
    }

    private void FixedUpdate()
    {
       /* Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit rayInfo;*/

        //Check to see if you're a unique client
        if(playerManager.id == Client.instance.myId)
        {
            Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit rayInfo;

            if (platformCollider.Raycast(cameraRay, out rayInfo, 30f))
            {
                Vector3 pointToLook = cameraRay.GetPoint(rayInfo.distance);
                Debug.DrawLine(cameraRay.origin, pointToLook, Color.blue);
                transform.LookAt(new Vector3(pointToLook.x, transform.position.y, pointToLook.z));
            }

            SendInputToServer();
        }
       
    }

    /// <summary>Sends player input to the server.</summary>
    private void SendInputToServer()
    {
        bool[] _inputs = new bool[]
        {
            Input.GetKey(KeyCode.W),
            Input.GetKey(KeyCode.S),
            Input.GetKey(KeyCode.A),
            Input.GetKey(KeyCode.D),
            Input.GetButton("Jump")
        };

        ClientSend.PlayerMovement(_inputs);
    }

}
