using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class CounterSystem : MonoBehaviour
{
    public TextMeshProUGUI checkpointDisplay;
    [SerializeField] int maxCheckpoint;
    public static int checkpointCount;

    private void Start()
    {
        //maxCheckpoint = 4;
    }

    private void Update()
    {
        if (checkpointDisplay != null && checkpointCount <= maxCheckpoint)
        {
            checkpointDisplay.SetText(checkpointCount + " / " + maxCheckpoint);
        }
     
    }
}
