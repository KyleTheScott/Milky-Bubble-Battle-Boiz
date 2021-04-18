using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlatformManager : MonoBehaviour
{
    [Header("PlatformStats")]
    [SerializeField]
    int sinkTime;
    [SerializeField]
    int raiseTime;
    [SerializeField]
    public bool canAbsorb;
    [SerializeField]
    public PlatformState state = PlatformState.FLOATING;
    [SerializeField]
    public int ammoValue;

    Vector3 velocity;

    float MinModifier = 7;
    float MaxModifier = 11;
    Vector3 playerPosition;

    [SerializeField]
    float outlineValue = 0.2f;
    [SerializeField]
    float ammoTime = 2.0f;

    void OnCollisionEnter (Collision collision)
    {
        if(collision.gameObject.tag == "Player" && state.Equals(PlatformState.FLOATING))
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
        // Wait a second
        yield return new WaitForSeconds(0.5f);

        // Start sinking the platform
        var Floaters = GetComponentsInChildren<FloatingController>();
        foreach (var floater in Floaters)
        {
            floater.sinkDown();
        }

        // Afterwards destory the object;
        yield return new WaitForSeconds(0.5f);
        Destroy(gameObject);
        
    }

    public IEnumerator BecomeAmmo(Vector3 PlayerPosition)
    {
        StopCoroutine(StartDropTimer(sinkTime));
        
        // Set the target location
        playerPosition = PlayerPosition;
        // Start raising the platform
        var Floaters = GetComponentsInChildren<FloatingController>();
        foreach (var floater in Floaters)
        {   
           StartCoroutine(floater.raiseUp(ammoTime));
        }
        // Set the material of the platform to the outline with a new color
        GetComponent<Renderer>().material.SetFloat("_Outline", outlineValue);
        playerPosition = PlayerPosition;
        // Wait for a just abit for the platform to raise from the tea
        yield return new WaitForSeconds(ammoTime);
        // Set the new state
        state = PlatformState.ABSORBED;
        // Disable the floaters and rigidbody
        foreach (var floater in Floaters)
        {
            floater.enabled = false;
        }
        GetComponent<Rigidbody>().useGravity = false;

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
    }

    private void Update()
    {
        if (state.Equals(PlatformState.ABSORBED))
        {
            transform.position = Vector3.SmoothDamp(transform.position, playerPosition, ref velocity, Time.deltaTime * Random.Range(MinModifier, MaxModifier));
        }
    }


}
