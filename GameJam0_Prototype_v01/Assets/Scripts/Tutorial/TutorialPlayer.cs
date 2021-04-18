using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using TMPro;
using System.Security.Cryptography;
using UnityEngine.InputSystem;

public class TutorialPlayer : MonoBehaviour
{
    [Header("Player Attack Stats")]

    // Ranged Attack
    [SerializeField]
    private int ammoCount;
    [SerializeField]
    private int ammoLimit;
    [SerializeField]
    private Queue<GameObject> ammoQueue = new Queue<GameObject>();
    [SerializeField]
    private Animator anim;

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
    private float jumpThreshold = 0.1f;
    [SerializeField]
    private float landingCheckDelay = 0.1f;
    [SerializeField]
    private bool isStunned = false;

    //input check bools
    [SerializeField]
    private bool inputEnabled = false;
    [SerializeField]
    private bool movementEnabled = false;
    [SerializeField]
    private bool attackingEnabled = false;
    [SerializeField]
    private bool absorbingEnabled = false;

    [Header("Player Absorbing")]

    [SerializeField]
    private bool isAbsorbing;

    private PlatformController targetPlatform = null;

    [Header("Component Refs")]

    public Rigidbody playerRigidbody;
    public GameObject jumpMarker;


    private Vector3 resetPosition;
    [SerializeField]
    private LayerMask deathMask;

    public int playerID;

    private float inputH;
    private float inputV;

    private float inputH2;
    private float inputV2;


    // UnUsed Variables

    // public TextMeshPro mText;

    // public GameObject projectile;

    //public Animator anim;

    //[SerializeField]
    //private int projectileLayer;



    void Awake()
    {
        anim = GetComponent<Animator>();
        playerRigidbody = GetComponent<Rigidbody>();
        ready2Atttack = true;
        isAbsorbing = false;
        UpdateAmmoHUD();
        InvokeRepeating(nameof(LandingCheck), landingCheckDelay, 0.1f);
        resetPosition = transform.position;
    }

    // Update is called once per frame
    void FixedUpdate()
    {

        /*  if(playerID == 1)
          {
              inputH = Input.GetAxis("HorizontalArrow");
              inputV = Input.GetAxis("VerticalArrow");
          } else
          {*/
        //}

        if (!isAbsorbing && !isStunned)
        {
            if(movementEnabled)
            {
                inputH = Input.GetAxis("Horizontal");
                inputV = Input.GetAxis("Vertical");

                /* anim.SetFloat("inputH", inputH);
                 anim.SetFloat("inputV", inputV);*/


                //Uncomment from here to get previous implementation

                // Movement Handling 
                Vector3 movementVector = new Vector3(Input.GetAxis("Horizontal"), 0.0f, Input.GetAxis("Vertical"));
                transform.position += (movementVector * movementSpeed * Time.deltaTime);

                // Get the Screen position of the mouse
                Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
                RaycastHit rayInfo;

                if (Physics.Raycast(cameraRay, out rayInfo, 30f))
                {
                    Vector3 pointToLook = cameraRay.GetPoint(rayInfo.distance);
                    Debug.DrawLine(cameraRay.origin, pointToLook, Color.blue);
                    transform.LookAt(new Vector3(pointToLook.x, transform.position.y, pointToLook.z));
                }

                // End -- uncomment

                /* RaycastHit jumpHit;

                 if (Physics.Raycast(transform.position, -Vector3.up, out jumpHit))
                 {
                     Debug.DrawLine(transform.position, jumpHit.point, Color.cyan);

                     if (!isGrounded)
                     {
                         jumpMarker.transform.position = jumpHit.point + new Vector3(0, 0.2f, 0);
                         jumpMarker.SetActive(true);
                     } else
                     {
                         jumpMarker.SetActive(false);
                     }

                 }*/


                // For testing local game design
                //Vector3 direction = new Vector3(0, 0, inputV);
                //transform.Translate(direction * movementSpeed * Time.deltaTime);

                //transform.Rotate(0, inputH * 200 * Time.deltaTime, 0);

                /* Vector3 direction = new Vector3(inputH, 0, inputV);

                 transform.position += (direction * movementSpeed * Time.deltaTime);

                 if (direction.magnitude > float.Epsilon)
                 {
                     transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(direction), 0.1F);
                 }*/



                // End - For testing local game design


                if (Input.GetButton("Jump") && isGrounded)
                {
                    Debug.Log("Is Jumping");
                    playerRigidbody.AddForce(Vector3.up * jumpForce);
                }
            }

            
            if(attackingEnabled)
            {
                if (Input.GetButton("Fire1") && ready2Atttack)
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

        }

        if(absorbingEnabled)
        {
            // Absorbing a platform
            // TODO: Animations will be added in later
            if (Input.GetButton("Fire2") && isGrounded && !isAbsorbing)
            {
                //Debug.Log("Trying to find a platform");
                // Perform a sphere cast in front of the player
                var colliderHits = Physics.OverlapSphere(transform.position + transform.forward * 2.5f, 2.0f, platformLayer);
                // Check if there was a hit
                if (colliderHits.Length > 0)
                {
                    //Debug.Log("Found objects in the sphere cast");
                    // Go through each hit
                    float targetDistance = Mathf.Infinity;

                    foreach (var hit in colliderHits)
                    {
                        var platform = hit.gameObject.GetComponent<PlatformController>();
                        // See if it was a platform, a valid platform, that the player can take all its ammo, and is the closest to the player 
                        if (platform != null &&
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

                    // Now check if we gotten a valid platform to grab
                    if (targetPlatform != null)
                    {
                        Debug.Log("Platform targeted");
                        // this is the platform target and now it will be brought towards the player
                        isAbsorbing = true;
                        // TODO: Figure out a method to bring the sphere to the player
                        targetPlatform.StartCoroutine(targetPlatform.BecomeAmmo(gameObject));

                    }

                }
            }
            if (!Input.GetButton("Fire2") && isAbsorbing)
            {
                Debug.Log("Stop Absorbing");
                targetPlatform.ResetPlatform();
                isAbsorbing = false;
                targetPlatform = null;
            }
        }

    }
    IEnumerator Fire()
    {
        ready2Atttack = false;
        var newBullet = ammoQueue.Dequeue();
        newBullet.SetActive(true);
        newBullet.transform.position = transform.position + (transform.forward * 0.75f) + (transform.up * 0.8f);
        newBullet.GetComponent<BulletController>().FireBullet(transform.forward);
        ammoCount--;
        UpdateAmmoHUD();
        yield return new WaitForSeconds(attackRate);
        ready2Atttack = true;
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
            Player enemy = player.gameObject.GetComponent<Player>();
            enemy.ApplyKnockBack(Vector3.Normalize(transform.up + transform.forward) * knockbackForce, true, 1.0f);
        }
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

    //void OnCollisionEnter(Collision collision)
    //{

    //    if (collision.gameObject.tag == "Platform")
    //    {
    //        var platform = collision.gameObject.GetComponent<PlatformController>();
    //        switch (platform.state)
    //        {
    //            // Hitting a platform that's floating or sinking means the player is grounded
    //            case PlatformState.FLOATING:

    //            case PlatformState.SINKING:
    //                isGrounded = true;
    //                break;
    //        }            
    //    }
    //}

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawWireSphere(transform.position + transform.forward * 1.5f, 1.0f);
    }
    void OnCollisionExit(Collision other)
    {
        if (other.gameObject.tag == "Platform")
        {
            Debug.Log("OnCollisionExit");
            isGrounded = false;
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

        if (other.gameObject.CompareTag("DeathLayer"))
        {
            transform.position = resetPosition;
        }
    }
    void OnTriggerStay(Collider col)
    {
        if (col.gameObject.tag == "Platform")
        {
            //isGrounded = true;
        }

    }

    void UpdateAmmoHUD()
    {
        playerHUD.ammoText.text = ammoCount + " / " + ammoLimit;

        if (ammoQueue.Count > 0)
        {
            Debug.Log("Set bullet image");
            playerHUD.NextBullet.texture = ammoQueue.Peek().GetComponent<BulletController>().BulletImage.texture;
        }
        else
        {
            playerHUD.NextBullet.texture = null;
        }
    }

    void UpdatePlayerImage()
    {

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


    public float getPlayermovementSpeed()
    {
        return movementSpeed;
    }

    public int getAmmoCount()
    {
        return ammoCount;
    }


    //input getters and setters
    public bool getInputEnabled()
    {
        return inputEnabled;
    }

    public void setInputEnabled(bool isEnabled)
    {
        inputEnabled = isEnabled;
    }

    public bool getMovementEnabled()
    {
        return movementEnabled;
    }

    public void setMovementEnabled(bool isEnabled)
    {
        movementEnabled = isEnabled;
    }

    public bool getAttackingEnabled()
    {
        return attackingEnabled;
    }

    public void setAttackingEnabled(bool isEnabled)
    {
        attackingEnabled = isEnabled;
    }

    public bool getAbsorbingEnabled()
    {
        return absorbingEnabled;
    }

    public void setAbsorbingEnabled(bool isEnabled)
    {
        absorbingEnabled = isEnabled;
    }
}
