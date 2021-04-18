using System.Collections;
using UnityEngine;

public class FloatingController : MonoBehaviour
{
    [SerializeField]
    private GameObject tea;
    [SerializeField]
    private Rigidbody rigidbody;
    [SerializeField]
    private float depthBeforeSubmerged = 1f;
    [SerializeField]
    private float displacementAmount = 3f;
    [SerializeField]
    private int floaterCount = 1;
    [SerializeField]
    private float teaDrag = 0.99f;
    [SerializeField]
    public float teaAngularDrag = 0.5f;

    private float depthModier;

    void Start()
    {
        // At runtime determine the amount of the floaters attached to the rigidbody
        foreach (Transform child in rigidbody.transform)
        {
            if (child.gameObject.GetComponent<FloatingController>() != null)
            {
                floaterCount++;
            }
        }
        // And also get the ref to the tea that the floater will be tested against
        tea = GameObject.FindGameObjectWithTag("Tea");
    }
    private void FixedUpdate()
    {
        rigidbody.AddForceAtPosition(Physics.gravity / floaterCount, transform.position, ForceMode.Acceleration);

        float teaHeight = tea.transform.position.y + depthModier;
        if (transform.position.y < teaHeight)
        {
            float displacementMultiplier = Mathf.Clamp01((teaHeight - transform.position.y) / depthBeforeSubmerged) * displacementAmount;
            rigidbody.AddForceAtPosition(new Vector3(0f, Mathf.Abs(Physics.gravity.y) * displacementMultiplier, 0.0f), transform.position, ForceMode.Acceleration);
            rigidbody.AddForce(displacementMultiplier * -rigidbody.velocity * teaDrag * Time.fixedDeltaTime, ForceMode.VelocityChange);
            rigidbody.AddTorque(displacementMultiplier * -rigidbody.angularVelocity * teaAngularDrag * Time.fixedDeltaTime, ForceMode.VelocityChange);
        }
    }

    public void sinkDown()
    {
        depthModier = depthBeforeSubmerged * -6;
    }

    public IEnumerator raiseUp(float raiseTime)
    {
        Debug.Log("raiseUp");
        float newDepthModier = depthBeforeSubmerged * 2.0f;
        float oldDepthModier = depthModier;

        float timer = 0.0f;
        while (timer < raiseTime)
        {
            timer += Time.deltaTime;
            float normTime = timer / raiseTime;
            depthModier = Mathf.SmoothStep(oldDepthModier, newDepthModier, normTime);
            Debug.Log(depthModier);
        }

            yield return new WaitForEndOfFrame();
    }

    public void reset()
    {
        depthModier = 0;
    }
}
