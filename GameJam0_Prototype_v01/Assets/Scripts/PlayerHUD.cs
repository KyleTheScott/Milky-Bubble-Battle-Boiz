using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PlayerHUD : MonoBehaviour
{
    public RawImage Background;
    public RawImage PlayerImage;
    public RawImage PlayerCosmetic;
    public TextMeshProUGUI ammoText;
    public RawImage NextBullet;
    public RawImage BlackOutImage;

    private void Start()
    {
        BlackOutImage.gameObject.SetActive(false);
    }
}
