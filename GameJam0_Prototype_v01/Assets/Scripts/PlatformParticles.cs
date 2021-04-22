using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformParticles : MonoBehaviour
{
    bool IsPlaying;
    public ParticleSystem ripple;
    // public ParticleSystem sinkingParticles;
    private PlatformController platform;
    public Color col;

    // Start is called before the first frame update
    void Start()
    {
        platform = this.GetComponent<PlatformController>();
        ripple.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
    }

    // Update is called once per frame
    void Update()
    {
        PlaySinkParticles();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {

            ripple.Play();

        }

    }

    private void PlaySinkParticles()
    {
        if (platform.state == PlatformState.SINKING)
        {
            //sinkingParticles.Play();
            Debug.Log("Is this a jojo reference");
            var renderer = platform.gameObject.GetComponent<Renderer>();
            renderer.material.color = col;

        }
    }
}
