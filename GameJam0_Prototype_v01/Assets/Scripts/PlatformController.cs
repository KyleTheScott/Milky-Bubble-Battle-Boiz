using System.Collections;
using UnityEngine;

public enum PlatformState { FLOATING, SINKING, RAISING, MOVING, ABSORBED }

public class PlatformController : MonoBehaviour
{
    [Header("PlatformStats")]
    [SerializeField]
    int sinkTime;
    [SerializeField]
    int raiseTime;
    [SerializeField]
    public bool canSink;
    [SerializeField]
    public bool canAbsorb;
    [SerializeField]
    public PlatformState state = PlatformState.FLOATING;
    [SerializeField]
    public int ammoValue;
    [SerializeField]
    float outlineValue = 0.2f;
    [SerializeField]
    float absorbTime = 2.0f;
    [SerializeField]
    float moveForce = 5.0f;

    // These values are for when the platform travels towards the player in order to be absorbed
    Vector3 velocity;
    float MinModifier = 7;
    float MaxModifier = 11;
    GameObject playerObject;

    FMODSoundManager soundManager;



    void Start()
    {
        soundManager = FindObjectOfType<FMODSoundManager>();
    }

    void OnCollisionEnter (Collision collision)
    {
        if(collision.gameObject.tag == "Player" && state.Equals(PlatformState.FLOATING) && canSink)
        {
            StartCoroutine(StartDropTimer(sinkTime));
        }      
    }

    private IEnumerator StartDropTimer(int dropTime)
    {
        yield return new WaitForSeconds(dropTime);
        StartCoroutine(Drop());
        
    }

    private IEnumerator Drop()
    {
        // Set the state to sinking
        state = PlatformState.SINKING;
        // Highlight the platform
        GetComponent<Renderer>().material.SetFloat("_Outline", outlineValue);

        //play the sink warning sound
        soundManager.PlaySinkWarning();

        // Wait a second
        yield return new WaitForSeconds(0.5f);

        // Start sinking the platform
        var Floaters = GetComponentsInChildren<FloatingController>();
        foreach (var floater in Floaters)
        {
            floater.sinkDown();
        }

        //play the sinking noise based on if the platform is light or heavy (light platforms can be absorbed)
        if(canAbsorb)
        {
            soundManager.PlaySinkLight();
        }
        else
        {
            soundManager.PlaySinkHeavy();
        }

        // Afterwards destroy the object;
        yield return new WaitForSeconds(0.5f);
        Destroy(gameObject);
        
    }

    public IEnumerator BecomeAmmo(GameObject player)
    {
        StopCoroutine(StartDropTimer(sinkTime));

        // Set the target object
        playerObject = player;
        // Set the new state
        state = PlatformState.MOVING;
        // Set the material of the platform to the outline with a new color
        GetComponent<Renderer>().material.SetFloat("_Outline", outlineValue);

        // Wait for a just abit for the platform to be fully absorbed
        yield return new WaitForSeconds(absorbTime);

        //need to play sound out of player object because the platform will destroy before sound completes
        if(player.GetComponent<Player1>())
        {
            Player1 p = player.GetComponent<Player1>();
            p.PlayAbsorbSound();
        }
        else
        {
            Player2 p = player.GetComponent<Player2>();
            p.PlayAbsorbSound();
        }
        

        state = PlatformState.ABSORBED;
        // Disable the floaters and rigid-body along with turning the collide into a trigger
        foreach (var floater in GetComponentsInChildren<FloatingController>())
        {
            floater.enabled = false;
        }
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<BoxCollider>().isTrigger = true;
    }

    public void ResetPlatform()
    {
        StopAllCoroutines();
        state = PlatformState.FLOATING;
        GetComponent<Renderer>().material.SetFloat("_Outline", 0.0f);
        var Floaters = GetComponentsInChildren<FloatingController>();
        foreach (var floater in Floaters)
        {
            floater.enabled = true;
            floater.reset();
        }
        GetComponent<Rigidbody>().useGravity = true;
        GetComponent<BoxCollider>().isTrigger = false;
    }

    private void Update()
    {

        if (state.Equals(PlatformState.ABSORBED))
        {
            if (playerObject == null)
            {
                // If for what ever reason the player who absorbed this object is gone, destroy this object for now
                Destroy(gameObject);
            }
            transform.position = Vector3.SmoothDamp(transform.position, playerObject.transform.position, ref velocity, Time.deltaTime * Random.Range(MinModifier, MaxModifier));
        }
        else if (state.Equals(PlatformState.MOVING))
        {
            Vector3 nomralDirection = Vector3.Normalize(playerObject.transform.position - transform.position);
            GetComponent<Rigidbody>().AddForce(nomralDirection * moveForce, ForceMode.Force);
        }
    }
}
