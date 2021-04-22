using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//a script that holds all FMOD events
public class FMODSoundManager : MonoBehaviour
{
    //used to stop all sounds when moving to next scene
    FMOD.Studio.Bus masterBus;

    //----------------------------------------------------------
    //FMOD SOUNDS
    //----------------------------------------------------------

    //Platform sounds
    FMOD.Studio.EventInstance sinkWarning;
    FMOD.Studio.EventInstance dropLight, dropHeavy;
    FMOD.Studio.EventInstance platformAbsorb;

    FMOD.Studio.EventInstance platformWalkTapioca, platformWalkJelly, platformWalkIce;

    //player sounds
    FMOD.Studio.EventInstance playerSink, playerAbsorbedAmmo, playerShoot;

    //menu sounds
    FMOD.Studio.EventInstance menuSelection;
    FMOD.Studio.EventInstance baristaChatter;

    //countdown event
    FMOD.Studio.EventInstance countdown;

    //jumping tutorial
    FMOD.Studio.EventInstance tutorialJump1, tutorialJump2, tutorialJump3, tutorialJump4, tutorialJump5;

    //shooting tutorial
    FMOD.Studio.EventInstance tutorialShoot1, tutorialShoot2, tutorialShoot3, tutorialShoot4;

    //fell into the tea in tutorial
    FMOD.Studio.EventInstance tutorialFall;

    // Start is called before the first frame update
    void Start()
    {
        //initialize the fmod bus
        masterBus = FMODUnity.RuntimeManager.GetBus("Bus:/");

        //initialize platform sink sounds
        sinkWarning = FMODUnity.RuntimeManager.CreateInstance("event:/Arena/Platform_Sink_Indicator");
        dropLight = FMODUnity.RuntimeManager.CreateInstance("event:/Arena/Light_Platform_Sink");
        dropHeavy = FMODUnity.RuntimeManager.CreateInstance("event:/Arena/Heavy_Platform_Sink");

        //initialize platform absorb sound
        platformAbsorb = FMODUnity.RuntimeManager.CreateInstance("event:/Arena/Platform_Absorb_Straw");

        //initialize player sounds
        playerSink = FMODUnity.RuntimeManager.CreateInstance("event:/Player/Player_Sink");
        playerAbsorbedAmmo = FMODUnity.RuntimeManager.CreateInstance("event:/Player/Platform_Absorb_Pop");
        playerShoot = FMODUnity.RuntimeManager.CreateInstance("event:/Player/Sraw_Shoot");

        //initialize menu sounds
        menuSelection = FMODUnity.RuntimeManager.CreateInstance("event:/Menu/Menu_Option_Sound");
        baristaChatter = FMODUnity.RuntimeManager.CreateInstance("event:/Menu/Barrista_Main_Menu_Idle_Chat");

        //initialize countdown sound
        countdown = FMODUnity.RuntimeManager.CreateInstance("event:/Arena/Barrista_Countdown");

        //-----------------------------------------------------------------------------------
        //TUTORIAL SOUNDS
        //-----------------------------------------------------------------------------------
        //jump tutorial sounds
        tutorialJump1 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Menu_Transition_This_Here");
        tutorialJump2 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Menu_Transition_It_Is_Surprisingly");
        tutorialJump3 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barristal_Tutorial_Menu_Transition_This_Is_Brown");
        tutorialJump4 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Menu_Transition_Standing");
        tutorialJump5 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Menu_Transition_You_Did_It");

        //shoot tutorial
        tutorialShoot1 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Shoot_Transition_In_The_Top");
        tutorialShoot2 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Shoot_Transition_Awesome");
        tutorialShoot3 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Shoot_Transition_Great");
        tutorialShoot4 = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Shoot_Transition_Amazing");

        tutorialFall = FMODUnity.RuntimeManager.CreateInstance("event:/Tutorial/Barrista_Tutorial_Fall_Transition");

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    //stop all sound events
    public void StopAllSounds()
    {
        masterBus.stopAllEvents(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
        Debug.Log("Stopping all sounds");
    }

    //for the menu selection
    public void PlayMenuSelection()
    {
        menuSelection.start();
    }

    public void PlayBaristaChatter()
    {
        baristaChatter.start();
    }

    #region Platform Sounds
    //platform sink sounds
    public void PlaySinkWarning()
    {
        sinkWarning.start();
    }

    public void PlaySinkLight()
    {
        dropLight.start();
    }

    public void PlaySinkHeavy()
    {
        dropLight.start();
    }

    //platform absorb sounds
    public void PlayPlatformAbsorb()
    {
        platformAbsorb.start();
        Debug.Log("Playing Absorb Sound");
    }

    public void StopPlatformAbsorb()
    {
        platformAbsorb.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }

    //walking on top of platforms

    #endregion

    #region Player Sounds

    public void PlayPlayerSink()
    {
        playerSink.start();
    }

    public void PlayPlayerAbsorbedAmmo()
    {
        playerAbsorbedAmmo.start();
    }

    public void PlayPlayerShoot()
    {
        playerShoot.start();
    }

    #endregion

    #region Countdown Events

    public void PlayCountdownInitial()
    {
        countdown.start();
    }

    public void PlayCountdownNext()
    {
        countdown.triggerCue();
    }

    #endregion

    #region Tutorial Barista Voice Clips

    //jumping tutorial
    public void PlayTutorialJumpThisIsOurMilkTea()
    {
        tutorialJump1.start();
    }

    public void PlayTutorialJumpSurprisinglyTasty()
    {
        tutorialJump2.start();
    }

    public void PlayTutorialJumpBrownSugarMostPopular()
    {
        tutorialJump3.start();
    }

    public void PlayTutorialJumpMoveQuickly()
    {
        tutorialJump4.start();
    }

    public void PlayTutorialJumpYouDidIt()
    {
        tutorialJump5.start();
    }

    //shooting tutorial
    public void PlayTutorialShootLetsAbsorbAmmo()
    {
        tutorialShoot1.start();
    }

    public void PlayTutorialShootAwesomeGrantsAmmo()
    {
        tutorialShoot2.start();
    }

    public void PlayTutorialShootGreatFullyLoaded()
    {
        tutorialShoot3.start();
    }

    public void PlayTutorialShootAmazingTookOutDummies()
    {
        tutorialShoot4.start();
    }

    //falling into the tea
    public void PlayTutorialFall()
    {
        tutorialFall.start();
    }

    #endregion

}
