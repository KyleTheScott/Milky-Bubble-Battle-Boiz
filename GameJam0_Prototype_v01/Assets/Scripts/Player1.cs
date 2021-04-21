using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using TMPro;
using System.Security.Cryptography;
using UnityEngine.InputSystem;

public class Player1 : MonoBehaviour
{

    [Header("Player Attack Stats")]
    // Ranged Attack
    [SerializeField]
    private int ammoCount;
    [SerializeField]
    private int ammoLimit;
    [SerializeField]
    private Queue<GameObject> ammoQueue = new Queue<GameObject>();

    // Melee Attack
    [SerializeField]
    private LayerMask platformLayer;
    [SerializeField]
    private float knockbackForce;
    [SerializeField]
    private float attackRate = 1f;
    [SerializeField]
    private LayerMask playerLayer;
    private bool ready2Atttack;
    private bool shootInput;

    [Header("Player UI")]
    [SerializeField]
    private PlayerHUD playerHUD;

    [Header("Player Movement")]
    [SerializeField]
    private bool isGrounded;
    [SerializeField]
    private float movementSpeed = 2f;
    [SerializeField]
    private float jumpForce = 50f;
    [SerializeField]
    private bool isStunned = false;
    [SerializeField]
    private float maxVelocity = 4f;
    [SerializeField]
    private float jumpThreshold = 0.1f;
    [SerializeField]
    private float landingCheckDelay = 0.1f;
    private bool isJumping;

    Vector2 move;
    Vector2 rotate;

    [Header("Player Absorbing")]
    [SerializeField]
    private bool isAbsorbing;
    [SerializeField]
    private float playerAbsorbRadius = 0.6f;
    private PlatformController targetPlatform = null;
    private PlatformController onPlatform = null;
    private bool absorbInput;

    [Header("Component Refs")]
    public Rigidbody playerRigidbody;
    public GameObject jumpMarker;
    public GameObject projectile;

    [Header("Player Comp Stats")]
    PlayerConfiguration playerConfiguration;
    PlayerControls controls;
    public int playerID { get; private set; } = 0;
    public bool isKnockedOut { get; private set; } = false;

    [Header("Player Animation")]
    public Animator anim;
    public Animator StrawAnim;

    private float inputH;
    private float inputV;

    //Everything Sound Related
    /*[Header("Player Sound")] Old Sound variables
    [SerializeField]
    private AudioSource playerAudio;
    [SerializeField]
    private AudioClip bulletHit, absorbSound, strawSuckSound;
    */

    // Unused variables
    //public static int playerIndex = 0;
    //private float inputH2;
    //private float inputV2;
    //private Collider groundCollider;
    //public bool testVel;
    //public TextMeshProUGUI ammoCountText;
    //public static int playerIndex = 0;
    //private float inputH2;
    //private float inputV2;
    //private Collider groundCollider;
    //[SerializeField]
    //private float absorbingTime = 3f;
    //private float currentAbsorbingTime;

    void Awake()
    {
        InvokeRepeating(nameof(LandingCheck), landingCheckDelay, 0.1f);
        controls = new PlayerControls();
        playerRigidbody = GetComponent<Rigidbody>();
        ready2Atttack = true;
        isAbsorbing = false;

        //UpdateAmmoHUD();
        //resetPosition = transform.position;
    }

    public void InitializePlayer(PlayerConfiguration pc, PlayerHUD playerHUD)
    {
        playerConfiguration = pc;
        playerConfiguration.Input.onActionTriggered += Input_onActionTriggered;

        playerID = pc.PlayerIndex;

        this.playerHUD = playerHUD;
        this.playerHUD.PlayerImage.texture = playerConfiguration.PlayerCharacter.ItemSprite.texture;
        if (playerConfiguration.PlayerOutfit.ItemSprite != null)
        {
            this.playerHUD.PlayerCosmetic.texture = playerConfiguration.PlayerOutfit.ItemSprite.texture;
            Color tempColor = this.playerHUD.PlayerCosmetic.color;
            tempColor.a = 1;
            this.playerHUD.PlayerCosmetic.color = tempColor;
        }

        UpdateAmmoHUD();
    }

    private void Input_onActionTriggered(InputAction.CallbackContext obj)
    {
        if (obj.action.name == controls.Gameplay.Jump.name)
        {
            OnJump(obj);
        }
        if (obj.action.name == controls.Gameplay.Move.name)
        {
            OnMove(obj);
        }
        if (obj.action.name == controls.Gameplay.Rotate.name)
        {
            OnRotate(obj);
        }
        if (obj.action.name == controls.Gameplay.Absorb.name)
        {
            Absorb(obj);
        }
        if (obj.action.name == controls.Gameplay.Attack.name)
        {
            Shoot(obj);
        }
    }

    private void OnEnable()
    {
        controls.Gameplay.Enable();
    }

    private void OnDisable()
    {
        controls.Gameplay.Disable();
    }

    public void OnMove(InputAction.CallbackContext ctx) => move = ctx.ReadValue<Vector2>();
    public void OnJump(InputAction.CallbackContext ctx) => isJumping = ctx.ReadValueAsButton();
    public void OnRotate(InputAction.CallbackContext ctx) => rotate = ctx.ReadValue<Vector2>();


    public void Absorb(InputAction.CallbackContext ctx)
    {
        if (ctx.started)
        {
            Debug.Log("Absorb");
            absorbInput = true;
        }
        else if (ctx.canceled)
        {
            Debug.Log("StopAbosrb");
            absorbInput = false;
        }

    }

    public void Shoot(InputAction.CallbackContext ctx)
    {
        if (ctx.started)
        {
            Debug.Log("Shoot");
            shootInput = true;
        }
        else if (ctx.canceled)
        {
            Debug.Log("StopShooting");
            shootInput = false;
        }
    }




    // Update is called once per frame
    void FixedUpdate()
    {
        inputH = move.x;
        inputV = move.y;



        anim.SetFloat("inputH", inputH);
        anim.SetFloat("inputV", inputV);

        if (!isAbsorbing && !isStunned)
        {



            //Uncomment from here to get previous implementation

            // Movement Handling 
            /* Vector3 movementVector = new Vector3(Input.GetAxis("Horizontal"), 0.0f, Input.GetAxis("Vertical"));
             transform.position += (movementVector * movementSpeed * Time.deltaTime);

             // Get the Screen position of the mouse
             Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
             RaycastHit rayInfo;

             if (platformCollider.Raycast(cameraRay, out rayInfo, 30f))
             {
                 Vector3 pointToLook = cameraRay.GetPoint(rayInfo.distance);
                 Debug.DrawLine(cameraRay.origin, pointToLook, Color.blue);
                 transform.LookAt(new Vector3(pointToLook.x, transform.position.y, pointToLook.z));
             }*/

            // End -- uncomment


            //Raycast to the ground and put a placement marker when jumping
            RaycastHit jumpHit;

            if (Physics.Raycast(transform.position, -Vector3.up, out jumpHit))
            {
                Debug.DrawLine(transform.position, jumpHit.point, Color.cyan);

                if (!isGrounded)
                {
                    jumpMarker.transform.position = jumpHit.point + new Vector3(0, 0.2f, 0);
                    jumpMarker.SetActive(true);

                    if (transform.position.y + 0.5f > jumpHit.point.y)
                    {
                        anim.SetBool("isGrounded", false);
                    }

                }
                else
                {
                    jumpMarker.SetActive(false);
                    anim.SetBool("isJumping", false);
                    anim.SetBool("isGrounded", true);
                }

            }


            //Player Movement

            Vector3 movementVector = new Vector3(inputH, 0.0f, inputV);
            //Debug.Log("Input H:" + inputH + " || Input V:" + inputV + " || Movement Vector:" + movementVector);
            transform.position += (movementVector * movementSpeed * Time.deltaTime);


            //Check input for keyboard/mouse or controller
            //Raycast using mouse for keyboard/mouse, right stick input for controller 
            Ray cameraRay;

            if (playerConfiguration.Input.currentControlScheme.Contains("Mouse") || playerConfiguration.Input.currentControlScheme.Contains("Keyboard"))
            {

                cameraRay = Camera.main.ScreenPointToRay(rotate);

                RaycastHit rayInfo;

                if (Physics.Raycast(cameraRay, out rayInfo, Mathf.Infinity))
                {
                    Vector3 pointToLook = cameraRay.GetPoint(rayInfo.distance);
                    transform.LookAt(new Vector3(pointToLook.x, transform.position.y, pointToLook.z));
                }


            }
            else
            {

                Vector3 joystickDirection = new Vector3(rotate.x, 0, rotate.y);
                Vector3 currentPos = transform.position;
                Vector3 facePos = currentPos + joystickDirection;

                transform.LookAt(facePos);
            }

            if (isJumping && isGrounded)
            {
                anim.SetBool("isJumping", true);
                playerRigidbody.AddForce(Vector3.up * jumpForce);
                Debug.Log(jumpForce);
            }

            if (shootInput && ready2Atttack)
            {
                // Do a quick check  for any players right in front of the player
                Collider[] hitPlayers = Physics.OverlapSphere(transform.position + transform.forward * 1.5f, 1.0f, playerLayer);


                if (hitPlayers.Length > 0)
                {
                    StartCoroutine(MeleeAttack(hitPlayers));
                }

                else if (ammoCount > 0)
                {
                    StartCoroutine(Fire());
                }

            }
        }

        // Absorbing a platform
        // TODO: Animations will be added in later
        /*   if (absorbInput && isGrounded && currentAbsorbingTime < absorbingTime )
           {
               currentAbsorbingTime += Time.deltaTime;
               Debug.Log("SUCKING");

           } else if ( currentAbsorbingTime >= absorbingTime) {
               ammoCount++;
               ammoCountText.text = ammoCount + "";
               currentAbsorbingTime = 0;
               Debug.Log("COUNTED");
               return;

           } else
           {

               currentAbsorbingTime = 0;
           }


           if (!absorbInput && isAbsorbing)
           {
               Debug.Log("Stop Absorbing");
               targetPlatform.ResetPlatform();
               isAbsorbing = false;
               targetPlatform = null;
           }*/

        if (absorbInput && isGrounded && !isAbsorbing)
        {
            Debug.Log("Trying to find a platform");
            // Perform a sphere cast in front of the player
            var colliderHits = Physics.OverlapSphere(transform.position + transform.forward * 1.5f, playerAbsorbRadius, platformLayer);

            //Debug.Draw
            // Check if there was a hit
            if (colliderHits.Length > 0)
            {
                Debug.Log("Found objects in the sphere cast");
                // Go through each hit

                float targetDistance = Vector3.Distance(colliderHits[0].transform.position, transform.position);

                foreach (var hit in colliderHits)
                {
                    var platform = hit.gameObject.GetComponent<PlatformController>();
                    // See if it was a platform, a valid platform, that the player can take all its ammo, and is the closest to the player 
                    if (platform != null &&
                        platform != onPlatform &&
                        platform.canAbsorb &&
                        platform.ammoValue <= ammoLimit - ammoCount)
                    {
                        float distance = Vector3.Distance(platform.transform.position, transform.position);
                        if (distance < targetDistance)
                        {
                            targetPlatform = platform;
                        }
                    }
                }



                if (targetPlatform != null)
                {
                    anim.SetBool("isAbsorbing", true);

                    Debug.Log("Platform targeted");

                    //var renderer = targetPlatform.gameObject.GetComponent<Renderer>();
                    //renderer.material.color = Color.white;

                    // this is the platform target and now it will be brought towards the player
                    isAbsorbing = true;
                    // TODO: Figure out a method to bring the sphere to the player
                    targetPlatform.StartCoroutine(targetPlatform.BecomeAmmo(gameObject));

                }

            }


        }

        if (!absorbInput)
        {
            anim.SetBool("isAbsorbing", false);            
        }

        if (!absorbInput && isAbsorbing)
        {
            Debug.Log("Stop Absorbing");
            if (targetPlatform)
            {
                targetPlatform.ResetPlatform();
            }
            isAbsorbing = false;
            targetPlatform = null;
        }

        if (ammoCount != 0)
        {
            // ammoCountText.text = "" + ammoCount;
        }


        //Debug.Log("current velocity " + playerRigidbody.velocity.magnitude);

        if (playerRigidbody.velocity.magnitude >= maxVelocity)
        {
            playerRigidbody.velocity = playerRigidbody.velocity.normalized * maxVelocity;
        }
    }


    IEnumerator MeleeAttack(Collider[] hitPlayers)
    {
        Debug.Log("Performing Melee Attack");
        ready2Atttack = false;
        foreach (var player in hitPlayers)
        {
            // Apply knock-back force at each player
            //Rigidbody body = player.gameObject.GetComponent<Rigidbody>();
            //body.AddForce( transform.forward * knockbackForce, ForceMode.Impulse);
            Player1 enemy = player.gameObject.GetComponent<Player1>();
            enemy.ApplyKnockBack(transform.forward * knockbackForce, true, 1.0f);
        }
        yield return new WaitForSeconds(attackRate);
        ready2Atttack = true;
    }

    IEnumerator Fire()
    {
        ready2Atttack = false;
        /*var newBullet = ammoQueue.Dequeue();
        Debug.Log(newBullet);
        newBullet.SetActive(true);
        newBullet.transform.position = transform.position + (transform.forward * 0.75f) + (transform.up * 0.8f);
        newBullet.GetComponent<BulletController>().FireBullet(transform.forward);*/

        anim.SetBool("isShooting", true);
        ammoCount--;
        yield return new WaitForSeconds(.9f);
        anim.SetBool("isShooting", false);




        Instantiate(projectile, transform.position + transform.forward + new Vector3(0, 0.4f, 0), transform.rotation);

        UpdateAmmoHUD();
        yield return new WaitForSeconds(attackRate);
        ready2Atttack = true;
    }



    IEnumerator RecoverFromStun(float recoverTime = 1.0f)
    {
        if (isStunned)
        {
            StopCoroutine(nameof(RecoverFromStun));
        }
        else
        {
            Debug.Log("Stunned");
            isStunned = true;
        }
        yield return new WaitForSeconds(recoverTime);
        isStunned = false;
    }

    void OnCollisionEnter(Collision collision)
    {

        if (collision.gameObject.tag == "Platform")
        {
            var platform = collision.gameObject.GetComponent<PlatformController>();
            switch (platform.state)
            {
                // Hitting a platform that's floating or sinking means the player is grounded
                case PlatformState.FLOATING:

                case PlatformState.SINKING:
                    onPlatform = platform;
                    isGrounded = true;
                    break;
            }
        }

        if (collision.gameObject.tag == "Cup")
        {
            if (playerRigidbody.velocity.magnitude < 0.5f)
            {
                playerRigidbody.constraints = RigidbodyConstraints.None;
            }

            //playerRigidbody.constraints = RigidbodyConstraints.None;
        }


    }

    public void ApplyKnockBack(Vector3 force, bool applyStun = false, float stunTime = 1.0f)
    {
        Debug.Log("ApplyKnockBack");
        playerRigidbody.AddForce(force, ForceMode.Impulse);

        if (applyStun)
        {
            StartCoroutine(RecoverFromStun(stunTime));
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawWireSphere(transform.position + transform.forward * 1.5f, 0.6f);
        //Gizmos.DrawWireSphere(transform.position + transform.forward * 2.5f, 2.0f);
    }

    private void LandingCheck()
    {
        if (Physics.Raycast(transform.position, -transform.up, out RaycastHit hit, 100f, platformLayer))
        {
            if ((hit.distance < jumpThreshold) || isGrounded)
            {
                isGrounded = true;
                CancelInvoke(nameof(LandingCheck));
            }
        }
    }


    void OnCollisionExit(Collision other)
    {
        if (other.gameObject.tag == "Platform")
        {
            isGrounded = false;
            onPlatform = null;
            InvokeRepeating(nameof(LandingCheck), landingCheckDelay, 0.1f);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Platform")
        {
            var platform = other.gameObject.GetComponent<PlatformController>();
            // Hitting a platform that's can be absorbed gives the player ammo and then disappears

            if (isAbsorbing && platform.state == PlatformState.ABSORBED)
            {
                Debug.Log("Absorbed a platform");
                ammoCount = Mathf.Clamp(ammoCount + platform.ammoValue, ammoCount, ammoLimit);
                isAbsorbing = false;
                targetPlatform = null;
                for (int i = 0; i < platform.ammoValue; i++)
                {
                    ammoQueue.Enqueue(BulletManager.Instance.GetBullet());
                }
                UpdateAmmoHUD();
                Destroy(other.gameObject);

            }
            else
            {
                // apply knock-back on the player
            }
        }
        
    }
    void OnTriggerStay(Collider col)
    {
        if (col.gameObject.tag == "Platform")
        {
            //isGrounded = true;
        }

    }

    private void OnCollisionStay(Collision collision)
    {
        /*if (collision.gameObject.tag == "Platform")
        {
            groundCollider = collision.collider;
        }*/

    }

    void UpdateAmmoHUD()
    {
        playerHUD.ammoText.SetText(ammoCount + " / " + ammoLimit);
        /*  playerHUD.ammoText.text = ammoCount + " / " + ammoLimit;

          if (ammoQueue.Count > 0)
          {
              Debug.Log("Set bullet image");
              playerHUD.NextBullet.sprite = ammoQueue.Peek().GetComponent<BulletController>().BulletImage;
          }
          else
          {
              playerHUD.NextBullet.sprite = null;
          }*/
    }

    public void OnPlayerKnockOut()
    {
        Debug.Log("Player has been knocked out");
        isKnockedOut = true;
        playerHUD.BlackOutImage.gameObject.SetActive(true);
        gameObject.SetActive(false);
    }

    public PlayerConfiguration GetPlayerConfig() 
    {
        return playerConfiguration;
    }

    //old sound functions.  update with fmod
    /*
    public void PlayHitSound()
    {
        playerAudio.clip = bulletHit;
        playerAudio.Play();
    }

    public void PlayAbsorbSound()
    {
        playerAudio.clip = absorbSound;
        playerAudio.Play();
    }
    */

}



